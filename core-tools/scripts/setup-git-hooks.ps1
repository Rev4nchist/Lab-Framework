# Git Hooks Setup Script for The Lab Framework
# Sets up pre-commit and post-commit hooks with TaskMaster integration

Write-Host "🔧 Setting up Git hooks for The Lab Framework..." -ForegroundColor Cyan

# Check if we're in a git repository
if (-not (Test-Path .git)) {
    Write-Host "❌ Not in a git repository. Please run from project root." -ForegroundColor Red
    exit 1
}

# Create hooks directory if it doesn't exist
$hooksDir = ".git/hooks"
if (-not (Test-Path $hooksDir)) {
    New-Item -ItemType Directory -Path $hooksDir -Force
}

# Pre-commit hook content
$preCommitHook = @'
#!/bin/bash
# Lab Framework pre-commit hook

echo "🔍 Running pre-commit checks..."

# Check for console.log statements in JS/TS files
if git diff --cached --name-only | grep -E '\.(js|ts|jsx|tsx)$' | xargs grep -n "console\.log" > /dev/null 2>&1; then
    echo "❌ Found console.log statements. Please remove them."
    echo "   Use proper logging library or remove debug statements."
    exit 1
fi

# Check for API keys or secrets
if git diff --cached --name-only | xargs grep -E "(api_key|apikey|api-key|secret|password|token)" -i > /dev/null 2>&1; then
    echo "⚠️  Warning: Possible secrets detected. Please review carefully."
    echo "   Never commit API keys or passwords!"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Run tests if package.json exists and has test script
if [ -f "package.json" ] && grep -q "\"test\"" package.json; then
    echo "🧪 Running tests..."
    npm test --silent
    if [ $? -ne 0 ]; then
        echo "❌ Tests failed. Please fix before committing."
        exit 1
    fi
fi

# Validate TaskMaster if initialized
if [ -f ".taskmaster/tasks/tasks.json" ]; then
    echo "📋 Validating TaskMaster configuration..."
    tm validate 2>/dev/null || echo "⚠️  TaskMaster validation failed (non-blocking)"
fi

echo "✅ Pre-commit checks passed!"
'@

# Post-commit hook content
$postCommitHook = @'
#!/bin/bash
# Lab Framework post-commit hook

# Extract commit message
COMMIT_MSG=$(git log -1 --pretty=%B)
COMMIT_HASH=$(git rev-parse --short HEAD)

# Update TaskMaster if commit mentions tasks
if echo "$COMMIT_MSG" | grep -iE "(task|tm:|TaskMaster:)" > /dev/null; then
    echo "📝 Updating TaskMaster records..."
    
    # Extract task IDs (matches patterns like: task 15, task 15.2, tm:15.2)
    TASK_IDS=$(echo "$COMMIT_MSG" | grep -oE "(task |tm:)[0-9]+(\.[0-9]+)?" | sed 's/task //g' | sed 's/tm://g')
    
    if [ -n "$TASK_IDS" ]; then
        for ID in $TASK_IDS; do
            echo "   Updating task $ID with commit $COMMIT_HASH"
            tm update-subtask --id="$ID" --prompt="Git commit: $COMMIT_HASH - ${COMMIT_MSG%%$'\n'*}" 2>/dev/null
        done
    fi
fi

# Create checkpoint tag if commit message contains "checkpoint"
if echo "$COMMIT_MSG" | grep -i "checkpoint" > /dev/null; then
    TAG_NAME="checkpoint-$(date +%Y%m%d-%H%M%S)"
    git tag -a "$TAG_NAME" -m "Checkpoint: $COMMIT_MSG"
    echo "🏷️  Created checkpoint tag: $TAG_NAME"
fi
'@

# Write hooks to files
Write-Host "📝 Creating pre-commit hook..." -ForegroundColor Yellow
$preCommitHook | Out-File -FilePath "$hooksDir/pre-commit" -Encoding UTF8 -NoNewline

Write-Host "📝 Creating post-commit hook..." -ForegroundColor Yellow  
$postCommitHook | Out-File -FilePath "$hooksDir/post-commit" -Encoding UTF8 -NoNewline

# Make hooks executable (Windows Git Bash compatibility)
if (Get-Command bash -ErrorAction SilentlyContinue) {
    bash -c "chmod +x .git/hooks/pre-commit"
    bash -c "chmod +x .git/hooks/post-commit"
}

Write-Host "✅ Git hooks installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Hooks installed:" -ForegroundColor Cyan
Write-Host "  - pre-commit: Validates code quality and TaskMaster state"
Write-Host "  - post-commit: Updates TaskMaster and creates checkpoint tags"
Write-Host ""
Write-Host "To test hooks, make a commit with:" -ForegroundColor Yellow
Write-Host '  git commit -m "feat: implement feature (task 15.2)"'