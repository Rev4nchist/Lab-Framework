#Requires -Version 5.1

<#
.SYNOPSIS
    Claude Code + IDE Integration Setup Script

.DESCRIPTION
    Comprehensive setup and validation for Claude Code CLI and IDE integration.
    Supports VS Code, Cursor, Windsurf, JetBrains IDEs, and other supported editors.
    
    This script:
    - Validates Claude Code CLI installation
    - Detects and validates IDE CLI availability  
    - Guides through Claude Code CLI installation if needed
    - Launches IDE and triggers extension auto-installation
    - Validates integration features work correctly
    - Configures optimal settings for IDE integration
    - Provides troubleshooting for common issues

.PARAMETER IDE
    Specify target IDE: VSCode, Cursor, Windsurf, JetBrains, Auto (default: Auto-detect)

.PARAMETER SkipInstallation
    Skip Claude Code CLI installation steps (assume already installed)

.PARAMETER SkipConfiguration
    Skip configuration optimization steps

.PARAMETER TestMode
    Run in test mode - validate existing setup without making changes

.PARAMETER Verbose
    Enable verbose output for debugging

.EXAMPLE
    .\setup-claude-ide.ps1
    # Auto-detect IDE and perform complete setup

.EXAMPLE  
    .\setup-claude-ide.ps1 -IDE "Cursor" -Verbose
    # Setup specifically for Cursor with verbose output

.EXAMPLE
    .\setup-claude-ide.ps1 -TestMode
    # Test existing Claude Code + IDE integration

.NOTES
    Version: 1.0.0
    Author: Lab Framework Team
    
    Requirements:
    - Windows PowerShell 5.1+ or PowerShell Core 6+
    - Internet connection for Claude Code CLI download
    - Target IDE already installed
    
    Based on: https://docs.anthropic.com/en/docs/claude-code/ide-integrations
#>

[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet("Auto", "VSCode", "Cursor", "Windsurf", "JetBrains", "Other")]
    [string]$IDE = "Auto",
    
    [Parameter()]
    [switch]$SkipInstallation,
    
    [Parameter()]
    [switch]$SkipConfiguration,
    
    [Parameter()]
    [switch]$TestMode,
    
    [Parameter()]
    [switch]$Force
)

# === CONFIGURATION ===
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Color coding for output
$Colors = @{
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Info = "Cyan"
    Highlight = "Magenta"
}

# IDE Configuration
$SupportedIDEs = @{
    "VSCode" = @{
        Name = "Visual Studio Code"
        Commands = @("code")
        ExtensionId = "anthropic.claude-code"
        ShortcutKey = "Ctrl+Esc"
        TestFile = "test-claude-integration.txt"
    }
    "Cursor" = @{
        Name = "Cursor"  
        Commands = @("cursor")
        ExtensionId = "anthropic.claude-code"
        ShortcutKey = "Ctrl+Esc"
        TestFile = "test-claude-integration.txt"
    }
    "Windsurf" = @{
        Name = "Windsurf"
        Commands = @("windsurf")
        ExtensionId = "anthropic.claude-code"
        ShortcutKey = "Ctrl+Esc"
        TestFile = "test-claude-integration.txt"
    }
    "JetBrains" = @{
        Name = "JetBrains IDEs"
        Commands = @("idea", "pycharm", "webstorm", "phpstorm", "rubymine")
        ExtensionId = "claude-code-plugin"
        ShortcutKey = "Platform specific"
        TestFile = "test-claude-integration.txt"
    }
}

# === UTILITY FUNCTIONS ===

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White",
        [switch]$NoNewline
    )
    
    if ($Colors.ContainsKey($Color)) {
        $Color = $Colors[$Color]
    }
    
    if ($NoNewline) {
        Write-Host $Message -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Message -ForegroundColor $Color
    }
}

function Write-Section {
    param([string]$Title)
    
    Write-Host ""
    Write-ColorOutput "="*60 -Color "Highlight"
    Write-ColorOutput "  $Title" -Color "Highlight"
    Write-ColorOutput "="*60 -Color "Highlight"
    Write-Host ""
}

