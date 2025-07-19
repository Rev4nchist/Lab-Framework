# New Project Creation Script for The Lab
# Automates project setup following Lab conventions

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [string]$Description = "A new project from The Lab",
    
    [ValidateSet("node", "python", "dotnet", "static")]
    [string]$Template = "node",
    
    [switch]$CreateTask = $true,
    
    [switch]$DryRun = $false
)

Write-Host "🧪 Lab Project Creator" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan

# Generate project slug
$date = Get-Date -Format "yyyy-MM"
$slug = $ProjectName.ToLower() -replace '[^a-z0-9\-]', '-' -replace '-+', '-' -replace '^-|-$', ''
$projectSlug = "$date-$slug"
$projectPath = "projects/$projectSlug"

Write-Host "📋 Project Details:" -ForegroundColor Yellow
Write-Host "  Name: $ProjectName" -ForegroundColor White
Write-Host "  Slug: $projectSlug" -ForegroundColor White
Write-Host "  Template: $Template" -ForegroundColor White
Write-Host "  Path: $projectPath" -ForegroundColor White
Write-Host ""

if ($DryRun) {
    Write-Host "🔍 DRY RUN MODE - No changes will be made" -ForegroundColor Yellow
    Write-Host ""
}

# Check if project already exists
if (Test-Path $projectPath) {
    Write-Host "❌ Project '$projectSlug' already exists!" -ForegroundColor Red
    exit 1
}

# Create project structure
Write-Host "📁 Creating project structure..." -ForegroundColor Yellow

$directories = @("src", "tests", "docs")
$directories | ForEach-Object {
    $dir = "$projectPath/$_"
    if (!$DryRun) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  ✅ Created $dir" -ForegroundColor Green
    } else {
        Write-Host "  [DRY RUN] Would create $dir" -ForegroundColor Gray
    }
}

# Create README.md
Write-Host "📝 Creating README..." -ForegroundColor Yellow
$readmeContent = @"
# $ProjectName

> $Description

## Lab Heritage 🧪

This project was incubated in [The Lab](../../docs-hub/THE_LAB_README.md), an AI-powered development workspace.

- **Started**: $(Get-Date -Format "yyyy-MM-dd")
- **Lab Path**: ``projects/$projectSlug/``
- **TaskMaster Tag**: ``$slug``

## Quick Start

``````bash
# Development with Docker
docker build -t $slug .
docker run -p 8000:8000 $slug

# Local development
npm install
npm run dev
``````

## Features

- [ ] Initial setup
- [ ] Core functionality
- [ ] Testing framework

## Tech Stack

- **Template**: $Template
- **Deployment**: Azure Container Apps
- **Containerization**: Docker

## Development Workflow

### TaskMaster Integration
``````bash
# View current tasks
task-master next

# Update progress
task-master update-subtask --id [id] --prompt "[progress notes]"
``````

---

*Developed in The Lab - Where ideas become reality* 🧪✨
"@

if (!$DryRun) {
    $readmeContent | Out-File "$projectPath/README.md" -Encoding UTF8
    Write-Host "  ✅ Created README.md" -ForegroundColor Green
} else {
    Write-Host "  [DRY RUN] Would create README.md" -ForegroundColor Gray
}

# Create Dockerfile based on template
Write-Host "🐳 Creating Dockerfile..." -ForegroundColor Yellow

$dockerfiles = @{
    "node" = @"
FROM mcr.microsoft.com/appsvc/node:18-lts

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci --only=production

# Copy source code
COPY src/ ./src/

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

CMD ["npm", "start"]
"@
    "python" = @"
FROM mcr.microsoft.com/appsvc/python:3.11

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY src/ ./src/

EXPOSE 8000

CMD ["python", "src/app.py"]
"@
    "dotnet" = @"
FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app

COPY bin/Release/net8.0/publish/ .

EXPOSE 8000

CMD ["dotnet", "$ProjectName.dll"]
"@
    "static" = @"
FROM nginx:alpine

COPY src/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
"@
}

$dockerfileContent = $dockerfiles[$Template]
if (!$DryRun) {
    $dockerfileContent | Out-File "$projectPath/Dockerfile" -Encoding UTF8
    Write-Host "  ✅ Created Dockerfile ($Template template)" -ForegroundColor Green
} else {
    Write-Host "  [DRY RUN] Would create Dockerfile ($Template template)" -ForegroundColor Gray
}

# Create .gitignore
Write-Host "🚫 Creating .gitignore..." -ForegroundColor Yellow
$gitignoreContent = @"
# Dependencies
node_modules/
*.log

# Environment
.env
.env.local

# Build outputs
dist/
build/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Project specific
.cache/
coverage/
"@

if (!$DryRun) {
    $gitignoreContent | Out-File "$projectPath/.gitignore" -Encoding UTF8
    Write-Host "  ✅ Created .gitignore" -ForegroundColor Green
} else {
    Write-Host "  [DRY RUN] Would create .gitignore" -ForegroundColor Gray
}

# Initialize git
Write-Host "📡 Initializing git..." -ForegroundColor Yellow
if (!$DryRun) {
    Push-Location $projectPath
    git init
    git add .
    git commit -m "🧪 Initial commit from The Lab"
    Pop-Location
    Write-Host "  ✅ Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "  [DRY RUN] Would initialize git repository" -ForegroundColor Gray
}

# Create TaskMaster task
if ($CreateTask) {
    Write-Host "📋 Creating TaskMaster task..." -ForegroundColor Yellow
    
    $taskPrompt = "Project: $ProjectName - $Description. Set up in projects/$projectSlug/. Follow Lab workflow for development."
    
    if (!$DryRun) {
        Write-Host "  📝 Manual step required:" -ForegroundColor Yellow
        Write-Host "    Run: task-master add-task --prompt '$taskPrompt'" -ForegroundColor White
        Write-Host "    Run: task-master use-tag '$slug'" -ForegroundColor White
    } else {
        Write-Host "  [DRY RUN] Would create TaskMaster task" -ForegroundColor Gray
    }
}

# Summary
Write-Host ""
Write-Host "🎉 Project Created!" -ForegroundColor Green
Write-Host "=================" -ForegroundColor Green
Write-Host "Location: $projectPath" -ForegroundColor Cyan
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. 📋 Create TaskMaster task (if not done automatically)" -ForegroundColor White
Write-Host "2. 🔧 Add project-specific dependencies" -ForegroundColor White
Write-Host "3. 💻 Start development in src/ folder" -ForegroundColor White
Write-Host "4. 🧪 Test with Docker: docker build -t $slug ." -ForegroundColor White
Write-Host "5. 📝 Update README with actual features" -ForegroundColor White
Write-Host ""
Write-Host "Happy coding in The Lab! 🧪✨" -ForegroundColor Green

# Usage examples
Write-Host ""
Write-Host "💡 Usage Examples:" -ForegroundColor Cyan
Write-Host "  .\new-project.ps1 -ProjectName 'My Web App' -Template node" -ForegroundColor White
Write-Host "  .\new-project.ps1 -ProjectName 'Data API' -Template python -Description 'REST API for data processing'" -ForegroundColor White
Write-Host "  .\new-project.ps1 -ProjectName 'Dashboard' -Template static -DryRun" -ForegroundColor White 