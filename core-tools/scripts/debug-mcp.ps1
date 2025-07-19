#Requires -Version 5.1

<#
.SYNOPSIS
    Debug MCP Server Connection Issues
.DESCRIPTION
    Comprehensive debugging for MCP server problems with solutions
.EXAMPLE
    .\core-tools\scripts\debug-mcp.ps1
.EXAMPLE
    .\core-tools\scripts\debug-mcp.ps1 -Server "context7-mcp"
#>

param(
    [string]$Server = "",
    [switch]$Verbose,
    [switch]$FixIssues
)

function Write-DebugHeader {
    param([string]$Title)
    Write-Host "`n" + "🔍 " + "="*50 -ForegroundColor Yellow
    Write-Host "  DEBUG: $Title" -ForegroundColor Yellow  
    Write-Host "="*53 -ForegroundColor Yellow
}

function Write-Issue {
    param(
        [string]$Problem,
        [string]$Solution,
        [string]$Command = ""
    )
    
    Write-Host "❌ ISSUE: $Problem" -ForegroundColor Red
    Write-Host "💡 SOLUTION: $Solution" -ForegroundColor Green
    if ($Command) {
        Write-Host "🔧 COMMAND: $Command" -ForegroundColor Cyan
    }
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️ $Message" -ForegroundColor Blue
}

function Debug-Environment {
    Write-DebugHeader "Environment Diagnosis"
    
    # PowerShell version
    $psVersion = $PSVersionTable.PSVersion
    if ($psVersion.Major -lt 5) {
        Write-Issue "PowerShell version too old" "Upgrade to PowerShell 5.1 or later" "Update PowerShell from Microsoft"
    } else {
        Write-Success "PowerShell $psVersion"
    }
    
    # Node.js
    try {
        $nodeVersion = node --version 2>$null
        if ($nodeVersion) {
            $versionNum = [Version]($nodeVersion -replace 'v','')
            if ($versionNum.Major -lt 18) {
                Write-Issue "Node.js version too old" "Upgrade to Node.js 18 or later" "Download from nodejs.org"
            } else {
                Write-Success "Node.js $nodeVersion"
            }
        } else {
            Write-Issue "Node.js not found" "Install Node.js" "Download from https://nodejs.org/"
        }
    } catch {
        Write-Issue "Node.js not accessible" "Add Node.js to PATH" "Check installation and restart terminal"
    }
    
    # NPM/NPX
    try {
        $npmVersion = npm --version 2>$null
        Write-Success "NPM $npmVersion"
        
        $npxVersion = npx --version 2>$null
        Write-Success "NPX $npxVersion"
    } catch {
        Write-Issue "NPM/NPX not found" "Reinstall Node.js with NPM" "Download complete Node.js package"
    }
    
    # Docker
    try {
        $dockerVersion = docker --version 2>$null
        if ($dockerVersion) {
            Write-Success $dockerVersion
            
            # Check if Docker is running
            try {
                docker info 2>$null | Out-Null
                Write-Success "Docker daemon is running"
            } catch {
                Write-Issue "Docker daemon not running" "Start Docker Desktop" "Open Docker Desktop application"
            }
        } else {
            Write-Issue "Docker not found" "Install Docker Desktop" "Download from docker.com"
        }
    } catch {
        Write-Issue "Docker not accessible" "Check Docker installation" "Restart Docker Desktop"
    }
}

