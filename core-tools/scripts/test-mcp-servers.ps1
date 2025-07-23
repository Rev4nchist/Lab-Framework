#Requires -Version 5.1

<#
.SYNOPSIS
    Test MCP Server Connectivity and Functionality
.DESCRIPTION
    Validates that all configured MCP servers are working correctly
.EXAMPLE
    .\core-tools\scripts\test-mcp-servers.ps1
.EXAMPLE
    .\core-tools\scripts\test-mcp-servers.ps1 -Quick
#>

param(
    [switch]$Quick,
    [switch]$Verbose
)

# Test results tracking
$results = @{
    Passed = @()
    Failed = @()
    Warnings = @()
}

function Write-TestHeader {
    param([string]$Title)
    Write-Host "`n" + "="*50 -ForegroundColor Cyan
    Write-Host "  TESTING: $Title" -ForegroundColor Cyan  
    Write-Host "="*50 -ForegroundColor Cyan
}

function Write-TestResult {
    param(
        [string]$TestName,
        [bool]$Passed,
        [string]$Details = ""
    )
    
    if ($Passed) {
        Write-Host "✅ $TestName" -ForegroundColor Green
        $results.Passed += $TestName
    } else {
        Write-Host "❌ $TestName" -ForegroundColor Red
        $results.Failed += $TestName
    }
    
    if ($Details) {
        Write-Host "   $Details" -ForegroundColor Gray
    }
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️ $Message" -ForegroundColor Yellow
    $results.Warnings += $Message
}

function Test-MCPConfiguration {
    Write-TestHeader "MCP Configuration"
    
    # Check if MCP config exists
    if (-not (Test-Path ".cursor/mcp.json")) {
        Write-TestResult "MCP Configuration File" $false "Missing .cursor/mcp.json"
        Write-Host "   💡 Run: cp .cursor/mcp.json.example .cursor/mcp.json" -ForegroundColor Yellow
        return $false
    }
    
    Write-TestResult "MCP Configuration File" $true "Found .cursor/mcp.json"
    
    # Parse MCP configuration
    try {
        $mcpConfig = Get-Content ".cursor/mcp.json" -Raw | ConvertFrom-Json
        Write-TestResult "MCP Configuration Valid" $true "JSON parsing successful"
        
        if ($mcpConfig.mcpServers) {
            $serverCount = ($mcpConfig.mcpServers | Get-Member -MemberType NoteProperty).Count
            Write-TestResult "MCP Servers Defined" ($serverCount -gt 0) "$serverCount servers configured"
            return $mcpConfig
        } else {
            Write-TestResult "MCP Servers Section" $false "No mcpServers section found"
            return $false
        }
    } catch {
        Write-TestResult "MCP Configuration Valid" $false "JSON parsing failed: $($_.Exception.Message)"
        return $false
    }
}

function Test-NodeDependencies {
    Write-TestHeader "Node.js Dependencies"
    
    # Test Node.js version
    try {
        $nodeVersion = node --version 2>$null
        if ($nodeVersion) {
            Write-TestResult "Node.js Available" $true "Version: $nodeVersion"
        } else {
            Write-TestResult "Node.js Available" $false "Node.js not found in PATH"
            return $false
        }
    } catch {
        Write-TestResult "Node.js Available" $false "Error executing node command"
        return $false
    }
    
    # Test NPX
    try {
        $npxVersion = npx --version 2>$null
        Write-TestResult "NPX Available" ($npxVersion -ne $null) "Version: $npxVersion"
    } catch {
        Write-TestResult "NPX Available" $false "NPX not found"
    }
    
    return $true
}