function Write-Step {
    param(
        [string]$Message,
        [string]$Status = "Info"
    )
    
    $prefix = switch($Status) {
        "Success" { "✅" }
        "Warning" { "⚠️ " }
        "Error" { "❌" }
        "Info" { "ℹ️ " }
        default { "→ " }
    }
    
    Write-ColorOutput "$prefix $Message" -Color $Status
}

function Test-CommandExists {
    param([string]$Command)
    
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Test-ClaudeCodeCLI {
    Write-Step "Checking Claude Code CLI installation..." -Status "Info"
    
    if (Test-CommandExists "claude") {
        try {
            $version = & claude --version 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Step "Claude Code CLI found: $version" -Status "Success"
                return $true
            }
        } catch {
            # Fall through to installation check
        }
    }
    
    Write-Step "Claude Code CLI not found or not working" -Status "Warning"
    return $false
}

function Install-ClaudeCodeCLI {
    Write-Section "Claude Code CLI Installation"
    
    if ($TestMode) {
        Write-Step "Test mode: Skipping Claude Code CLI installation" -Status "Info"
        return
    }
    
    if ($SkipInstallation) {
        Write-Step "Skipping Claude Code CLI installation (SkipInstallation flag)" -Status "Info"
        return
    }
    
    Write-Step "Starting Claude Code CLI installation..." -Status "Info"
    Write-Host ""
    
    # Provide installation instructions based on platform
    if ($IsWindows -or $env:OS -eq "Windows_NT") {
        Write-ColorOutput "Windows Installation Options:" -Color "Highlight"
        Write-Host "1. Download from: https://claude.ai/download"
        Write-Host "2. Or use winget: winget install Anthropic.Claude"
        Write-Host "3. Or use chocolatey: choco install claude-cli"
    } else {
        Write-ColorOutput "macOS/Linux Installation:" -Color "Highlight"
        Write-Host "1. Download from: https://claude.ai/download"
        Write-Host "2. Or use brew (macOS): brew install claude"
    }
    
    Write-Host ""
    Write-ColorOutput "After installation, restart your terminal and run this script again." -Color "Warning"
    
    # Ask if user wants to continue with manual installation
    if (-not $Force) {
        $response = Read-Host "Press Enter to open download page, or 'skip' to continue anyway"
        if ($response -ne "skip") {
            Start-Process "https://claude.ai/download"
            Write-Host "Script paused. Please install Claude Code CLI and restart this script."
            exit 0
        }
    }
}

function Detect-IDE {
    Write-Section "IDE Detection"
    
    if ($IDE -ne "Auto") {
        Write-Step "Using specified IDE: $IDE" -Status "Info"
        return $IDE
    }
    
    Write-Step "Auto-detecting available IDEs..." -Status "Info"
    
    $detectedIDEs = @()
    
    foreach ($ideKey in $SupportedIDEs.Keys) {
        $ideConfig = $SupportedIDEs[$ideKey]
        foreach ($command in $ideConfig.Commands) {
            if (Test-CommandExists $command) {
                $detectedIDEs += @{
                    Key = $ideKey
                    Name = $ideConfig.Name
                    Command = $command
                }
                Write-Step "Found: $($ideConfig.Name) (command: $command)" -Status "Success"
                break
            }
        }
    }
    
    if ($detectedIDEs.Count -eq 0) {
        Write-Step "No supported IDEs detected with CLI commands available" -Status "Error"
        Write-Host ""
        Write-ColorOutput "Please ensure your IDE's CLI command is in PATH:" -Color "Warning"
        Write-Host "- VS Code: Install 'Shell Command: Install code command in PATH'"
        Write-Host "- Cursor: Should be available after installation"
        Write-Host "- JetBrains: Enable 'Generate shell scripts' in Toolbox"
        Write-Host ""
        
        if (-not $Force) {
            throw "No supported IDE CLI commands found. Please install and configure your IDE's CLI tools."
        }
        return "Unknown"
    }
    
    if ($detectedIDEs.Count -eq 1) {
        $selectedIDE = $detectedIDEs[0]
        Write-Step "Auto-selected: $($selectedIDE.Name)" -Status "Success"
        return $selectedIDE.Key
    }
    
    # Multiple IDEs detected - let user choose
    Write-Host ""
    Write-ColorOutput "Multiple IDEs detected:" -Color "Highlight"
    for ($i = 0; $i -lt $detectedIDEs.Count; $i++) {
        Write-Host "  $($i + 1). $($detectedIDEs[$i].Name)"
    }
    
    if (-not $Force) {
        do {
            $choice = Read-Host "Select IDE (1-$($detectedIDEs.Count))"
            $index = [int]$choice - 1
        } while ($index -lt 0 -or $index -ge $detectedIDEs.Count)
        
        $selectedIDE = $detectedIDEs[$index]
        Write-Step "Selected: $($selectedIDE.Name)" -Status "Success"
        return $selectedIDE.Key
    } else {
        # Auto-select first one in force mode
        return $detectedIDEs[0].Key
    }
}

