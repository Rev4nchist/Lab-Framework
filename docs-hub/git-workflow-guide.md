# 🔀 Git Workflow & Configuration Guide

> Structured version control for The Lab's rapid development cycles

## 📋 Table of Contents

1. [Git Configuration](#git-configuration)
2. [Branch Strategy](#branch-strategy)
3. [Commit Conventions](#commit-conventions)
4. [Git Hooks](#git-hooks)
5. [TaskMaster Integration](#taskmaster-integration)
6. [Team Collaboration](#team-collaboration)

## Git Configuration

### Initial Setup

```bash
# Configure user information
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Configure line endings (cross-platform)
git config --global core.autocrlf true  # Windows
git config --global core.autocrlf input # macOS/Linux

# Enable color output
git config --global color.ui auto

# Set default branch name
git config --global init.defaultBranch main

# Configure merge strategy
git config --global pull.rebase false
```

### Lab-Specific Configuration

Create `.gitconfig` in your Lab root:

```ini
[core]
    autocrlf = true
    whitespace = fix,-indent-with-non-tab,trailing-space,cr-at-eol
    editor = code --wait

[alias]
    # Lab workflow aliases
    checkpoint = commit -m "🔖 Checkpoint: "
    feature = checkout -b feature/
    lab-status = status -sb
    lab-log = log --oneline --graph --decorate
    
    # TaskMaster integration
    tm-commit = !git commit -m "$(tm show --current --format=commit)"
    
[branch]
    autosetuprebase = always

[push]
    default = current
```

## Branch Strategy

### Branch Naming Convention

```
main
├── feature/[taskmaster-tag]-[description]
├── bugfix/[task-id]-[description]
├── experiment/[date]-[description]
└── release/[version]
```

### Examples

```bash
# Feature branches (tied to TaskMaster tags)
feature/auth-jwt-implementation
feature/dashboard-user-analytics

# Bugfix branches (tied to task IDs)
bugfix/15.2-token-expiration
bugfix/23-api-validation

# Experiment branches
experiment/2025-01-ai-chatbot
experiment/2025-01-performance-optimization
```

### Branch Workflow

1. **Create Feature Branch**
   ```bash
   # Create TaskMaster tag first
   tm add-tag feature-auth --description="Authentication system"
   
   # Create matching Git branch
   git checkout -b feature/auth-implementation
   
   # Link to TaskMaster
   tm use-tag feature-auth
   ```

2. **Work on Feature**
   ```bash
   # Regular commits
   git add .
   git commit -m "feat(auth): implement JWT token generation"
   
   # Checkpoint commits (SuperClaude)
   /user:git --checkpoint --label "JWT implementation complete"
   ```

3. **Keep Updated**
   ```bash
   # Regularly sync with main
   git checkout main
   git pull origin main
   git checkout feature/auth-implementation
   git merge main
   ```

4. **Complete Feature**
   ```bash
   # Final cleanup
   git rebase -i main  # Clean up commits
   
   # Create PR
   gh pr create --title "Feature: Authentication System" \
                --body "Implements tasks from feature-auth tag"
   ```

## Commit Conventions

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix  
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **perf**: Performance improvements
- **test**: Test additions/changes
- **chore**: Build process or auxiliary tool changes
- **tm**: TaskMaster-related updates

### Examples

```bash
# Feature commit
git commit -m "feat(auth): add JWT token validation

- Implement token verification middleware
- Add expiration checking
- Handle refresh token logic

TaskMaster: Completes task 15.2"

# Checkpoint commit
git commit -m "🔖 Checkpoint: auth module 50% complete

Current state:
- JWT generation working
- Basic validation implemented
- Next: Implement refresh token logic

TaskMaster: Working on task 15"

# TaskMaster update
git commit -m "tm(status): mark auth tasks complete

- Task 15: Authentication system [DONE]
- Task 15.1: JWT implementation [DONE]
- Task 15.2: Token validation [DONE]"
```

## Git Hooks

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# Lab Framework pre-commit hook

# Run tests if they exist
if [ -f "package.json" ] && grep -q "\"test\"" package.json; then
    echo "Running tests..."
    npm test || exit 1
fi

# Check for console.log statements
if git diff --cached --name-only | grep -E '\.(js|ts|jsx|tsx)$' | xargs grep -n "console\.log" > /dev/null; then
    echo "❌ Found console.log statements. Please remove them."
    exit 1
fi

# Validate TaskMaster state
if [ -f ".taskmaster/tasks/tasks.json" ]; then
    tm validate || echo "⚠️  TaskMaster validation failed (non-blocking)"
fi

echo "✅ Pre-commit checks passed"
```

### Post-commit Hook

Create `.git/hooks/post-commit`:

```bash
#!/bin/bash
# Lab Framework post-commit hook

# Update TaskMaster if commit mentions tasks
COMMIT_MSG=$(git log -1 --pretty=%B)
if echo "$COMMIT_MSG" | grep -E "(task|tm|TaskMaster)" > /dev/null; then
    echo "📝 Updating TaskMaster records..."
    # Extract task IDs and update
    TASK_IDS=$(echo "$COMMIT_MSG" | grep -oE "task [0-9]+(\.[0-9]+)?" | cut -d' ' -f2)
    for ID in $TASK_IDS; do
        tm update-subtask --id="$ID" --prompt="Git commit: $(git rev-parse --short HEAD)"
    done
fi
```

### Setup Hooks

```bash
# Make hooks executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/post-commit

# Or use a hooks manager
npm install --save-dev husky
npx husky install
```

## TaskMaster Integration

### Linking Commits to Tasks

1. **Reference Tasks in Commits**
   ```bash
   git commit -m "feat(api): implement user endpoints

   Completes TaskMaster tasks:
   - Task 12: User CRUD API
   - Task 12.1: GET /users endpoint
   - Task 12.2: POST /users endpoint"
   ```

2. **Auto-generate Commit Messages**
   ```bash
   # Create alias in .bashrc/.zshrc
   tm-commit() {
     local task_id=$1
     local task_info=$(tm show $task_id --format=oneline)
     git commit -m "feat: $task_info (Task $task_id)"
   }
   
   # Usage
   tm-commit 15.2
   ```

3. **Track Progress in Git**
   ```bash
   # Create progress tag
   git tag -a "task-15-complete" -m "Authentication system complete"
   
   # Push with tags
   git push origin feature/auth-implementation --tags
   ```

## Team Collaboration

### Pull Request Template

Create `.github/pull_request_template.md`:

```markdown
## Description
Brief description of changes

## TaskMaster Tasks Completed
- [ ] Task #XX: Description
- [ ] Task #XX.X: Sub-task description

## Type of Change
- [ ] 🐛 Bug fix
- [ ] ✨ New feature
- [ ] 🔨 Refactoring
- [ ] 📚 Documentation
- [ ] 🧪 Tests

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows Lab standards
- [ ] TaskMaster updated
- [ ] Documentation updated
- [ ] No console.log statements
- [ ] Git history is clean
```

### Merge Strategies

1. **Feature Branches**: Squash and merge
   ```bash
   git checkout main
   git merge --squash feature/auth-implementation
   git commit -m "Feature: Complete authentication system (#15)"
   ```

2. **Bugfixes**: Regular merge
   ```bash
   git checkout main
   git merge bugfix/15.2-token-expiration
   ```

3. **Experiments**: Cherry-pick valuable commits
   ```bash
   git cherry-pick abc123..def456
   ```

### Conflict Resolution

```bash
# When conflicts occur with tasks.json
git checkout --theirs .taskmaster/tasks/tasks.json
tm validate
tm fix-dependencies

# For code conflicts
git mergetool  # Use visual merge tool
# or
code --wait  # Use VS Code for resolution
```

## Best Practices

### 1. Commit Frequency
- Commit at logical stopping points
- Use checkpoints for work-in-progress
- Push at least daily

### 2. Branch Hygiene
- Delete merged branches
- Keep branches focused on single features
- Rebase feature branches regularly

### 3. History Management
- Use interactive rebase to clean up before PR
- Write meaningful commit messages
- Reference TaskMaster tasks

### 4. Security
- Never commit `.env` files
- Use git-secrets to prevent API key leaks
- Review diff before committing

### Quick Reference

```bash
# Start new feature
tm add-tag feature-payments
git checkout -b feature/payments-stripe
tm use-tag feature-payments

# Regular workflow
git add -p  # Stage selectively
git commit -m "feat(payments): add Stripe integration"
tm update-subtask --id=20.1 --prompt="Stripe SDK integrated"

# Complete feature
git rebase -i main
gh pr create
tm set-status --id=20 --status=done

# Clean up
git checkout main
git branch -d feature/payments-stripe
tm use-tag master
```

---

*Remember: Good Git practices enable confident experimentation and easy rollbacks - essential for The Lab's rapid development approach.*