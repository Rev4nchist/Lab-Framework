# 🚀 Lab Framework - Getting Started Guide

> **New to the Lab?** Welcome! This guide will get you from zero to productive in 30 minutes.

---

## 🤖 **NEW USER? TELL YOUR AI AGENT!**

**Just cloned this repo?** Tell any AI assistant:
> "I just cloned the Lab Framework"

Your agent will **immediately guide you through setup** - no searching for docs needed! 

📖 **[View Agent Training Protocol](AGENT_ONBOARDING_PROTOCOL.md)**

---

## 🎯 Quick Setup Checklist

**Before you start**, you'll need:
- [ ] **Git** installed
- [ ] **Node.js** (v18+) 
- [ ] **PowerShell** (Windows) or **PowerShell Core** (Mac/Linux)
- [ ] **Docker Desktop** (optional but recommended)
- [ ] **Claude Account** with API access
- [ ] **Cursor IDE** (recommended) or VS Code

## 🚀 30-Minute Setup Journey

### Phase 1: Clone & Basic Setup (5 minutes)

```bash
# 1. Clone the framework
git clone https://github.com/Rev4nchist/Lab-Framework.git my-lab
cd my-lab

# 2. Run the setup wizard
# Windows:
.\core-tools\scripts\setup-wizard.ps1

# Mac/Linux:
pwsh core-tools/scripts/setup-wizard.ps1
```

**🤖 Agent Trigger**: When you tell your AI assistant "I cloned the Lab Framework", they'll guide you through this automatically!

### Phase 2: MCP Configuration (10 minutes)

The setup wizard will help you:

1. **Copy MCP template**: `.cursor/mcp.json.example` → `.cursor/mcp.json`
2. **Add API keys**:
   - Anthropic (Claude) - Required
   - Browserbase - For web automation
   - GitHub Token - For repository access
   - Context7 - For documentation lookup
3. **Test connections**: Validate each MCP server
4. **Restart Cursor**: Apply new configuration

### Phase 3: Validation & Testing (10 minutes)

```bash
# Validate your setup
.\core-tools\scripts\validate-setup.ps1

# Test MCP servers specifically  
.\core-tools\scripts\test-mcp-servers.ps1

# Debug any issues
.\core-tools\scripts\debug-mcp.ps1
```

### Phase 4: Create Your First Project (5 minutes)

```bash
# Create a new project
.\core-tools\scripts\lab-new-project.ps1 -ProjectName "My First Lab Project"

# Or with specific template
.\core-tools\scripts\lab-new-project.ps1 -ProjectName "Data Analysis" -Template python
```

---

## 🛠️ Development Workflow

### Daily Routine

1. **Start your day**: Check what to work on
   ```bash
   # If using TaskMaster
   task-master next
   ```

2. **Create projects**: Use automated templates
   ```bash
   .\core-tools\scripts\lab-new-project.ps1 -ProjectName "awesome-idea"
   ```

3. **Develop with assistance**: Use Claude Code integration
   - Press `Cmd+Esc` (Mac) or `Ctrl+Esc` (Windows)
   - AI-powered coding assistance with full context

4. **Test and validate**: Built-in health checks
   ```bash
   .\core-tools\scripts\validate-setup.ps1 -Quick
   ```

### Project Structure

```
lab-framework/
├── projects/           # Your main development projects  
│   └── 2025-01-my-app/ # Date-prefixed project folders
├── experiments/        # Quick prototypes and tests
├── archives/           # Completed/graduated projects
├── core-tools/         # Lab automation scripts
│   └── scripts/        # Setup, validation, project tools
├── docs-hub/          # Documentation and templates
│   └── templates/     # Project templates and examples
└── .cursor/           # IDE configuration
    ├── mcp.json       # MCP server configuration  
    └── rules/         # Development guidelines
```

---

## 🎯 Key Features

### Automated Project Management
- **Smart Templates**: Node.js, Python, static sites
- **Git Integration**: Automatic repository initialization
- **Docker Ready**: Containerization built-in
- **TaskMaster**: AI-powered task tracking (optional)

### AI-Powered Development
- **Claude Code**: Integrated AI coding assistant
- **MCP Servers**: Enhanced AI capabilities
- **Context7**: Real-time documentation lookup
- **BrowserBase**: Web automation for testing

### Enterprise Productivity
- **Graduation Process**: Move projects to production repos
- **Team Collaboration**: Git hooks and shared workflows
- **Azure Integration**: Cloud deployment ready
- **Validation Systems**: Automated health monitoring

---

## 🚨 Troubleshooting

### Common Issues

#### "Setup wizard won't run"
```bash
# Fix PowerShell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then try again
.\core-tools\scripts\setup-wizard.ps1
```

#### "MCP servers not connecting"
```bash
# Run diagnostics
.\core-tools\scripts\debug-mcp.ps1

# Common fixes:
# 1. Restart Cursor after MCP setup
# 2. Check API keys in .cursor/mcp.json
# 3. Ensure Node.js 18+ is installed
```

#### "Docker commands failing"
- Ensure Docker Desktop is running
- Check Docker is in your PATH
- Verify Docker daemon is accessible

### Get Help

1. **Automated debugging**: `.\core-tools\scripts\debug-mcp.ps1`
2. **Validation report**: `.\core-tools\scripts\validate-setup.ps1`
3. **Ask your AI agent**: "Help me debug my Lab Framework setup"
4. **Check documentation**: Files in `docs-hub/`

---

## 🎓 Next Steps

### After Setup Complete

1. **Explore examples**: Check out `experiments/` folder
2. **Read workflows**: Review `.cursor/rules/` for best practices
3. **Create your first real project**: Use the new-project script
4. **Join the community**: Share your Lab Framework projects

### Advanced Features

- **TaskMaster Integration**: AI project management
- **Claude Code Mastery**: Advanced AI coding techniques  
- **Team Collaboration**: Git hooks and shared workflows
- **Production Deployment**: Azure/AWS integration

### Graduation Path

When your project is ready for production:

```bash
# Graduate to its own repository
.\core-tools\scripts\lab-graduate.ps1 -ProjectSlug "2025-01-my-app" -NewRepoName "my-awesome-app"
```

---

## 💡 Pro Tips

### Maximum Productivity
- **Use AI assistance**: Always start with "How should I approach [task]?"
- **Leverage templates**: Don't start from scratch
- **Validate early**: Run health checks regularly
- **Document decisions**: Update TaskMaster with progress

### Best Practices
- **Follow naming conventions**: Date-prefixed project folders
- **Use Docker**: Containerize everything for consistency
- **Git frequently**: Small, focused commits
- **Test automated**: Use the validation scripts

### Team Integration
- **Share the framework**: Clone for each team member
- **Consistent setup**: Everyone uses the same onboarding
- **Collaborative workflows**: Use shared TaskMaster tags
- **Graduate together**: Move team projects to production

---

## 🎉 Success Indicators

**You'll know the Lab Framework is working when:**

✅ **Setup completed in under 30 minutes**
✅ **All MCP servers responding**
✅ **Claude Code integration working**
✅ **First project created successfully**
✅ **You feel excited to start building!**

---

## 🚀 What Makes This Special

The Lab Framework isn't just another development setup - it's a **complete productivity ecosystem** that:

- **Eliminates setup friction** with automated onboarding
- **Accelerates development** with AI-powered assistance  
- **Ensures consistency** across projects and teams
- **Scales effortlessly** from personal to enterprise use
- **Evolves continuously** with your workflow needs

**Welcome to the future of development productivity!** 🎯

---

*Need help? Just tell your AI assistant: "I need help with the Lab Framework"* 