function Debug-MCPConfiguration {
    Write-DebugHeader "MCP Configuration Analysis"
    
    # Check if MCP config exists
    if (-not (Test-Path ".cursor/mcp.json")) {
        Write-Issue "MCP configuration missing" "Copy example configuration" "Copy-Item .cursor/mcp.json.example .cursor/mcp.json"
        return $false
    }
    
    Write-Success "MCP configuration file found"
    
    # Validate JSON
    try {
        $mcpConfig = Get-Content ".cursor/mcp.json" -Raw | ConvertFrom-Json
        Write-Success "MCP configuration is valid JSON"
    } catch {
        Write-Issue "Invalid JSON in MCP configuration" "Fix JSON syntax errors" "Validate JSON at jsonlint.com"
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    
    # Check structure
    if (-not $mcpConfig.mcpServers) {
        Write-Issue "No mcpServers section" "Add mcpServers configuration" "Copy structure from mcp.json.example"
        return $false
    }
    
    $serverCount = ($mcpConfig.mcpServers | Get-Member -MemberType NoteProperty).Count
    Write-Success "$serverCount MCP servers configured"
    
    return $mcpConfig
}

function Debug-APIKeys {
    Write-DebugHeader "API Keys Analysis"
    
    $requiredKeys = @{
        "ANTHROPIC_API_KEY" = "Claude API access"
        "OPENAI_API_KEY" = "OpenAI/GPT functionality" 
        "BROWSERBASE_API_KEY" = "Web automation"
        "GITHUB_PERSONAL_ACCESS_TOKEN" = "GitHub integration"
        "CONTEXT7_API_KEY" = "Documentation lookup"
    }
    
    foreach ($keyName in $requiredKeys.Keys) {
        $keyValue = [Environment]::GetEnvironmentVariable($keyName)
        $purpose = $requiredKeys.$keyName
        
        if ($keyValue) {
            if ($keyValue.Length -lt 10) {
                Write-Issue "$keyName too short" "Check API key format" "Regenerate API key from provider"
            } else {
                $masked = $keyValue.Substring(0, 8) + "***"
                Write-Success "$keyName: $masked ($purpose)"
            }
        } else {
            Write-Issue "$keyName missing" "Set environment variable" "Add to .cursor/mcp.json env section"
        }
    }
}

function Debug-SpecificServer {
    param([string]$ServerName, [object]$ServerConfig)
    
    Write-DebugHeader "Server Debug: $ServerName"
    
    if (-not $ServerConfig.command) {
        Write-Issue "No command specified" "Add command to server config" "Check mcp.json.example for reference"
        return
    }
    
    Write-Info "Command: $($ServerConfig.command)"
    if ($ServerConfig.args) {
        Write-Info "Args: $($ServerConfig.args -join ' ')"
    }
    
    switch ($ServerConfig.command) {
        "npx" {
            Debug-NPXServer $ServerName $ServerConfig
        }
        "docker" {
            Debug-DockerServer $ServerName $ServerConfig
        }
        "cmd" {
            Debug-CommandServer $ServerName $ServerConfig
        }
        default {
            Debug-GenericServer $ServerName $ServerConfig
        }
    }
}

function Debug-NPXServer {
    param([string]$Name, [object]$Config)
    
    if (-not $Config.args -or $Config.args.Length -eq 0) {
        Write-Issue "No package specified" "Add package name to args" "Example: ['-y', '@package/name']"
        return
    }
    
    $packageName = $Config.args[0]
    if ($packageName -eq "-y") {
        $packageName = $Config.args[1]
    }
    
    Write-Info "Testing package: $packageName"
    
    # Test package availability
    try {
        $output = npx --yes $packageName --help 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Package $packageName is available"
        } else {
            Write-Issue "Package execution failed" "Check package name and network" "Try: npx --yes $packageName --version"
        }
    } catch {
        Write-Issue "NPX execution failed" "Check npm configuration" "Try: npm config list"
    }
    
    # Check environment variables
    if ($Config.env) {
        foreach ($envVar in $Config.env.PSObject.Properties) {
            $envValue = [Environment]::GetEnvironmentVariable($envVar.Name)
            if (-not $envValue) {
                Write-Issue "Missing environment variable: $($envVar.Name)" "Set environment variable" "Add to mcp.json env section"
            }
        }
    }
}

function Debug-DockerServer {
    param([string]$Name, [object]$Config)
    
    # Check Docker availability
    try {
        docker --version | Out-Null
    } catch {
        Write-Issue "Docker not available" "Install Docker Desktop" "Download from docker.com"
        return
    }
    
    # Check if docker daemon is running
    try {
        docker info | Out-Null
    } catch {
        Write-Issue "Docker daemon not running" "Start Docker Desktop" "Launch Docker Desktop application"
        return
    }
    
    # Find image name in args
    $imageName = $Config.args | Where-Object { $_ -match "ghcr\.io|docker\.io|:" } | Select-Object -First 1
    if ($imageName) {
        Write-Info "Docker image: $imageName"
        
        # Test image availability
        try {
            docker inspect $imageName 2>$null | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Success "Docker image is available locally"
            } else {
                Write-Issue "Docker image not found locally" "Pull the image" "docker pull $imageName"
            }
        } catch {
            Write-Issue "Error checking Docker image" "Verify image name" "Check for typos in image name"
        }
    }
    
    # Check environment variables
    if ($Config.env) {
        foreach ($envVar in $Config.env.PSObject.Properties) {
            $envValue = [Environment]::GetEnvironmentVariable($envVar.Name)
            if (-not $envValue) {
                Write-Issue "Missing environment variable: $($envVar.Name)" "Set environment variable" "Add to Docker run command or mcp.json"
            }
        }
    }
}