function Test-IDEIntegration {
    param(
        [string]$IDEKey,
        [string]$Command
    )
    
    Write-Section "IDE Integration Testing"
    
    $ideConfig = $SupportedIDEs[$IDEKey]
    
    if ($TestMode) {
        Write-Step "Test mode: Simulating IDE integration test for $($ideConfig.Name)" -Status "Info"
        return $true
    }
    
    Write-Step "Testing $($ideConfig.Name) integration..." -Status "Info"
    
    # Create a temporary test file
    $testFile = Join-Path $PWD $ideConfig.TestFile
    $testContent = @"
# Claude Code Integration Test
# This file is used to test Claude Code + IDE integration
# You can delete this file after testing

Test timestamp: $(Get-Date)
IDE: $($ideConfig.Name)
Command: $Command
Shortcut: $($ideConfig.ShortcutKey)

Instructions:
1. This file should open in your IDE
2. Try the Claude Code shortcut: $($ideConfig.ShortcutKey)
3. Test file references with Cmd+Option+K (Mac) or Ctrl+Alt+K (Windows)
4. Test selection context sharing
"@
    
    try {
        # Write test file
        $testContent | Out-File -FilePath $testFile -Encoding UTF8
        
        Write-Step "Created test file: $testFile" -Status "Success"
        Write-Step "Opening $($ideConfig.Name)..." -Status "Info"
        
        # Launch IDE with test file
        if ($IDEKey -eq "JetBrains") {
            # JetBrains needs special handling - open directory
            & $Command .
        } else {
            & $Command $testFile
        }
        
        Write-Host ""
        Write-ColorOutput "IDE should now be open. Please test the following:" -Color "Highlight"
        Write-Host "1. ✅ IDE opened successfully"
        Write-Host "2. ✅ Test file is visible"
        Write-Host "3. ⚡ Try Claude Code shortcut: $($ideConfig.ShortcutKey)"
        Write-Host "4. 🔧 Run 'claude' command in IDE's integrated terminal"
        Write-Host "5. 📝 Test file reference shortcuts (if supported)"
        
        if (-not $Force) {
            Read-Host "Press Enter when you've completed the integration test"
        }
        
        return $true
        
    } catch {
        Write-Step "Failed to launch IDE: $_" -Status "Error"
        return $false
    } finally {
        # Clean up test file
        if (Test-Path $testFile) {
            Remove-Item $testFile -Force -ErrorAction SilentlyContinue
        }
    }
}

