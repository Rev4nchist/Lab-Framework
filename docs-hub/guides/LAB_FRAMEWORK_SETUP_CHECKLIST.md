# Lab Framework Setup Checklist

## 🚨 CRITICAL FIRST STEP
**Install Desktop Commander MCP FIRST** - This gives the AI agent observability and capabilities to guide you through the rest of setup more effectively.
- Package: `@pierreg/server-desktop-commander`
- Why: Enables the agent to see your screen, take screenshots, and provide visual guidance during setup

## Pre-Installation Requirements

### 1. Core Software to Install
- [ ] **Node.js** (version 18 or higher) - https://nodejs.org/
- [ ] **Git** - https://git-scm.com/
- [ ] **PowerShell** 5.1+ (Windows) or PowerShell Core (Mac/Linux) - https://github.com/PowerShell/PowerShell
- [ ] **Claude Code CLI** - Get from https://claude.ai/code

### 2. Recommended Development Tools (install at least one)
- [ ] **Cursor IDE** (primary recommendation) - https://cursor.sh/
- [ ] VS Code - https://code.visualstudio.com/
- [ ] Windsurf - https://codeium.com/windsurf
- [ ] JetBrains IDE (IntelliJ/PyCharm/WebStorm) - https://www.jetbrains.com/

### 3. Optional Tools
- [ ] **Docker Desktop** - https://www.docker.com/products/docker-desktop/
- [ ] **Azure CLI** (for cloud deployment) - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

## API Keys & Accounts to Obtain

### Essential AI Model API (get at least ONE)
- [ ] **Anthropic API Key** (RECOMMENDED) - https://console.anthropic.com/
  - Key name: `ANTHROPIC_API_KEY`
- [ ] **Perplexity API Key** (HIGHLY RECOMMENDED for research) - https://www.perplexity.ai/settings/api
  - Key name: `PERPLEXITY_API_KEY`
- [ ] **OpenAI API Key** (fallback option) - https://platform.openai.com/api-keys
  - Key name: `OPENAI_API_KEY`

### Integration Services
- [ ] **GitHub Personal Access Token** - https://github.com/settings/tokens
  - Key name: `GITHUB_PERSONAL_ACCESS_TOKEN`
  - Required scopes: repo, workflow, read:org
- [ ] **Browserbase Account** (for web automation) - https://browserbase.com/
  - Key name: `BROWSERBASE_API_KEY`
  - Project ID: `BROWSERBASE_PROJECT_ID`
- [ ] **Context7 API Key** (for documentation lookup) - https://context7.io/
  - Key name: `CONTEXT7_API_KEY`

### Optional Services
- [ ] **ElevenLabs API Key** (for voice synthesis) - https://elevenlabs.io/
  - Key name: `ELEVENLABS_API_KEY`
- [ ] **Azure Account** (for cloud deployment) - https://azure.microsoft.com/
  - Required: `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`, `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`

## Critical MCP Servers for Development Workflow

These MCP servers are essential for the Lab Framework development cycle:

### 1. **Desktop Commander** (INSTALL FIRST)
- Package: `@pierreg/server-desktop-commander`
- Purpose: Provides AI agent with desktop observability - screenshots, file navigation, visual guidance
- Requirements: No API key needed
- Why Critical: Enables autonomous environment setup and visual debugging

### 2. **Task Master AI** 
- Package: `task-master-ai`
- Purpose: Project management, task tracking, and workflow orchestration
- Requirements: Uses your AI model API keys (Anthropic/OpenAI/Perplexity)
- Why Critical: Core workflow tool for task decomposition and progress tracking

### 3. **Browserbase/Stagehand**
- Packages: `@browserbasehq/mcp-browserbase` & `@browserbasehq/stagehand`
- Purpose: Web automation, testing, and browser-based interactions
- Requirements: `BROWSERBASE_API_KEY` and `BROWSERBASE_PROJECT_ID`
- Why Critical: Essential for web development testing and automation

### 4. **Context7** 
- Package: `@context7/mcp-server`
- Purpose: Documentation lookup and library reference
- Requirements: `CONTEXT7_API_KEY`
- Why Critical: Provides accurate, up-to-date documentation for development

## Setup Process

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Rev4nchist/Lab-Framework.git
   cd Lab-Framework
   ```

2. **Run Setup Wizard**
   ```powershell
   ./the-lab-framework/core-tools/scripts/setup-wizard.ps1
   ```

3. **Configure Environment**
   - [ ] Copy `.env.example` to `.env`
   - [ ] Add all your API keys to `.env`
   - [ ] Copy `.cursor/mcp.json.example` to `.cursor/mcp.json`
   - [ ] Update MCP configuration with your API keys

4. **Validate Setup**
   ```powershell
   ./the-lab-framework/core-tools/scripts/validate-setup.ps1
   ```

5. **Test MCP Servers**
   ```powershell
   ./the-lab-framework/core-tools/scripts/test-mcp-servers.ps1
   ```

## Configuration Values to Set

- [ ] `CLAUDE_HOME` - Your SuperClaude installation directory
- [ ] `LAB_ROOT` - Your Lab workspace root directory
- [ ] `LAB_AUTHOR` - Your name for project authorship
- [ ] Git configuration (name and email)

## Quick Reference Links

- **Lab Framework Repo**: https://github.com/Rev4nchist/Lab-Framework
- **Claude Code**: https://claude.ai/code
- **Anthropic Console**: https://console.anthropic.com/
- **Perplexity API**: https://www.perplexity.ai/settings/api
- **GitHub Tokens**: https://github.com/settings/tokens
- **Browserbase**: https://browserbase.com/
- **Context7**: https://context7.io/

## Support & Troubleshooting

- Check the repository's documentation in `/the-lab-framework/docs-hub/`
- Use the validation script to identify missing components
- The Desktop Commander MCP will help the AI agent guide you visually through any issues

---

**Remember**: Install Desktop Commander MCP first for the best setup experience! The AI agent can then provide visual guidance throughout the rest of the process.