#Requires -Version 5.1

<#
.SYNOPSIS
    Create a new project in the Lab Framework
.DESCRIPTION
    Sets up a new project with proper Lab Framework structure and integration
.EXAMPLE
    .\core-tools\scripts\lab-new-project.ps1 "my-awesome-experiment"
.EXAMPLE
    .\core-tools\scripts\lab-new-project.ps1 "data-analysis" -Template experiment -OpenInCursor
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [ValidateSet("experiment", "project", "archive")]
    [string]$Template = "experiment",
    
    [switch]$OpenInCursor,
    [switch]$SkipGit,
    [switch]$InitTaskMaster
)

# Validate project name
if (-not ($ProjectName -match '^[a-zA-Z0-9-_]+$')) {
    Write-Host "❌ Project name can only contain letters, numbers, hyphens, and underscores" -ForegroundColor Red
    exit 1
}

# Define project paths based on template
$basePath = switch ($Template) {
    "experiment" { "experiments" }
    "project" { "projects" }
    "archive" { "archives" }
    default { "experiments" }
}

$projectPath = Join-Path $basePath $ProjectName

Write-Host "🚀 Creating new ${Template}: $ProjectName" -ForegroundColor Cyan
Write-Host "📁 Location: $projectPath" -ForegroundColor Gray

# Check if project already exists
if (Test-Path $projectPath) {
    Write-Host "❌ Project already exists at: $projectPath" -ForegroundColor Red
    exit 1
}