function Test-DockerEnvironment {
    Write-TestHeader "Docker Environment"
    
    # Test Docker availability
    try {
        $dockerVersion = docker --version 2>$null
        if ($dockerVersion) {
            Write-TestResult "Docker Available" $true $dockerVersion
            
            # Test Docker running
            try {
                $dockerInfo = docker info 2>$null
                Write-TestResult "Docker Running" ($dockerInfo -ne $null) "Docker daemon is accessible"
            } catch {
                Write-TestResult "Docker Running" $false "Docker daemon not running"
                Write-Warning "Start Docker Desktop or Docker service"
            }
        } else {
            Write-TestResult "Docker Available" $false "Docker not found in PATH"
            Write-Warning "Install Docker Desktop from docker.com"
        }
    } catch {
        Write-TestResult "Docker Available" $false "Error checking Docker"
    }
}

function Test-MCPServerAvailability {
    param([object]$MCPConfig)
    
    Write-TestHeader "MCP Server Availability"
    
    if (-not $MCPConfig -or -not $MCPConfig.mcpServers) {
        Write-Warning "No MCP configuration to test"
        return
    }
    
    $servers = $MCPConfig.mcpServers | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
    
    foreach ($serverName in $servers) {
        $server = $MCPConfig.mcpServers.$serverName
        
        Write-Host "`n🔍 Testing $serverName..." -ForegroundColor White
        
        if ($server.command) {
            switch ($server.command) {
                "npx" {
                    Test-NPXServer $serverName $server
                }
                "docker" {
                    Test-DockerServer $serverName $server
                }
                "cmd" {
                    Test-CommandServer $serverName $server
                }
                default {
                    Test-GenericServer $serverName $server
                }
            }
        } else {
            Write-TestResult "$serverName Configuration" $false "No command specified"
        }
    }
}

function Test-NPXServer {
    param([string]$Name, [object]$Config)
    
    if ($Config.args -and $Config.args.Length -gt 0) {
        $packageName = $Config.args[0]
        
        # Quick availability test
        try {
            $testCmd = "npx --yes $packageName --help"
            $output = Invoke-Expression $testCmd 2>&1
            $success = $LASTEXITCODE -eq 0 -or $output -match "help|usage|version"
            Write-TestResult "$Name Package Available" $success "Testing: $packageName"
        } catch {
            Write-TestResult "$Name Package Available" $false "Error testing $packageName"
        }
    } else {
        Write-TestResult "$Name Configuration" $false "No package specified in args"
    }
}

function Test-DockerServer {
    param([string]$Name, [object]$Config)
    
    if ($Config.args -and $Config.args.Length -gt 0) {
        # Test if docker is available (already tested above)
        try {
            docker --version | Out-Null
            Write-TestResult "$Name Docker Available" $true "Docker command accessible"
            
            # For docker servers, test if image exists or can be pulled
            $imageName = $Config.args | Where-Object { $_ -match "ghcr\.io|docker\.io" } | Select-Object -First 1
            if ($imageName) {
                Write-TestResult "$Name Image Configured" $true "Image: $imageName"
            }
        } catch {
            Write-TestResult "$Name Docker Available" $false "Docker not accessible"
        }
    }
}

function Test-CommandServer {
    param([string]$Name, [object]$Config)
    
    if ($Config.args -and $Config.args.Length -gt 1) {
        # This handles the Smithery CLI pattern: cmd /c npx ...
        $actualCommand = $Config.args[2]  # Skip /c and npx
        if ($actualCommand) {
            try {
                $testCmd = "npx --yes $actualCommand --version"
                $output = Invoke-Expression $testCmd 2>&1
                $success = $LASTEXITCODE -eq 0 -or $output -match "version|help"
                Write-TestResult "$Name Command Available" $success "Testing: $actualCommand"
            } catch {
                Write-TestResult "$Name Command Available" $false "Error testing $actualCommand"
            }
        }
    }
}

function Test-GenericServer {
    param([string]$Name, [object]$Config)
    
    try {
        $cmd = $Config.command
        $version = & $cmd --version 2>$null
        Write-TestResult "$Name Command Available" ($version -ne $null) "Command: $cmd"
    } catch {
        Write-TestResult "$Name Command Available" $false "Command not found: $($Config.command)"
    }
}

