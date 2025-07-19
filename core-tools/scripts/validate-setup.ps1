#Requires -Version 5.1

<#
.SYNOPSIS
    Lab Framework Setup Validation Script
.DESCRIPTION
    Validates that the Lab Framework is properly configured and ready to use.
.EXAMPLE
    .\core-tools\scripts\validate-setup.ps1
.EXAMPLE
    .\core-tools\scripts\validate-setup.ps1 -Quick
#>

param(
    [switch]$Verbose,
    [switch]$Quick
)

function Write-TestResult {
    param(
        [string]$TestName,
        [bool]$Passed,
        [string]$Details = ""
    )
    
    $status = if ($Passed) { "✅ PASS" } else { "❌ FAIL" }
    $color = if ($Passed) { "Green" } else { "Red" }
    
    Write-Host "$status - $TestName" -ForegroundColor $color
    if ($Details) {
        Write-Host "    $Details" -ForegroundColor "Gray"
    }
}

function Test-Prerequisites {
    Write-Host "`n📋 Testing Prerequisites..." -ForegroundColor "Cyan"
    
    $results = @{}
    
    # Test PowerShell version
    $psVersion = $PSVersionTable.PSVersion.Major
    $results.PowerShell = $psVersion -ge 5
    Write-TestResult "PowerShell $psVersion" $results.PowerShell "Minimum version 5.1 required"
    
    # Test Node.js
    try {
        $nodeVersion = node --version 2>$null
        $results.NodeJS = $nodeVersion -match "v\d+\.\d+\.\d+"
        Write-TestResult "Node.js $nodeVersion" $results.NodeJS "Required for MCP servers"
    } catch {
        $results.NodeJS = $false
        Write-TestResult "Node.js" $false "Not found - install from nodejs.org"
    }
    
    # Test Docker
    try {
        $dockerVersion = docker --version 2>$null
        $results.Docker = $dockerVersion -match "Docker version"
        Write-TestResult "Docker" $results.Docker $dockerVersion
    } catch {
        $results.Docker = $false
        Write-TestResult "Docker" $false "Not found or not running"
    }
    
    # Test Git
    try {
        $gitVersion = git --version 2>$null
        $results.Git = $gitVersion -match "git version"
        Write-TestResult "Git" $results.Git $gitVersion
    } catch {
        $results.Git = $false
        Write-TestResult "Git" $false "Not found"
    }
    
    return $results
}

function Test-ProjectStructure {
    Write-Host "`n📂 Testing Project Structure..." -ForegroundColor "Cyan"
    
    $results = @{}
    $requiredDirs = @(
        "core-tools",
        "docs-hub", 
        "projects",
        "experiments",
        "archives",
        ".cursor"
    )
    
    foreach ($dir in $requiredDirs) {
        $exists = Test-Path $dir
        $results.$dir = $exists
        Write-TestResult "Directory: $dir" $exists
    }
    
    # Test key files
    $requiredFiles = @(
        "README.md",
        ".gitignore",
        ".cursor/mcp.json.example"
    )
    
    foreach ($file in $requiredFiles) {
        $exists = Test-Path $file
        $results.$file = $exists
        Write-TestResult "File: $file" $exists
    }
    
    return $results
}

function Test-MCPConfiguration {
    Write-Host "`n⚙️ Testing MCP Configuration..." -ForegroundColor "Cyan"
    
    $results = @{}
    
    # Check if mcp.json exists
    $mcpExists = Test-Path ".cursor/mcp.json"
    $results.MCPConfig = $mcpExists
    Write-TestResult "MCP Config File" $mcpExists "Should exist at .cursor/mcp.json"
    
    if ($mcpExists) {
        try {
            $mcpContent = Get-Content ".cursor/mcp.json" -Raw | ConvertFrom-Json
            $serverCount = ($mcpContent.mcpServers | Get-Member -MemberType NoteProperty).Count
            Write-TestResult "MCP Servers Configured" ($serverCount -gt 0) "$serverCount servers found"
        } catch {
            Write-TestResult "MCP Config Valid" $false "JSON parsing failed"
        }
    }
    
    return $results
}

function Test-Scripts {
    Write-Host "`n📜 Testing Lab Scripts..." -ForegroundColor "Cyan"
    
    $results = @{}
    $scripts = @(
        "core-tools/scripts/new-project.ps1",
        "core-tools/scripts/lab-graduate.ps1", 
        "core-tools/scripts/setup-git-hooks.ps1"
    )
    
    foreach ($script in $scripts) {
        $exists = Test-Path $script
        $results.$script = $exists
        Write-TestResult "Script: $(Split-Path $script -Leaf)" $exists
    }
    
    return $results
}

function Test-Performance {
    if ($Quick) { return @{} }
    
    Write-Host "`n⚡ Performance Tests..." -ForegroundColor "Cyan"
    
    $results = @{}
    
    # Test file search speed
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $files = Get-ChildItem -Recurse -File -Name "*.md" 2>$null
    $stopwatch.Stop()
    
    $fileSearchSpeed = $stopwatch.ElapsedMilliseconds -lt 5000
    $results.FileSearch = $fileSearchSpeed
    Write-TestResult "File Search Speed" $fileSearchSpeed "$($stopwatch.ElapsedMilliseconds)ms for .md files"
    
    return $results
}

# Main execution
Write-Host "🧪 Lab Framework Validation" -ForegroundColor "Cyan"
Write-Host "===========================" -ForegroundColor "Cyan"

$allResults = @{}

# Run tests
$allResults.Prerequisites = Test-Prerequisites
$allResults.ProjectStructure = Test-ProjectStructure  
$allResults.MCPConfiguration = Test-MCPConfiguration
$allResults.Scripts = Test-Scripts
$allResults.Performance = Test-Performance

# Calculate overall score
$totalTests = 0
$passedTests = 0

foreach ($category in $allResults.Keys) {
    foreach ($test in $allResults.$category.Keys) {
        $totalTests++
        if ($allResults.$category.$test) { $passedTests++ }
    }
}

$score = if ($totalTests -gt 0) { [math]::Round(($passedTests / $totalTests) * 100) } else { 0 }

# Summary
Write-Host "`n📊 Validation Summary" -ForegroundColor "Cyan"
Write-Host "===================" -ForegroundColor "Cyan"
Write-Host "Score: $score% ($passedTests/$totalTests tests passed)" -ForegroundColor $(if ($score -ge 80) { "Green" } elseif ($score -ge 60) { "Yellow" } else { "Red" })

if ($score -ge 90) {
    Write-Host "`n🎉 Excellent! Lab Framework is ready to use!" -ForegroundColor "Green"
} elseif ($score -ge 70) {
    Write-Host "`n⚠️ Good setup, but some improvements needed." -ForegroundColor "Yellow"
    Write-Host "Run setup wizard to fix remaining issues: .\core-tools\scripts\setup-wizard.ps1" -ForegroundColor "White"
} else {
    Write-Host "`n❌ Setup needs attention. Run the setup wizard:" -ForegroundColor "Red"
    Write-Host ".\core-tools\scripts\setup-wizard.ps1" -ForegroundColor "White"
}

exit $(if ($score -ge 70) { 0 } else { 1 }) 