# 🧪 The Lab - Your AI-Powered Development Workspace

> Where ideas become reality through structured innovation

## What is The Lab?

The Lab is your comprehensive development workspace designed for rapid ideation, prototyping, and project incubation. It combines the power of TaskMaster AI, Claude Code, Azure CLI, and Docker to create a seamless development experience from concept to production.

## 🏗️ Structure Overview

```
the-lab/
├── 📦 core-tools/        # Shared utilities & configurations
│   ├── scripts/          # Automation scripts
│   ├── taskmaster/       # TaskMaster configurations
│   └── mcp-configs/      # MCP integration configs
├── 📚 docs-hub/          # Central knowledge base
│   ├── templates/        # PRD templates & examples
│   ├── guides/           # Development guides
│   └── documentation/    # Migrated docs from previous structure
├── 🚀 projects/          # Active development projects
│   └── 2025-01-[slug]/   # Date-named project folders
├── ⚗️ experiments/       # Quick prototypes & ideas
├── 📁 archives/          # Completed/inactive projects
├── 🔧 rules-engine/      # Cursor rules for automation
├── 🧪 tests/             # Global test utilities
├── 📊 static/            # Static assets
└── 🧠 eve-memory-system/ # AI memory integration
```

## 🌊 The Lab Workflow

### 1. 💡 Ideation
- Capture ideas in TaskMaster: `task-master add-task --prompt "Build [idea]"`
- Create PRD using templates in `docs-hub/templates/`
- Research with MCPs and document in `docs-hub/`

### 2. 🛠️ Incubation  
- Create project folder: `projects/2025-01-[project-slug]/`
- Initialize with: README, src/, tests/, Dockerfile
- Set up git tracking: `git init` in project folder
- Tag in TaskMaster: `task-master use-tag "[project-slug]"`

### 3. 🔨 Development
- Use Docker for isolation: `docker build -t [slug] .`
- Leverage Claude Code: `claude code "implement [feature]"`
- Apply Azure CLI patterns from `core-tools/`
- Update progress: `task-master update-subtask --id [id] --prompt "[notes]"`

### 4. 🚢 Graduation
- Ready for production? Run `core-tools/scripts/lab-graduate.ps1`
- Create GitHub repo via MCP
- Archive original in `archives/`

## 🎯 Quick Start

### Starting a New Project
```bash
# 1. Add to TaskMaster
task-master add-task --prompt "Build inventory management system"

# 2. Create project structure
mkdir projects/2025-01-inventory-system
cd projects/2025-01-inventory-system

# 3. Initialize
echo "# Inventory System" > README.md
mkdir src tests docs
git init

# 4. Set up Docker
echo "FROM mcr.microsoft.com/appsvc/node:18-lts" > Dockerfile

# 5. Tag in TaskMaster
task-master use-tag "inventory-system"
```

### Using Experiments for Quick Ideas
```bash
# For throwaway prototypes
mkdir experiments/ai-chat-test
cd experiments/ai-chat-test
# Develop rapidly without formal structure
```

## 🔧 Core Tools Integration

### TaskMaster AI
- **Purpose**: Project management and task tracking
- **Config**: `core-tools/taskmaster/`
- **Usage**: Follow rules in `rules-engine/lab_workflow.mdc`

### Claude Code
- **Purpose**: AI-powered code generation
- **Integration**: Available via `claude` command
- **Best Practice**: Use with structured prompts

### Docker Integration
- **Purpose**: Containerized development
- **Templates**: Available in `rules-engine/docker_integration.mdc`
- **Azure Ready**: Uses Microsoft base images

### Azure CLI
- **Purpose**: Cloud infrastructure management
- **Patterns**: Documented in existing guides
- **Integration**: Seamless deployment from containers

## 📚 Documentation Hub

### Templates Available
- `example_prd.txt` - Product Requirements Document template
- `project_readme_template.md` - Standard project README
- `docker_templates/` - Various Dockerfile examples

### Guides & References
- Development workflow examples
- Azure deployment patterns
- Best practices for each technology stack
- Troubleshooting common issues

## 🧠 Memory System Integration

The Lab integrates with EVE memory system for:
- **Knowledge Retention**: Store learnings across projects
- **Pattern Recognition**: Identify reusable solutions
- **Decision Tracking**: Remember why choices were made
- **Cross-Project Insights**: Connect ideas between projects

## 🚨 Rules & Automation

The Lab uses Cursor rules for automation:
- **lab_workflow.mdc**: Core development cycle
- **project_naming.mdc**: Consistent project structure
- **docker_integration.mdc**: Containerization standards
- **error_handling_and_recovery.mdc**: Graceful error handling

## 🎯 Success Metrics

- **Speed**: 30-50% faster development cycles
- **Quality**: Consistent code standards via rules
- **Knowledge**: Persistent learning across projects
- **Deployment**: Seamless Azure integration
- **Organization**: Clear project lifecycle management

## 🚀 Next Steps

1. **Explore**: Check out `projects/` for active work
2. **Learn**: Read guides in `docs-hub/documentation/`
3. **Create**: Start your first project using the workflow above
4. **Automate**: Leverage rules and scripts for efficiency

---

*The Lab: Where your ideas get the structure they deserve.* 🧪✨ 