function Test-APIKeys {
    Write-TestHeader "API Keys Configuration"
    
    # Check environment variables and MCP config for API keys
    $apiKeys = @{
        "ANTHROPIC_API_KEY" = $env:ANTHROPIC_API_KEY
        "OPENAI_API_KEY" = $env:OPENAI_API_KEY
        "BROWSERBASE_API_KEY" = $env:BROWSERBASE_API_KEY
        "GITHUB_PERSONAL_ACCESS_TOKEN" = $env:GITHUB_PERSONAL_ACCESS_TOKEN
        "CONTEXT7_API_KEY" = $env:CONTEXT7_API_KEY
    }
    
    foreach ($keyName in $apiKeys.Keys) {
        $keyValue = $apiKeys.$keyName
        if ($keyValue) {
            $maskedKey = $keyValue.Substring(0, [Math]::Min(8, $keyValue.Length)) + "***"
            Write-TestResult "$keyName" $true "Set (${maskedKey})"
        } else {
            Write-TestResult "$keyName" $false "Not set"
        }
    }
}

function Show-Summary {
    Write-Host "`n" + "="*60 -ForegroundColor Magenta
    Write-Host "  MCP TESTING SUMMARY" -ForegroundColor Magenta  
    Write-Host "="*60 -ForegroundColor Magenta
    
    Write-Host "✅ Passed Tests: $($results.Passed.Count)" -ForegroundColor Green
    if ($results.Passed.Count -gt 0) {
        $results.Passed | ForEach-Object { Write-Host "   • $_" -ForegroundColor Green }
    }
    
    Write-Host "`n❌ Failed Tests: $($results.Failed.Count)" -ForegroundColor Red
    if ($results.Failed.Count -gt 0) {
        $results.Failed | ForEach-Object { Write-Host "   • $_" -ForegroundColor Red }
    }
    
    Write-Host "`n⚠️ Warnings: $($results.Warnings.Count)" -ForegroundColor Yellow
    if ($results.Warnings.Count -gt 0) {
        $results.Warnings | ForEach-Object { Write-Host "   • $_" -ForegroundColor Yellow }
    }
    
    $totalTests = $results.Passed.Count + $results.Failed.Count
    $successRate = if ($totalTests -gt 0) { [math]::Round(($results.Passed.Count / $totalTests) * 100) } else { 0 }
    
    Write-Host "`n📊 Success Rate: $successRate%" -ForegroundColor $(if ($successRate -ge 80) { "Green" } elseif ($successRate -ge 60) { "Yellow" } else { "Red" })
    
    if ($successRate -ge 90) {
        Write-Host "`n🎉 Excellent! MCP servers are ready to use!" -ForegroundColor Green
    } elseif ($successRate -ge 70) {
        Write-Host "`n⚠️ MCP setup is mostly working. Address failed tests when needed." -ForegroundColor Yellow
    } else {
        Write-Host "`n🔧 MCP setup needs attention. Run setup wizard for assistance." -ForegroundColor Red
        Write-Host "💡 Run: .\core-tools\scripts\setup-wizard.ps1" -ForegroundColor Cyan
    }
}

# Main execution
Write-Host "🔧 Lab Framework - MCP Server Testing" -ForegroundColor Cyan
Write-Host "Testing MCP server configuration and connectivity...`n" -ForegroundColor Gray

# Run tests
$nodeOk = Test-NodeDependencies
Test-DockerEnvironment
$mcpConfig = Test-MCPConfiguration

if ($mcpConfig) {
    Test-MCPServerAvailability $mcpConfig
}

Test-APIKeys

# Show results
Show-Summary

# Exit with appropriate code
$totalTests = $results.Passed.Count + $results.Failed.Count
$successRate = if ($totalTests -gt 0) { ($results.Passed.Count / $totalTests) } else { 0 }
exit $(if ($successRate -ge 0.7) { 0 } else { 1 }) 