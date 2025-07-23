# Lab Graduation Script
# Moves a project from The Lab to its own repository

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectSlug,
    
    [Parameter(Mandatory=$true)]
    [string]$NewRepoName,
    
    [string]$Description = "Graduated from The Lab",
    
    [switch]$Private = $false,
    
    [switch]$DryRun = $false
)

Write-Host "🚀 Lab Graduation Script" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan

# Validate project exists
$projectPath = "projects/$ProjectSlug"
if (!(Test-Path $projectPath)) {
    Write-Host "❌ Project '$ProjectSlug' not found in projects/" -ForegroundColor Red
    Write-Host "Available projects:" -ForegroundColor Yellow
    Get-ChildItem projects/ -Directory | ForEach-Object { Write-Host "  - $($_.Name)" }
    exit 1
}

Write-Host "📋 Graduation Plan:" -ForegroundColor Yellow
Write-Host "  Project: $ProjectSlug" -ForegroundColor White
Write-Host "  New Repo: $NewRepoName" -ForegroundColor White
Write-Host "  Description: $Description" -ForegroundColor White
Write-Host "  Private: $Private" -ForegroundColor White
Write-Host ""

if ($DryRun) {
    Write-Host "🔍 DRY RUN MODE - No changes will be made" -ForegroundColor Yellow
    Write-Host ""
}

# Step 1: Create backup
$backupPath = "../$NewRepoName-backup"
Write-Host "💾 Creating backup..." -ForegroundColor Yellow
if (!$DryRun) {
    Copy-Item $projectPath $backupPath -Recurse
    Write-Host "  ✅ Backup created at $backupPath" -ForegroundColor Green
} else {
    Write-Host "  [DRY RUN] Would create backup at $backupPath" -ForegroundColor Gray
}

# Step 2: Prepare project for graduation
Write-Host "📝 Preparing project files..." -ForegroundColor Yellow

$readmePath = "$projectPath/README.md"
if (Test-Path $readmePath) {
    $readmeContent = Get-Content $readmePath -Raw
    $updatedReadme = @"
# $NewRepoName

> Graduated from The Lab 🎓

$readmeContent

## Lab Heritage

This project was incubated in [The Lab](https://github.com/yourorg/the-lab), an AI-powered development workspace.

**Original Lab Path**: `projects/$ProjectSlug`
**Graduation Date**: $(Get-Date -Format "yyyy-MM-dd")

## Development Notes

- Uses Docker for containerization
- Follows Lab naming conventions
- Integrated with TaskMaster for project management
- Built with Azure deployment in mind

"@
    
    if (!$DryRun) {
        $updatedReadme | Out-File $readmePath -Encoding UTF8
        Write-Host "  ✅ Updated README.md with Lab heritage" -ForegroundColor Green
    } else {
        Write-Host "  [DRY RUN] Would update README.md" -ForegroundColor Gray
    }
}

# Step 3: Create new repository
Write-Host "🏗️ Creating GitHub repository..." -ForegroundColor Yellow

$createRepoCommand = @"
# Using GitHub MCP to create repository
# This would be automated in real implementation
mcp_GitHub_create_repository --name '$NewRepoName' --description '$Description' --private=$Private
"@

if (!$DryRun) {
    Write-Host "  📝 Manual step required:" -ForegroundColor Yellow
    Write-Host "    Run: mcp_GitHub_create_repository --name '$NewRepoName' --description '$Description'" -ForegroundColor White
    Write-Host "  ⏳ Waiting for user confirmation..." -ForegroundColor Yellow
    Read-Host "Press Enter after creating the GitHub repository"
} else {
    Write-Host "  [DRY RUN] Would create GitHub repo: $NewRepoName" -ForegroundColor Gray
}

# Step 4: Set up git and push
Write-Host "📡 Setting up git and pushing..." -ForegroundColor Yellow

$gitCommands = @"
cd $projectPath
git add .
git commit -m "🎓 Graduated from The Lab"
git branch -M main
git remote add origin https://github.com/[username]/$NewRepoName.git
git push -u origin main
"@

if (!$DryRun) {
    Push-Location $projectPath
    
    # Check if there are changes to commit
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        git add .
        git commit -m "🎓 Graduated from The Lab - Final cleanup"
    }
    
    Write-Host "  📝 Manual step required:" -ForegroundColor Yellow
    Write-Host "    1. Get repository URL from GitHub" -ForegroundColor White
    Write-Host "    2. Run: git remote add origin [repo-url]" -ForegroundColor White
    Write-Host "    3. Run: git push -u origin main" -ForegroundColor White
    
    Pop-Location
} else {
    Write-Host "  [DRY RUN] Would set up git remote and push" -ForegroundColor Gray
}

# Step 5: Archive in Lab
Write-Host "📁 Archiving in Lab..." -ForegroundColor Yellow

$archivePath = "archives/$ProjectSlug-$(Get-Date -Format 'yyyyMMdd')"
if (!$DryRun) {
    Move-Item $projectPath $archivePath
    Write-Host "  ✅ Archived to $archivePath" -ForegroundColor Green
} else {
    Write-Host "  [DRY RUN] Would archive to $archivePath" -ForegroundColor Gray
}

# Step 6: Update TaskMaster
Write-Host "📋 Updating TaskMaster..." -ForegroundColor Yellow
if (!$DryRun) {
    Write-Host "  📝 Manual step required:" -ForegroundColor Yellow
    Write-Host "    Run: task-master update-task --tag '$ProjectSlug' --prompt 'Project graduated to https://github.com/[username]/$NewRepoName'" -ForegroundColor White
} else {
    Write-Host "  [DRY RUN] Would update TaskMaster tags" -ForegroundColor Gray
}

# Summary
Write-Host ""
Write-Host "🎉 Graduation Complete!" -ForegroundColor Green
Write-Host "===================" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. ✅ Backup created" -ForegroundColor Green
Write-Host "2. 📝 Complete GitHub repository setup" -ForegroundColor Yellow
Write-Host "3. 📡 Push to new repository" -ForegroundColor Yellow
Write-Host "4. 📋 Update TaskMaster records" -ForegroundColor Yellow
Write-Host "5. 🧹 Clean up backup when confirmed working" -ForegroundColor Yellow
Write-Host ""
Write-Host "Your project has graduated from The Lab! 🎓" -ForegroundColor Green
Write-Host "Repository: https://github.com/[username]/$NewRepoName" -ForegroundColor Cyan

# Usage examples
Write-Host ""
Write-Host "💡 Usage Examples:" -ForegroundColor Cyan
Write-Host "  .\lab-graduate.ps1 -ProjectSlug '2025-01-my-app' -NewRepoName 'my-awesome-app'" -ForegroundColor White
Write-Host "  .\lab-graduate.ps1 -ProjectSlug '2025-01-api' -NewRepoName 'company-api' -Private" -ForegroundColor White
Write-Host "  .\lab-graduate.ps1 -ProjectSlug '2025-01-test' -NewRepoName 'test-app' -DryRun" -ForegroundColor White 