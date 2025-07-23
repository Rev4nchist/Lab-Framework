# 🧪 The Lab - Requirements & Dependencies

## 🔧 Core Requirements

### Essential Tools

#### 1. **PowerShell** (Required)
- **Windows**: PowerShell 5.1+ (built-in) or PowerShell Core 7.0+
- **macOS/Linux**: PowerShell Core 7.0+
- **Purpose**: Runs automation scripts (new-project.ps1, lab-graduate.ps1)
- **Installation**: [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)

#### 2. **Git** (Required)
- **Version**: 2.25.0 or higher
- **Purpose**: Version control, project initialization, repository management
- **Installation**: [Git Downloads](https://git-scm.com/downloads)

#### 3. **Docker** (Highly Recommended)
- **Version**: Docker Desktop 4.0+ or Docker Engine 20.10+
- **Purpose**: Containerized development, Azure-ready deployments
- **Installation**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### AI-Powered Development Stack

#### 4. **TaskMaster AI** (Recommended)
- **Purpose**: AI-powered project management and task tracking
- **Integration**: Core Lab workflow automation
- **Setup**: Configure API keys for full integration
- **Alternative**: Manual task management (reduced efficiency)

#### 5. **Claude Code** (Optional but Powerful)
- **Purpose**: AI-powered code generation and assistance
- **Integration**: Works seamlessly with Lab workflow
- **Setup**: Available via command line or IDE integration

### IDE & Extensions

#### 6. **Cursor IDE** (Recommended)
- **Purpose**: AI-powered development environment
- **Integration**: Automatic rule enforcement via `.cursor/rules/`
- **Features**: Built-in AI assistance, workflow automation
- **Alternative**: VS Code with similar extensions

#### 7. **VS Code** (Alternative)
- **Extensions Needed**:
  - Docker extension
  - PowerShell extension
  - GitLens
  - Azure Account (for Azure integration)

## ☁️ Cloud & Deployment

#### 8. **Azure CLI** (Optional)
- **Version**: 2.40.0 or higher
- **Purpose**: Azure deployment and management
- **Installation**: [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- **Configuration**: `az login` for authentication

#### 9. **Azure Account** (Optional)
- **Purpose**: Cloud deployment target
- **Services Used**: Container Apps, Container Registry, App Service
- **Setup**: Create Azure subscription for team deployment

## 📦 MCP Integrations

### Available MCPs for Enhanced Functionality

#### **TaskMaster MCP** (Core Integration)
- **Purpose**: Project management automation
- **Features**: Task creation, progress tracking, AI assistance
- **Configuration**: API keys and server setup required

#### **GitHub MCP** (Recommended)
- **Purpose**: Repository management and automation
- **Features**: Repo creation, issue tracking, pull request management
- **Setup**: GitHub token configuration

#### **Context7 MCP** (Documentation)
- **Purpose**: Library documentation and reference
- **Features**: Up-to-date API documentation, code examples
- **Usage**: Research and implementation assistance

#### **BrowserBase MCP** (Research)
- **Purpose**: Web research and best practices lookup
- **Features**: Real-time information gathering
- **Usage**: Technology research and troubleshooting

#### **Docker Memory MCP** (Optional)
- **Purpose**: Persistent knowledge management
- **Features**: Cross-session memory and learning
- **Setup**: Docker container for memory persistence

## 🚀 Platform-Specific Setup

### Windows Users
```powershell
# Verify PowerShell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install Chocolatey (optional, for easy tool management)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools via Chocolatey
choco install git docker-desktop powershell-core azure-cli
```

### macOS Users
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install git docker powershell azure-cli

# Start Docker Desktop
open /Applications/Docker.app
```

### Linux Users
```bash
# Install PowerShell (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y wget apt-transport-https software-properties-common
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell

# Install Docker
sudo apt-get install docker.io docker-compose

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

## ✅ Quick Verification

### Test Your Environment
```bash
# Check all required tools
git --version                    # Should show Git version
docker --version                 # Should show Docker version
pwsh --version                   # Should show PowerShell version
az --version                     # Should show Azure CLI version (if installed)

# Test Docker
docker run hello-world           # Should complete successfully

# Test PowerShell script execution
pwsh -Command "Write-Host 'PowerShell is working!'"
```

### Test Lab Framework
```bash
# After cloning The Lab repository
.\core-tools\scripts\new-project.ps1 -ProjectName "Test" -Template node -DryRun

# Should show project creation plan without errors
```

## 🎯 Recommended Setup Order

1. **Install Git** - Required for cloning and project management
2. **Install PowerShell** - Required for automation scripts
3. **Install Docker** - Recommended for containerized development
4. **Clone The Lab** - Get the framework repository
5. **Test basic functionality** - Verify scripts work
6. **Install TaskMaster** - Set up AI project management
7. **Configure Azure CLI** - If using Azure deployment
8. **Set up MCPs** - Add additional integrations as needed

## 🔒 Security Considerations

### API Key Management
- Store API keys in environment variables
- Use `.env.local` files (git-ignored)
- Never commit secrets to repositories
- Rotate keys regularly

### Docker Security
- Use official Microsoft base images
- Keep containers updated
- Scan images for vulnerabilities
- Use non-root users in containers

### Azure Security
- Use Azure Key Vault for secrets
- Implement proper RBAC
- Enable security monitoring
- Follow Azure security best practices

## 📊 Performance Optimization

### Development Machine
- **RAM**: 16GB+ recommended for Docker development
- **Storage**: SSD recommended for fast container builds
- **CPU**: 4+ cores for smooth container operations

### Network Requirements
- **Internet**: Required for Docker image pulls, Azure operations
- **Bandwidth**: Higher bandwidth improves container build times
- **VPN**: Ensure corporate VPN doesn't block Docker/Azure traffic

## 🛠️ Troubleshooting

### Common Issues
- **PowerShell execution policy**: See platform-specific setup
- **Docker permissions**: Ensure user is in docker group (Linux)
- **Azure authentication**: Run `az login` for proper setup
- **Git authentication**: Configure SSH keys or personal access tokens

### Getting Help
- Check main [README.md](README.md) for framework documentation
- Review [SETUP.md](SETUP.md) for step-by-step instructions
- Consult your team's specific configuration guides
- Reach out to team leads for organization-specific setup

---

## 🎉 Ready to Build!

Once you have these requirements met, you'll have a complete AI-powered development environment that delivers 30-50% faster development cycles!

**Welcome to The Lab!** 🧪✨

---

*Requirements Documentation Date: January 6, 2025*  
*Framework Version: 1.0.0* ✅ 