try {
    # Create project directory
    New-Item -ItemType Directory -Path $projectPath -Force | Out-Null
    Write-Host "✅ Created project directory" -ForegroundColor Green
    
    # Create basic project structure
    $subdirs = @('src', 'docs', 'data', 'scripts')
    foreach ($dir in $subdirs) {
        $fullPath = Join-Path $projectPath $dir
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    }
    Write-Host "✅ Created project structure" -ForegroundColor Green
    
    # Create README based on template
    $readmeContent = switch ($Template) {
        "experiment" {
            @"
# $ProjectName

> 🧪 **Experiment** - Quick prototype and testing

## Overview
Brief description of what this experiment does.

## Quick Start
``````bash
# Install dependencies (if any)
npm install

# Run the experiment
npm run dev
``````

## Notes
- Created: $(Get-Date -Format 'yyyy-MM-dd')
- Status: Active
- Next steps: [Add your next steps here]

## Related
- Link to inspiration/related work
- References and resources
"@
        }
        "project" {
            @"
# $ProjectName

> 🚀 **Project** - Full-featured application or tool

## Overview
Comprehensive description of the project's purpose and goals.

## Features
- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3

## Quick Start
``````bash
# Install dependencies
npm install

# Development
npm run dev

# Build
npm run build

# Test
npm test
``````

## Architecture
- **Frontend**: [Technology stack]
- **Backend**: [Technology stack]
- **Database**: [Database choice]
- **Deployment**: [Deployment strategy]

## Development
- Created: $(Get-Date -Format 'yyyy-MM-dd')
- Status: In Development
- Version: 0.1.0

## Contributing
Guidelines for contributing to this project.
"@
        }
        "archive" {
            @"
# $ProjectName

> 📦 **Archive** - Completed or archived work

## Overview
Description of the archived project or experiment.

## Archive Details
- **Original Purpose**: [What this was for]
- **Status**: Archived
- **Date Archived**: $(Get-Date -Format 'yyyy-MM-dd')
- **Reason**: [Why it was archived]

## Contents
Brief description of what's included in this archive.

## Notes
- Original creation date: [When it was first created]
- Key learnings: [What was learned]
- Potential future use: [How this might be useful later]
"@
        }
    }
    
    $readmePath = Join-Path $projectPath "README.md"
    Set-Content -Path $readmePath -Value $readmeContent -Encoding UTF8
    Write-Host "✅ Created README.md" -ForegroundColor Green
    
    # Create package.json for projects/experiments
    if ($Template -ne "archive") {
        $packageJsonContent = @{
            "name" = $ProjectName.ToLower()
            "version" = "0.1.0"
            "description" = "Lab Framework $Template"
            "type" = "module"
            "scripts" = @{
                "dev" = "echo 'Add your development command here'"
                "build" = "echo 'Add your build command here'"
                "test" = "echo 'Add your test command here'"
                "start" = "echo 'Add your start command here'"
            }
            "keywords" = @($Template, "lab-framework")
            "author" = ""
            "license" = "MIT"
        }
        
        $packagePath = Join-Path $projectPath "package.json"
        $packageJsonContent | ConvertTo-Json -Depth 10 | Set-Content -Path $packagePath -Encoding UTF8
        Write-Host "✅ Created package.json" -ForegroundColor Green
    }
    
    # Create .gitignore
    $gitignoreContent = @"
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment variables
.env
.env.local
.env.*.local

# Build outputs
dist/
build/
*.tgz

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
logs
*.log

# Temporary files
tmp/
temp/
"@
    
    $gitignorePath = Join-Path $projectPath ".gitignore"
    Set-Content -Path $gitignorePath -Value $gitignoreContent -Encoding UTF8
    Write-Host "✅ Created .gitignore" -ForegroundColor Green
    
    # Initialize TaskMaster if requested
    if ($InitTaskMaster) {
        try {
            $taskMasterConfig = @"
{
  "project": {
    "name": "$ProjectName",
    "description": "Lab Framework $Template",
    "version": "0.1.0"
  },
  "ai": {
    "model": "claude-3-5-sonnet-20241022",
    "provider": "anthropic"
  },
  "global": {
    "defaultTag": "master",
    "defaultSubtasks": 5,
    "defaultPriority": "medium"
  }
}
"@
            
            $tmConfigDir = Join-Path $projectPath ".taskmaster"
            New-Item -ItemType Directory -Path $tmConfigDir -Force | Out-Null
            
            $tmConfigPath = Join-Path $tmConfigDir "config.json"
            Set-Content -Path $tmConfigPath -Value $taskMasterConfig -Encoding UTF8
            Write-Host "✅ Initialized TaskMaster configuration" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  TaskMaster initialization failed: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
    
    # Initialize git repository if not skipped
    if (-not $SkipGit) {
        Push-Location $projectPath
        try {
            git init -q
            git add . 
                         $commitMessage = "feat: Initialize $Template '$ProjectName'

Created using Lab Framework project generator
- Basic project structure
- README.md with template
- package.json configuration
- .gitignore setup"
             
             if ($InitTaskMaster) {
                 $commitMessage += "`n- TaskMaster integration"
             }
             
             git commit -q -m $commitMessage
            
            Write-Host "✅ Initialized git repository" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  Git initialization failed: $($_.Exception.Message)" -ForegroundColor Yellow
        }
        Pop-Location
    }
    
} catch {
    Write-Host "❌ Failed to create project: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Success message
Write-Host "`n🎉 Project created successfully!" -ForegroundColor Green
Write-Host "📍 Location: $projectPath" -ForegroundColor Cyan

# Next steps
Write-Host "`n📋 Next Steps:" -ForegroundColor Magenta
Write-Host "   1. Navigate to project: cd $projectPath" -ForegroundColor Gray
if ($Template -ne "archive") {
    Write-Host "   2. Install dependencies: npm install" -ForegroundColor Gray
    Write-Host "   3. Start development: npm run dev" -ForegroundColor Gray
}
Write-Host "   4. Edit README.md with project details" -ForegroundColor Gray

if ($InitTaskMaster) {
    Write-Host "   5. Set up TaskMaster: task-master init" -ForegroundColor Gray
}

# Open in Cursor if requested
if ($OpenInCursor) {
    try {
        Start-Process "cursor" -ArgumentList $projectPath
        Write-Host "🖥️  Opening in Cursor..." -ForegroundColor Cyan
    } catch {
        Write-Host "⚠️  Could not open in Cursor: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host "   You can manually open: cursor $projectPath" -ForegroundColor Gray
    }
}

Write-Host "`n🚀 Happy coding!" -ForegroundColor Green 