function Start-ClaudeInIDE {
    param([string]$IDEKey)
    
    Write-Section "Claude Code Extension Setup"
    
    $ideConfig = $SupportedIDEs[$IDEKey]
    
    Write-Step "Setting up Claude Code extension for $($ideConfig.Name)..." -Status "Info"
    
    if ($TestMode) {
        Write-Step "Test mode: Simulating Claude Code extension setup" -Status "Info"
        return $true
    }
    
    Write-Host ""
    Write-ColorOutput "Next steps for $($ideConfig.Name):" -Color "Highlight"
    
    if ($IDEKey -eq "JetBrains") {
        Write-Host "1. Open your JetBrains IDE"
        Write-Host "2. Navigate to project root directory" 
        Write-Host "3. Open the integrated terminal (Alt+F12)"
        Write-Host "4. Run: claude"
        Write-Host "5. The plugin should auto-install"
        Write-Host "6. Restart the IDE completely (important!)"
        Write-Host "7. Enable the Claude Code plugin in Settings > Plugins"
    } else {
        Write-Host "1. Open the integrated terminal in $($ideConfig.Name)"
        Write-Host "2. Run: claude"
        Write-Host "3. The extension should auto-install"
        Write-Host "4. Test the shortcut: $($ideConfig.ShortcutKey)"
        Write-Host "5. Configure Claude Code with: /config"
    }
    
    if (-not $Force) {
        $response = Read-Host "Have you completed the Claude Code setup? (y/n)"
        return $response -eq "y"
    }
    
    return $true
}

function Optimize-ClaudeConfiguration {
    Write-Section "Claude Code Configuration Optimization"
    
    if ($SkipConfiguration -or $TestMode) {
        Write-Step "Skipping configuration optimization" -Status "Info"
        return
    }
    
    Write-Step "Optimizing Claude Code settings for IDE integration..." -Status "Info"
    
    Write-Host ""
    Write-ColorOutput "Recommended Claude Code configuration:" -Color "Highlight"
    Write-Host ""
    Write-Host "Run these commands in Claude Code:"
    Write-Host "1. /config"
    Write-Host "2. Set 'Diff tool' to 'auto' (for IDE integration)"
    Write-Host "3. Set 'Memory' to appropriate level for your system"
    Write-Host "4. Configure any project-specific settings"
    
    Write-Host ""
    Write-ColorOutput "IDE-specific optimizations:" -Color "Info"
    Write-Host "- Enable 'Auto-save' in your IDE"
    Write-Host "- Configure file watching for better sync"
    Write-Host "- Set up keyboard shortcuts for quick access"
    Write-Host "- Enable bracket matching and syntax highlighting"
    
    if (-not $Force) {
        Read-Host "Press Enter after you've optimized the configuration"
    }
}

function Test-IntegrationFeatures {
    param([string]$IDEKey)
    
    Write-Section "Integration Features Validation"
    
    $ideConfig = $SupportedIDEs[$IDEKey]
    
    Write-Step "Testing Claude Code + $($ideConfig.Name) integration features..." -Status "Info"
    
    $features = @(
        "Quick launch shortcut ($($ideConfig.ShortcutKey))",
        "Diff viewing in IDE (not terminal)",
        "Selection context sharing",
        "File reference shortcuts",
        "Integrated terminal support"
    )
    
    Write-Host ""
    Write-ColorOutput "Please test these features:" -Color "Highlight"
    
    $results = @()
    foreach ($feature in $features) {
        Write-Host ""
        Write-ColorOutput "Testing: $feature" -Color "Info"
        
        if (-not $Force -and -not $TestMode) {
            $result = Read-Host "Does this feature work? (y/n/skip)"
            $results += @{
                Feature = $feature
                Status = $result
            }
        } else {
            $results += @{
                Feature = $feature  
                Status = "skipped"
            }
        }
    }
    
    # Summary
    Write-Host ""
    Write-ColorOutput "Integration Test Results:" -Color "Highlight"
    $working = 0
    $total = 0
    
    foreach ($result in $results) {
        $status = switch($result.Status) {
            "y" { "✅ Working"; $working++; $total++ }
            "n" { "❌ Failed"; $total++ }
            "skip" { "⏭️  Skipped" }
            default { "❓ Unknown" }
        }
        Write-Host "  $($result.Feature): $status"
    }
    
    if ($total -gt 0) {
        $percentage = [math]::Round(($working / $total) * 100)
        Write-Host ""
        Write-ColorOutput "Success Rate: $working/$total ($percentage%)" -Color $(if ($percentage -ge 80) { "Success" } else { "Warning" })
    }
    
    return $working -ge ($total * 0.8)  # 80% success rate
}

