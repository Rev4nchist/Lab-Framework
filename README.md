# 🧪 The Lab - AI Development Workspace Framework

> Transform your development process with structured innovation and AI-powered workflows
> a complete environment set up guide for our teammates to clone and set up a custom workspace

---

## 🤖 **NEW USER? TELL YOUR AI AGENT!**

**Just cloned this repository?** Tell any AI assistant:
> "I just cloned the Lab Framework"

Your AI agent will **immediately guide you through setup** - no searching for docs needed! This triggers our revolutionary agent-driven onboarding that gets you productive in 20 minutes.

📋 **[View Complete Setup Guide](GETTING_STARTED.md)** | 🤖 **[Agent Training Protocol](AGENT_ONBOARDING_PROTOCOL.md)**

---

## 🎯 What is The Lab?

The Lab is a comprehensive development workspace framework designed for rapid ideation, prototyping, and project incubation. It combines the power of AI tools (TaskMaster, Claude Code), structured organization, and automated workflows to accelerate development cycles by 30-50%.

## 🚀 Quick Setup

### Prerequisites
- **TaskMaster AI** - Project management and task tracking
- **Claude Code** - AI-powered code generation (optional but recommended)
- **Docker** - For containerized development
- **Azure CLI** - For cloud deployment (optional)
- **PowerShell** - For automation scripts (Windows) or PowerShell Core (cross-platform)

### Installation

1. **Clone this repository**:
   ```bash
   git clone [your-repo-url] my-lab
   cd my-lab
   ```

2. **Initialize your Lab workspace**:
   ```bash
   # Make scripts executable (if needed)
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   
   # Your Lab is ready!
   ```

3. **Set up TaskMaster** (if not already installed):
   ```bash
   # Follow TaskMaster installation guide
   # Configure your API keys and preferences
   ```

## 🏗️ Lab Structure

```
your-lab/
├── 📦 core-tools/        # Shared utilities & configurations
│   └── scripts/          # Automation scripts
├── 📚 docs-hub/          # Central knowledge base
│   └── templates/        # PRD templates & examples
├── 🚀 projects/          # Active development projects
│   └── 2025-01-[slug]/   # Date-named project folders
├── ⚗️ experiments/       # Quick prototypes & ideas (git-ignored)
├── 📁 archives/          # Completed/inactive projects (git-ignored)
└── 🔧 .cursor/          # Cursor IDE rules for automation
    └── rules/            # Workflow enforcement rules
```

## 🌊 The Lab Workflow

### 1. 💡 Ideation
```bash
# Capture ideas in TaskMaster
task-master add-task --prompt "Build customer portal with Azure backend"

# Research and document in docs-hub/
```

### 2. 🛠️ Project Creation
```bash
# Automated project setup
.\core-tools\scripts\new-project.ps1 -ProjectName "Customer Portal" -Template node

# Or manual setup
mkdir projects/2025-01-customer-portal
cd projects/2025-01-customer-portal
git init
```

### 3. 🔨 Development
```bash
# Use Docker for isolation
docker build -t customer-portal .
docker run -p 8000:8000 customer-portal

# Leverage AI assistance
claude code "implement user authentication with JWT"

# Update progress
task-master update-subtask --id [id] --prompt "Implemented JWT auth"
```

### 4. 🚢 Graduation
```bash
# Ready for production? Graduate to own repo
.\core-tools\scripts\lab-graduate.ps1 -ProjectSlug "2025-01-customer-portal" -NewRepoName "customer-portal-prod"
```

## 🔧 Available Scripts

### `new-project.ps1`
Creates a new project with proper structure and templates.

```bash
# Basic usage
.\core-tools\scripts\new-project.ps1 -ProjectName "My App"

# With template
.\core-tools\scripts\new-project.ps1 -ProjectName "API Service" -Template python

# Available templates: node, python, dotnet, static
```

### `lab-graduate.ps1`
Moves a project from Lab to its own repository.

```bash
# Graduate to production
.\core-tools\scripts\lab-graduate.ps1 -ProjectSlug "2025-01-my-app" -NewRepoName "my-app-production"

# Test run first
.\core-tools\scripts\lab-graduate.ps1 -ProjectSlug "2025-01-my-app" -NewRepoName "my-app-production" -DryRun
```

## 🎨 Customization

### Project Templates
Edit templates in `docs-hub/templates/` to match your team's standards:
- `project_readme_template.md` - Standard README format
- Add custom Dockerfiles for your tech stack
- Create PRD templates for your domain

### Cursor Rules
The Lab includes smart Cursor IDE rules in `.cursor/rules/`:
- **lab_workflow.mdc** - Enforces development cycle
- **project_naming.mdc** - Consistent project structure
- **docker_integration.mdc** - Azure-compatible containers
- **error_handling_and_recovery.mdc** - Graceful error handling

## 🐳 Docker Integration

Projects are Docker-ready by default with Azure-compatible base images:

```dockerfile
# Automatic generation for Node.js projects
FROM mcr.microsoft.com/appsvc/node:18-lts
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY src/ ./src/
EXPOSE 8000
CMD ["npm", "start"]
```

## 📊 Success Metrics

Teams using The Lab report:
- **30-50% faster development cycles**
- **Consistent code quality** via automated rules
- **Seamless deployment** to Azure
- **Better project organization**
- **Reduced context switching**

## 🤝 Team Collaboration

### Shared Standards
- All projects follow the same naming convention
- Docker containerization is standardized
- Documentation templates ensure consistency
- TaskMaster integration provides visibility

### Individual Workspaces
Each developer gets their own Lab instance:
- Personal experiments and prototypes
- Individual task tracking
- Custom configurations
- Independent project lifecycle

## 🔍 Troubleshooting

### Common Issues

**PowerShell Execution Policy**:
```bash
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Docker not found**:
```bash
# Install Docker Desktop or Docker Engine
# Verify: docker --version
```

**TaskMaster integration**:
```bash
# Ensure TaskMaster is properly configured
# Check API keys and connectivity
```

## 📚 Documentation

- **[The Lab README](docs-hub/THE_LAB_README.md)** - Complete workspace documentation
- **[Project Templates](docs-hub/templates/)** - Ready-to-use project templates
- **[Cursor Rules](.cursor/rules/)** - IDE automation configuration

## 🚀 What's Next?

1. **Create your first project** using the scripts
2. **Customize templates** for your tech stack
3. **Set up TaskMaster integration** for AI project management
4. **Scale across your team** with consistent workflows

## 🎭 Advanced Features

### AI Integration
- **TaskMaster** for intelligent project management
- **Claude Code** for AI-powered development
- **Automated workflow enforcement** via Cursor rules

### Azure Ready
- **Container Apps** deployment templates
- **Azure CLI** integration patterns
- **Microsoft base images** for compatibility

### Extensible Framework
- **Custom templates** for any tech stack
- **Modular scripts** for team-specific needs
- **Plugin architecture** for additional tools

---

## 🎉 Welcome to The Lab!

Transform your development process and build amazing things faster than ever before.

**Happy coding!** 🧪✨

---

*The Lab: Where ideas become reality through structured innovation*

### Support & Community
- Report issues via GitHub Issues
- Share improvements via Pull Requests
- Join our development community discussions 
