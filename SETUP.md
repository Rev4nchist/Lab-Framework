# 🧪 Lab Setup Guide

## Quick Start for New Team Members

### 1. Clone & Setup
```bash
# Clone your team's Lab repository
git clone [your-team-repo-url] my-lab
cd my-lab

# Make scripts executable (Windows)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 2. Verify Prerequisites
```bash
# Check required tools
docker --version          # Should show Docker version
task-master --version     # Should show TaskMaster version (if installed)
powershell --version      # Should show PowerShell version
```

### 3. Test Your Lab
```bash
# Create a test project
.\core-tools\scripts\new-project.ps1 -ProjectName "Test Project" -Template node -DryRun

# If the dry run looks good, create it for real
.\core-tools\scripts\new-project.ps1 -ProjectName "Test Project" -Template node
```

### 4. Configure Your Environment
- Set up TaskMaster with your API keys
- Configure Docker for your development environment
- Add any team-specific configurations

### 5. Start Building!
```bash
# Create your first real project
.\core-tools\scripts\new-project.ps1 -ProjectName "My Awesome App" -Template node

# Navigate to your project
cd projects/2025-01-my-awesome-app

# Start developing!
```

## Troubleshooting

### Script Execution Issues
If you get execution policy errors:
```bash
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Docker Issues
Make sure Docker Desktop is running and you can execute:
```bash
docker run hello-world
```

### TaskMaster Integration
Follow your team's TaskMaster setup guide for API configuration.

## Need Help?
- Check the main [README.md](README.md) for detailed documentation
- Review the [Lab documentation](docs-hub/THE_LAB_README.md)
- Ask your team lead for team-specific configurations 