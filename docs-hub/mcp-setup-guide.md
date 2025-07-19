# 🔌 MCP (Model Context Protocol) Setup Guide

> Transform your Cursor development with AI-powered automation through MCP servers

## 📚 Table of Contents

1. [What are MCPs?](#what-are-mcps)
2. [Prerequisites](#prerequisites)
3. [Core MCP Setup](#core-mcp-setup)
4. [Individual MCP Configuration](#individual-mcp-configuration)
5. [Testing & Validation](#testing--validation)
6. [Troubleshooting](#troubleshooting)
7. [Advanced Configuration](#advanced-configuration)


Model Context Protocol servers extend Cursor's capabilities by providing direct access to:
- **File systems** - Read/write files without leaving chat
- **Terminal commands** - Execute CLI commands naturally
- **Web services** - Browse, search, and interact with APIs
- **Documentation** - Access library docs in real-time
- **Version control** - Manage Git operations seamlessly

## Prerequisites

Before setting up MCPs, ensure you have:

- ✅ **Cursor** v0.36+ installed
- ✅ **Node.js** v18+ (for npm packages)
- ✅ **Git** installed and configured
- ✅ **API Keys** ready (see requirements below)

## Core MCP Setup

### Step 1: Locate Your Cursor Config Directory

```bash
# Windows
%APPDATA%\Cursor\User\globalStorage\cursor.mcp-servers

# macOS
~/Library/Application Support/Cursor/User/globalStorage/cursor.mcp-servers

# Linux
~/.config/Cursor/User/globalStorage/cursor.mcp-servers
```

### Step 2: Create MCP Configuration File

Create `mcp.json` in the directory above:

```json
{
  "mcpServers": {
    "taskmaster": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-taskmaster"],
      "env": {
        "ANTHROPIC_API_KEY": "your-anthropic-key",
        "PERPLEXITY_API_KEY": "your-perplexity-key",
        "OPENAI_API_KEY": "your-openai-key"
      }
    },
    "desktop-commander": {
      "command": "npx",
      "args": ["-y", "@pierreg/server-desktop-commander"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"],
      "env": {
        "CONTEXT7_API_KEY": "optional-api-key"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-github-pat"
      }
    },
    "browserbase": {
      "command": "npx",
      "args": ["-y", "@browserbase/mcp-browserbase"],
      "env": {
        "BROWSERBASE_API_KEY": "your-browserbase-key"
      }
    },
    "docker-memory": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "mcp_docker_memory:/data", "ghcr.io/ckreiling/mcp-memory-service:latest"]
    }
  }
}
```

### Step 3: Restart Cursor

After saving `mcp.json`, completely restart Cursor for changes to take effect.

## Individual MCP Configuration

### 🎯 **1. TaskMaster MCP** (CRITICAL)

**Purpose**: AI-powered project management and task tracking

**Setup**:
```bash
# Install globally for CLI access
npm install -g @modelcontextprotocol/server-taskmaster

# Test installation
task-master --version
```

**Configuration**:
- **ANTHROPIC_API_KEY**: Required for main AI model
- **PERPLEXITY_API_KEY**: Recommended for research mode
- **OPENAI_API_KEY**: Optional fallback model

**Verification**:
```bash
# In Cursor chat
"Initialize TaskMaster in this project"
# Should create .taskmaster/ directory
```

### 💻 **2. Desktop Commander MCP** (CRITICAL)

**Purpose**: Execute terminal commands directly from Cursor chat

**Setup**:
- No additional configuration required
- Works immediately after adding to mcp.json

**Usage Examples**:
```bash
# In Cursor chat
"List all files in the current directory"
"Create a new file called test.js"
"Run npm install"
```

**Security Note**: Desktop Commander has full system access. Use with caution.

### 📖 **3. Context7 MCP** (HIGH)

**Purpose**: Real-time documentation lookup for libraries and frameworks

**Setup**:
- Optional API key for enhanced features
- Free tier available without key

**Usage**:
```bash
# In chat with --c7 flag
"--c7 react hooks"
"--c7 express middleware"
```

### 🐙 **4. GitHub MCP** (HIGH)

**Purpose**: Repository management, PR creation, issue tracking

**Setup**:
1. Create a GitHub Personal Access Token:
   - Go to GitHub Settings → Developer Settings → Personal Access Tokens
   - Create token with repo, workflow, and read:org permissions
2. Add token to mcp.json

**Usage**:
```bash
# In Cursor chat
"Create a new issue titled 'Bug in authentication'"
"Show me recent pull requests"
"Create a PR for the current branch"
```

### 🌐 **5. BrowserBase MCP** (MEDIUM)

**Purpose**: Web automation, testing, and research

**Setup**:
1. Sign up at [browserbase.com](https://browserbase.com)
2. Get API key from dashboard
3. Add to mcp.json

**Usage**:
```bash
# In Cursor chat
"Search for React 19 new features"
"Test the login flow on staging.example.com"
```

### 🧠 **6. Docker Memory MCP** (MEDIUM)

**Purpose**: Persistent memory across sessions

**Prerequisites**:
- Docker installed and running
- Docker daemon accessible

**Setup**:
```bash
# Create volume (one-time)
docker volume create mcp_docker_memory
```

**Usage**:
```bash
# In Cursor chat
"Remember that the API endpoint is https://api.example.com/v2"
"What was the API endpoint we discussed?"
```

### 🎭 **7. Stagehand MCP** (MEDIUM)

**Purpose**: Browser automation with AI-powered element detection

**Setup**:
```bash
# Install via npm
npm install -g @browserbase/stagehand

# Or add to mcp.json:
"stagehand": {
  "command": "npx",
  "args": ["-y", "@browserbase/stagehand"],
  "env": {
    "BROWSERBASE_API_KEY": "your-browserbase-key",
    "BROWSERBASE_PROJECT_ID": "your-project-id"
  }
}
```

**Features**:
- Natural language element selection
- Visual debugging with screenshots
- Resilient to DOM changes
- Works with dynamic content

**Usage**:
```javascript
// In Cursor chat
"Navigate to the login page and fill in the credentials"
"Click the 'Submit Order' button"
"Extract all product prices from the page"
```

**Integration with BrowserBase**:
- Stagehand can use BrowserBase for cloud browsers
- Or run locally with Playwright
- Automatic retry on failures
- Screenshot debugging

### ☁️ **Azure CLI** (IMPORTANT - Not MCP)

**Purpose**: Cloud infrastructure management for Azure ecosystem

**Installation**:

#### Windows (PowerShell)
```powershell
# Download and run the MSI installer
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# Or use winget
winget install -e --id Microsoft.AzureCLI

# Verify installation
az --version
```

#### macOS
```bash
# Using Homebrew
brew update && brew install azure-cli

# Verify installation
az --version
```

#### Linux
```bash
# One-line install
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Verify installation
az --version
```

**Initial Setup**:
```bash
# Login to Azure
az login

# Set default subscription
az account list --output table
az account set --subscription "Your-Subscription-Name"

# Configure defaults
az configure --defaults group=YourResourceGroup location=eastus
```

**Common Commands for Lab Projects**:
```bash
# App Service Deployment
az webapp create --name myapp --plan myplan --runtime "NODE:18-lts"
az webapp deployment source config --name myapp --repo-url https://github.com/user/repo

# Container Instances
az container create --name mycontainer --image myimage:latest --dns-name-label myapp

# Storage Account
az storage account create --name mystorageaccount --sku Standard_LRS

# Key Vault for Secrets
az keyvault create --name myvault --location eastus
az keyvault secret set --vault-name myvault --name "api-key" --value "secret-value"
```

**Integration with Lab Workflow**:
1. **Project Deployment**: Use Azure CLI in deployment scripts
2. **Secret Management**: Store API keys in Key Vault
3. **Container Registry**: Push Docker images to ACR
4. **CI/CD**: Integrate with GitHub Actions

**Best Practices**:
- Store Azure configurations in `azure/` directory
- Use ARM templates or Bicep for infrastructure as code
- Tag all resources with project name: `az resource tag --tags project=lab-experiment`
- Use managed identities where possible

**Cost Management**:
```bash
# Check current costs
az consumption usage list --output table

# Set spending limits
az consumption budget create --amount 100 --name MyBudget
```

## Testing & Validation

### Quick Test Suite

Run these commands in Cursor chat to verify each MCP:

```bash
# 1. TaskMaster
"Show TaskMaster status"

# 2. Desktop Commander  
"Run echo 'MCP Test Success'"

# 3. Context7
"--c7 typescript interfaces"

# 4. GitHub
"List my GitHub repositories"

# 5. BrowserBase
"Navigate to example.com and take a screenshot"

# 6. Docker Memory
"Remember this test: MCP setup complete"
```

### Expected Results

✅ Each command should execute without errors
✅ You should see appropriate responses
✅ No "MCP server not found" errors

## Troubleshooting

### Common Issues

#### 1. "MCP server not found"
- Ensure mcp.json is in the correct directory
- Restart Cursor completely (not just reload)
- Check for typos in server names

#### 2. API Key Errors
- Verify keys are correctly quoted in mcp.json
- Check key permissions on provider dashboards
- Ensure no extra spaces in keys

#### 3. Docker Memory Not Working
- Verify Docker is running: `docker ps`
- Check volume exists: `docker volume ls`
- Ensure Docker socket is accessible

#### 4. Commands Not Executing
- Check Node.js is in PATH
- Verify npx works: `npx --version`
- Look for errors in Cursor DevTools (Cmd+Shift+I)

### Debug Mode

Enable MCP debug logging:

```json
{
  "mcpServers": {
    "taskmaster": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-taskmaster"],
      "env": {
        "DEBUG": "mcp:*",
        // ... other env vars
      }
    }
  }
}
```

## Advanced Configuration

### Custom MCP Servers

Add your own MCP servers:

```json
{
  "mcpServers": {
    "my-custom-server": {
      "command": "node",
      "args": ["/path/to/your/server.js"],
      "env": {
        "CUSTOM_CONFIG": "value"
      }
    }
  }
}
```

### Environment-Specific Config

Use different configs for different projects:

```bash
# In project .cursor/mcp.json (overrides global)
{
  "mcpServers": {
    "project-specific-mcp": {
      // ... configuration
    }
  }
}
```

### Performance Optimization

For better performance:

1. **Limit Active MCPs**: Only enable what you need
2. **Local Caching**: Some MCPs support caching
3. **Batch Operations**: Group related commands

## 🎯 Next Steps

1. **Complete Basic Setup**: Get TaskMaster and Desktop Commander working first
2. **Add Enhancement MCPs**: Context7 and GitHub for better workflows
3. **Experiment with Advanced**: BrowserBase and Docker Memory as needed
4. **Customize**: Add project-specific MCPs

## 📚 Resources

- [MCP Official Docs](https://modelcontextprotocol.io)
- [Cursor MCP Integration](https://cursor.sh/mcp)
- [TaskMaster Documentation](https://github.com/modelcontextprotocol/server-taskmaster)
- [Community MCP Servers](https://github.com/modelcontextprotocol/servers)

---

*Remember: MCPs are the backbone of The Lab's 30-50% productivity gains. Take time to set them up correctly!* 