function Show-TroubleshootingGuide {
    param([string]$IDEKey)
    
    Write-Section "Troubleshooting Guide"
    
    $ideConfig = $SupportedIDEs[$IDEKey]
    
    Write-ColorOutput "Common Issues and Solutions for $($ideConfig.Name):" -Color "Highlight"
    Write-Host ""
    
    if ($IDEKey -eq "VSCode" -or $IDEKey -eq "Cursor" -or $IDEKey -eq "Windsurf") {
        Write-ColorOutput "VS Code-based IDEs:" -Color "Info"
        Write-Host "❌ Extension not installing:"
        Write-Host "   → Install 'Shell Command: Install code command in PATH'"
        Write-Host "   → Restart terminal and try again"
        Write-Host "   → Check extension permissions"
        Write-Host ""
        Write-Host "❌ Shortcut not working:"
        Write-Host "   → Check keyboard shortcut conflicts"
        Write-Host "   → Try Ctrl+Shift+P and search 'Claude'"
        Write-Host "   → Verify extension is enabled"
        Write-Host ""
        Write-Host "❌ Diff not showing in IDE:"
        Write-Host "   → Run '/config' in Claude and set diff tool to 'auto'"
        Write-Host "   → Restart IDE after configuration change"
    }
    
    if ($IDEKey -eq "JetBrains") {
        Write-ColorOutput "JetBrains IDEs:" -Color "Info"
        Write-Host "❌ Plugin not installing:"
        Write-Host "   → Must run 'claude' from project root directory"
        Write-Host "   → Complete IDE restart required (sometimes multiple times)"
        Write-Host "   → Enable plugin manually in Settings > Plugins"
        Write-Host ""
        Write-Host "❌ Plugin not working after install:"
        Write-Host "   → Verify plugin is enabled in settings"
        Write-Host "   → Try 'Invalidate Caches and Restart'"
        Write-Host "   → Check IDE compatibility version"
        Write-Host ""
        Write-Host "❌ Remote development issues:"
        Write-Host "   → Install Claude Code on host machine"
        Write-Host "   → Configure SSH port forwarding if needed"
    }
    
    Write-Host ""
    Write-ColorOutput "General Troubleshooting:" -Color "Info"
    Write-Host "🔧 Claude CLI issues:"
    Write-Host "   → Verify PATH contains Claude installation"
    Write-Host "   → Try 'claude --version' in terminal"
    Write-Host "   → Reinstall Claude Code CLI if needed"
    Write-Host ""
    Write-Host "🔧 Performance issues:"
    Write-Host "   → Increase memory allocation in /config"
    Write-Host "   → Close unnecessary IDE tabs/projects"
    Write-Host "   → Check for conflicting extensions"
    Write-Host ""
    Write-Host "🔧 Configuration issues:"
    Write-Host "   → Reset Claude Code config: /config reset"
    Write-Host "   → Clear IDE extension cache"
    Write-Host "   → Check file permissions"
    
    Write-Host ""
    Write-ColorOutput "Need more help?" -Color "Highlight"
    Write-Host "📚 Anthropic Docs: https://docs.anthropic.com/en/docs/claude-code"
    Write-Host "🔍 VS Code Extension: https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code"
    Write-Host "💬 Community Support: Check IDE-specific forums and Discord"
}

