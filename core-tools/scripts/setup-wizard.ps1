#Requires -Version 5.1

<#
.SYNOPSIS
    Lab Framework Interactive Setup Wizard
.DESCRIPTION
    Guides new users through complete setup of the Lab Framework including
    MCP servers, Claude Code, and validation.
.EXAMPLE
    .\core-tools\scripts\setup-wizard.ps1
#>

param(
    [switch]$SkipPrerequisites,
    [switch]$Quiet
)

# Colors for better UX
$colors = @{
    'Success' = 'Green'
    'Warning' = 'Yellow' 
    'Error' = 'Red'
    'Info' = 'Cyan'
    'Prompt' = 'Magenta'
}

function Write-StepHeader {
    param([string]$Title, [int]$Step, [int]$Total)
    Write-Host ""
    Write-Host "=" * 60 -ForegroundColor $colors.Info
    Write-Host "  STEP ${Step}/${Total}: $Title" -ForegroundColor $colors.Info
    Write-Host "=" * 60 -ForegroundColor $colors.Info
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor $colors.Success
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor $colors.Warning
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor $colors.Error
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor $colors.Info
}

function Write-Prompt {
    param([string]$Message)
    Write-Host "🤔 $Message" -ForegroundColor $colors.Prompt
}

function Test-Prerequisites {
    Write-StepHeader "Prerequisites Check" 1 5
    
    $checks = @()
    
    # Check PowerShell version
    $psVersion = $PSVersionTable.PSVersion
    if ($psVersion.Major -ge 5) {
        Write-Success "PowerShell version: $psVersion"
        $checks += $true
    } else {
        Write-Error "PowerShell version too old: $psVersion (need 5.1+)"
        $checks += $false
    }
    
    # Check Node.js
    try {
        $nodeVersion = node --version 2>$null
        if ($nodeVersion) {
            $versionNumber = [Version]($nodeVersion -replace 'v','')
            if ($versionNumber.Major -ge 18) {
                Write-Success "Node.js version: $nodeVersion"
                $checks += $true
            } else {
                Write-Warning "Node.js version old: $nodeVersion (recommend 18+)"
                Write-Info "Visit https://nodejs.org/ to upgrade"
                $checks += $false
            }
        } else {
            Write-Warning "Node.js not found in PATH"
            Write-Info "Visit https://nodejs.org/ to install"
            $checks += $false
        }
    } catch {
        Write-Warning "Could not check Node.js version"
        $checks += $false
    }
    
    # Check Git
    try {
        $gitVersion = git --version 2>$null
        if ($gitVersion) {
            Write-Success "Git available: $gitVersion"
            $checks += $true
        } else {
            Write-Warning "Git not found"
            $checks += $false
        }
    } catch {
        Write-Warning "Git not available"
        $checks += $false
    }
    
    # Check Docker (optional)
    try {
        $dockerVersion = docker --version 2>$null
        if ($dockerVersion) {
            Write-Success "Docker available: $dockerVersion"
        } else {
            Write-Info "Docker not found (optional for basic setup)"
        }
    } catch {
        Write-Info "Docker not available (optional for basic setup)"
    }
    
    $passedChecks = ($checks | Where-Object { $_ -eq $true }).Count
    $totalChecks = $checks.Count
    
    Write-Host "`nPrerequisites: $passedChecks/$totalChecks passed" -ForegroundColor $(if ($passedChecks -eq $totalChecks) { 'Green' } else { 'Yellow' })
    
    return $passedChecks -ge 2  # Need at least PowerShell and one other tool
}

function Setup-MCPConfiguration {
    Write-StepHeader "MCP Configuration Setup" 2 5
    
    $mcpExamplePath = ".cursor/mcp.json.example"
    $mcpPath = ".cursor/mcp.json"
    
    if (Test-Path $mcpExamplePath) {
        Write-Info "Found MCP configuration example"
        
        if (-not (Test-Path $mcpPath)) {
            Write-Prompt "Would you like to copy the MCP configuration template? (Y/n)"
            $response = Read-Host
            if ($response -eq '' -or $response -eq 'Y' -or $response -eq 'y') {
                try {
                    Copy-Item $mcpExamplePath $mcpPath
                    Write-Success "Copied MCP configuration template"
                    Write-Warning "Remember to update API keys in $mcpPath"
                } catch {
                    Write-Error "Failed to copy MCP configuration: $($_.Exception.Message)"
                    return $false
                }
            } else {
                Write-Info "Skipped MCP configuration setup"
            }
        } else {
            Write-Success "MCP configuration already exists"
        }
    } else {
        Write-Warning "MCP configuration example not found"
        Write-Info "You can manually create .cursor/mcp.json later"
    }
    
    return $true
}

function Test-ClaudeCodeSetup {
    Write-StepHeader "Claude Code Installation" 3 5
    
    try {
        $claudeVersion = claude-code --version 2>$null
        if ($claudeVersion) {
            Write-Success "Claude Code already installed: $claudeVersion"
            return $true
        }
    } catch {
        # Claude Code not found, offer to install
    }
    
    Write-Info "Claude Code not found"
    Write-Prompt "Would you like to install Claude Code globally? (Y/n)"
    $response = Read-Host
    
    if ($response -eq '' -or $response -eq 'Y' -or $response -eq 'y') {
        Write-Info "Installing Claude Code..."
        try {
            npm install -g claude-code
            Write-Success "Claude Code installed successfully"
            
            # Test installation
            $testVersion = claude-code --version 2>$null
            if ($testVersion) {
                Write-Success "Installation verified: $testVersion"
                return $true
            } else {
                Write-Warning "Installation may have issues - couldn't verify version"
                return $false
            }
        } catch {
            Write-Error "Failed to install Claude Code: $($_.Exception.Message)"
            Write-Info "You can install manually with: npm install -g claude-code"
            return $false
        }
    } else {
        Write-Info "Skipped Claude Code installation"
        return $true
    }
}