function Debug-CommandServer {
    param([string]$Name, [object]$Config)
    
    # This handles cmd-based servers like Smithery CLI
    if ($Config.args -and $Config.args.Length -gt 2) {
        $actualCommand = $Config.args[2]  # Usually after "/c" and "npx"
        Write-Info "Actual command: $actualCommand"
        
        # Test the command
        try {
            $output = cmd /c "npx --yes $actualCommand --version" 2>&1
            if ($output -match "version|help") {
                Write-Success "Command $actualCommand is working"
            } else {
                Write-Issue "Command not responding correctly" "Check command availability" "Try manually: npx --yes $actualCommand --version"
            }
        } catch {
            Write-Issue "Command execution failed" "Check command spelling and availability" "Verify command exists on npmjs.com"
        }
    }
}

function Debug-GenericServer {
    param([string]$Name, [object]$Config)
    
    try {
        $cmd = $Config.command
        $output = & $cmd --version 2>&1
        if ($output) {
            Write-Success "Command $cmd is available"
        } else {
            Write-Issue "Command not found: $cmd" "Install the required tool" "Check documentation for installation"
        }
    } catch {
        Write-Issue "Error executing command: $($Config.command)" "Check if command is installed" "Verify PATH includes command location"
    }
}

function Suggest-CommonFixes {
    Write-DebugHeader "Common Solutions"
    
    Write-Host "🔧 COMMON FIXES:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Restart Cursor after MCP configuration changes" -ForegroundColor White
    Write-Host "2. Copy .cursor/mcp.json.example to .cursor/mcp.json" -ForegroundColor White
    Write-Host "3. Add API keys to mcp.json env sections" -ForegroundColor White
    Write-Host "4. Start Docker Desktop if using Docker-based servers" -ForegroundColor White
    Write-Host "5. Update Node.js to version 18 or later" -ForegroundColor White
    Write-Host "6. Check Windows execution policy: Set-ExecutionPolicy RemoteSigned" -ForegroundColor White
    Write-Host ""
    
    Write-Host "🚀 VERIFICATION COMMANDS:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "# Test MCP servers:" -ForegroundColor Gray
    Write-Host ".\core-tools\scripts\test-mcp-servers.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "# Validate overall setup:" -ForegroundColor Gray
    Write-Host ".\core-tools\scripts\validate-setup.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "# Setup wizard (if needed):" -ForegroundColor Gray
    Write-Host ".\core-tools\scripts\setup-wizard.ps1" -ForegroundColor White
}

# Main execution
Write-Host "🔍 Lab Framework - MCP Debug Tool" -ForegroundColor Yellow
Write-Host "Diagnosing MCP server issues...`n" -ForegroundColor Gray

# Environment check
Debug-Environment

# Configuration check
$mcpConfig = Debug-MCPConfiguration

if ($mcpConfig) {
    # API keys check
    Debug-APIKeys
    
    # Server-specific debugging
    if ($Server) {
        if ($mcpConfig.mcpServers.PSObject.Properties.Name -contains $Server) {
            Debug-SpecificServer $Server $mcpConfig.mcpServers.${Server}
        } else {
            Write-Issue "Server '$Server' not found" "Check server name" "Available: $($mcpConfig.mcpServers | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name)"
        }
    } else {
        # Debug all servers
        $servers = $mcpConfig.mcpServers | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
        foreach ($serverName in $servers) {
            Debug-SpecificServer $serverName $mcpConfig.mcpServers.${serverName}
        }
    }
}

# Show common solutions
Suggest-CommonFixes

Write-Host "🎯 Debug complete! Review issues above and apply suggested solutions." -ForegroundColor Green 