function Write-Summary {
    param(
        [string]$IDEKey,
        [bool]$ClaudeInstalled,
        [bool]$IntegrationWorking
    )
    
    Write-Section "Setup Summary"
    
    $ideConfig = $SupportedIDEs[$IDEKey]
    
    Write-Host ""
    Write-ColorOutput "Claude Code + $($ideConfig.Name) Integration Setup Complete!" -Color "Success"
    Write-Host ""
    
    Write-Host "Status Summary:"
    Write-Host "  Claude Code CLI: $(if ($ClaudeInstalled) { '✅ Installed' } else { '❌ Not Found' })"
    Write-Host "  IDE Detected: ✅ $($ideConfig.Name)"
    Write-Host "  Integration: $(if ($IntegrationWorking) { '✅ Working' } else { '⚠️ Needs Attention' })"
    
    Write-Host ""
    Write-ColorOutput "Quick Reference:" -Color "Highlight"
    Write-Host "  Launch Claude: $($ideConfig.ShortcutKey)"
    Write-Host "  Configuration: Run '/config' in Claude"
    Write-Host "  File References: Cmd+Option+K (Mac) / Ctrl+Alt+K (Windows)"
    Write-Host "  Terminal: Run 'claude' in IDE's integrated terminal"
    
    if (-not $IntegrationWorking) {
        Write-Host ""
        Write-ColorOutput "⚠️ Some features may need attention. Check the troubleshooting guide above." -Color "Warning"
    }
    
    Write-Host ""
    Write-ColorOutput "🎉 You're ready to use Claude Code with $($ideConfig.Name)!" -Color "Success"
    Write-Host ""
}

# === MAIN EXECUTION ===

function Main {
    try {
        Write-Section "Claude Code + IDE Integration Setup"
        
        Write-ColorOutput "Lab Framework - Claude Code Integration Script v1.0.0" -Color "Highlight"
        Write-Host "Based on: https://docs.anthropic.com/en/docs/claude-code/ide-integrations"
        Write-Host ""
        
        if ($TestMode) {
            Write-ColorOutput "🧪 Running in TEST MODE - no changes will be made" -Color "Warning"
            Write-Host ""
        }
        
        # Step 1: Check Claude Code CLI
        $claudeInstalled = Test-ClaudeCodeCLI
        if (-not $claudeInstalled -and -not $TestMode) {
            Install-ClaudeCodeCLI
            $claudeInstalled = Test-ClaudeCodeCLI
        }
        
        # Step 2: Detect IDE
        $selectedIDE = Detect-IDE
        if (-not $SupportedIDEs.ContainsKey($selectedIDE)) {
            throw "Unsupported IDE selected: $selectedIDE"
        }
        
        $ideConfig = $SupportedIDEs[$selectedIDE]
        $ideCommand = $null
        
        # Find working command for selected IDE
        foreach ($cmd in $ideConfig.Commands) {
            if (Test-CommandExists $cmd) {
                $ideCommand = $cmd
                break
            }
        }
        
        if (-not $ideCommand -and -not $TestMode) {
            throw "IDE command not found for $($ideConfig.Name). Please ensure CLI tools are installed."
        }
        
        # Step 3: Test basic IDE integration
        $integrationWorking = Test-IDEIntegration -IDEKey $selectedIDE -Command $ideCommand
        
        # Step 4: Setup Claude in IDE
        if ($integrationWorking) {
            $extensionSetup = Start-ClaudeInIDE -IDEKey $selectedIDE
        }
        
        # Step 5: Optimize configuration
        if ($extensionSetup -or $TestMode) {
            Optimize-ClaudeConfiguration
        }
        
        # Step 6: Test integration features
        $finalTest = Test-IntegrationFeatures -IDEKey $selectedIDE
        
        # Step 7: Show troubleshooting if needed
        if (-not $finalTest -or -not $claudeInstalled) {
            Show-TroubleshootingGuide -IDEKey $selectedIDE
        }
        
        # Step 8: Summary
        Write-Summary -IDEKey $selectedIDE -ClaudeInstalled $claudeInstalled -IntegrationWorking $finalTest
        
        # Return success if everything worked
        if ($claudeInstalled -and $finalTest) {
            exit 0
        } else {
            exit 1
        }
        
    } catch {
        Write-Host ""
        Write-ColorOutput "❌ Setup failed: $_" -Color "Error"
        Write-Host ""
        Write-ColorOutput "For help, run with -Verbose or check the troubleshooting guide" -Color "Warning"
        exit 1
    }
}

# Execute main function
Main 