function Setup-ProjectStructure {
    Write-StepHeader "Project Structure Validation" 4 5
    
    $requiredDirs = @('core-tools', 'docs-hub', 'projects', 'experiments', 'archives', 'tests')
    $allGood = $true
    
    foreach ($dir in $requiredDirs) {
        if (Test-Path $dir) {
            Write-Success "Directory exists: $dir"
        } else {
            Write-Warning "Directory missing: $dir"
            try {
                New-Item -ItemType Directory -Path $dir -Force | Out-Null
                Write-Success "Created directory: $dir"
            } catch {
                Write-Error "Failed to create directory: $dir"
                $allGood = $false
            }
        }
    }
    
    # Check for important files
    $importantFiles = @('README.md', '.gitignore', '.gitattributes')
    foreach ($file in $importantFiles) {
        if (Test-Path $file) {
            Write-Success "File exists: $file"
        } else {
            Write-Warning "File missing: $file"
        }
    }
    
    return $allGood
}

function Run-ValidationTests {
    Write-StepHeader "Final Validation" 5 5
    
    $validationScript = "core-tools/scripts/validate-setup.ps1"
    if (Test-Path $validationScript) {
        Write-Info "Running validation tests..."
        try {
            & $validationScript -Quick
            Write-Success "Validation tests completed"
        } catch {
            Write-Warning "Validation script had issues: $($_.Exception.Message)"
        }
    } else {
        Write-Info "Validation script not found - running basic checks"
        
        # Basic checks
        $checks = 0
        $total = 0
        
        # Check project structure
        $total++
        if (Test-Path "core-tools" -and Test-Path "projects") {
            Write-Success "Project structure OK"
            $checks++
        } else {
            Write-Error "Project structure incomplete"
        }
        
        # Check configuration
        $total++
        if (Test-Path ".cursor/mcp.json" -or Test-Path ".cursor/mcp.json.example") {
            Write-Success "MCP configuration available"
            $checks++
        } else {
            Write-Warning "MCP configuration missing"
        }
        
        Write-Host "`nValidation: $checks/$total checks passed" -ForegroundColor $(if ($checks -eq $total) { 'Green' } else { 'Yellow' })
    }
}

function Show-NextSteps {
    Write-Host "`n" + "🎉" * 20 -ForegroundColor Green
    Write-Host "   SETUP COMPLETE!" -ForegroundColor Green
    Write-Host "🎉" * 20 -ForegroundColor Green
    
    Write-Host "`n📍 Next Steps:" -ForegroundColor Cyan
    Write-Host "   1. Update API keys in .cursor/mcp.json (if using MCP)" -ForegroundColor Gray
    Write-Host "   2. Create your first project:" -ForegroundColor Gray
    Write-Host "      .\core-tools\scripts\new-project.ps1 'my-first-project'" -ForegroundColor Yellow
    Write-Host "   3. Read the README.md for detailed documentation" -ForegroundColor Gray
    Write-Host "   4. Explore examples in /experiments/" -ForegroundColor Gray
    
    Write-Host "`n💡 Pro Tips:" -ForegroundColor Magenta
    Write-Host "   • Use Cursor IDE for the best development experience" -ForegroundColor Gray
    Write-Host "   • Configure MCP servers for AI-powered assistance" -ForegroundColor Gray
    Write-Host "   • Check out the .cursor/rules/ for automation guidelines" -ForegroundColor Gray
    
    Write-Host "`n🆘 Need Help?" -ForegroundColor Yellow
    Write-Host "   • Tell any AI agent: 'I'm using the Lab Framework'" -ForegroundColor Gray
    Write-Host "   • Check AGENT_ONBOARDING_PROTOCOL.md for agent guidance" -ForegroundColor Gray
    Write-Host "   • Run: .\core-tools\scripts\validate-setup.ps1 for diagnostics" -ForegroundColor Gray
}

# Main execution
Write-Host "🧪 Lab Framework Setup Wizard" -ForegroundColor Magenta
Write-Host "Getting your development environment ready...`n" -ForegroundColor Gray

$success = $true

if (-not $SkipPrerequisites) {
    $success = $success -and (Test-Prerequisites)
}

if ($success) {
    $success = $success -and (Setup-MCPConfiguration)
}

if ($success) {
    $success = $success -and (Test-ClaudeCodeSetup)
}

if ($success) {
    $success = $success -and (Setup-ProjectStructure)
}

if ($success) {
    Run-ValidationTests
}

if ($success) {
    Show-NextSteps
} else {
    Write-Host "`n⚠️  Setup completed with some issues" -ForegroundColor Yellow
    Write-Host "You can continue manually or re-run this script" -ForegroundColor Gray
    Write-Host "For help, check AGENT_ONBOARDING_PROTOCOL.md" -ForegroundColor Gray
}

Write-Host "`n🚀 Happy coding!" -ForegroundColor Green 