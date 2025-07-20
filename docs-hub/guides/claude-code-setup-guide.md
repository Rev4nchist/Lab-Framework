# 🤖 Claude Code + IDE Integration Guide

> Complete setup guide for Claude Code CLI and IDE integration in The Lab Framework

## 🎯 Overview

Claude Code transforms your development experience by providing AI-powered coding assistance directly within your IDE. This guide covers complete setup, integration, and optimization for maximum productivity.

### What You'll Get
- **AI-powered code generation** directly in your IDE
- **Quick launch shortcuts** (Ctrl+Esc / Cmd+Esc)
- **Seamless diff viewing** within your editor
- **File reference shortcuts** for context sharing
- **Integrated terminal support** for smooth workflows

---

## 🚀 Quick Setup (Automated)

**Recommended Path**: Use our automated setup script

```powershell
# Run the automated Claude Code + IDE integration setup
.\core-tools\scripts\setup-claude-ide.ps1

# Or specify your IDE explicitly  
.\core-tools\scripts\setup-claude-ide.ps1 -IDE "Cursor"

# Test existing setup
.\core-tools\scripts\setup-claude-ide.ps1 -TestMode
```

The script will:
1. ✅ Validate Claude Code CLI installation
2. 🔍 Auto-detect your IDE (VS Code, Cursor, Windsurf, JetBrains)
3. 🔧 Guide through extension installation
4. ⚡ Test integration features
5. 🎛️ Optimize configuration settings

---

## 📋 Manual Setup Guide

### Step 1: Install Claude Code CLI

Choose your installation method:

#### Windows
```powershell
# Option 1: winget (recommended)
winget install Anthropic.Claude

# Option 2: Chocolatey
choco install claude-cli

# Option 3: Direct download
# Visit: https://claude.ai/download
```

#### macOS
```bash
# Option 1: Homebrew (recommended)
brew install claude

# Option 2: Direct download
# Visit: https://claude.ai/download
```

#### Linux
```bash
# Direct download and install
# Visit: https://claude.ai/download
```

### Step 2: Verify Installation

```bash
# Test Claude Code CLI
claude --version

# Should output something like: claude 1.x.x
```

### Step 3: IDE-Specific Setup

#### VS Code / Cursor / Windsurf

1. **Install CLI Command** (if not available):
   - VS Code: `Cmd/Ctrl+Shift+P` → "Shell Command: Install 'code' command in PATH"
   - Cursor: Should be available after installation
   - Windsurf: Should be available after installation

2. **Install Extension**:
   ```bash
   # Open your IDE and run in integrated terminal:
   claude
   
   # Extension will auto-install on first run
   ```

3. **Test Integration**:
   - Use shortcut: `Ctrl+Esc` (Windows/Linux) or `Cmd+Esc` (Mac)
   - Try file references: `Ctrl+Alt+K` (Windows/Linux) or `Cmd+Option+K` (Mac)

#### JetBrains IDEs (IntelliJ, PyCharm, WebStorm, etc.)

1. **Install JetBrains CLI** (if not available):
   - Open JetBrains Toolbox
   - Settings → Generate shell scripts
   - Ensure CLI commands are in PATH

2. **Install Plugin**:
   ```bash
   # Navigate to project root in terminal
   cd /path/to/your/project
   
   # Run Claude from project directory
   claude
   
   # Plugin will auto-install
   ```

3. **Enable Plugin**:
   - Restart IDE completely (sometimes multiple times)
   - Go to Settings → Plugins
   - Ensure "Claude Code" plugin is enabled
   - Restart again if needed

4. **Test Integration**:
   - Use platform-specific shortcuts
   - Test via Tools menu or search actions

---

## ⚙️ Configuration & Optimization

### Claude Code Configuration

Run the configuration wizard:
```bash
claude
# In Claude, run:
/config
```

**Recommended Settings**:
- **Diff tool**: Set to "auto" (for IDE integration)
- **Memory**: Adjust based on your system (4GB+ recommended)
- **Auto-save**: Enable in your IDE for better sync

### IDE-Specific Optimizations

#### VS Code Family (VS Code, Cursor, Windsurf)
```json
// settings.json additions
{
  "claude.autoSave": true,
  "claude.diffInEditor": true,
  "claude.enableShortcuts": true,
  "files.autoSave": "onWindowChange",
  "editor.bracketPairColorization.enabled": true
}
```

#### JetBrains IDEs
- Enable "Auto-import" in Settings
- Configure "File Watchers" for better sync
- Set up keyboard shortcuts in Keymap settings
- Enable "Bracket matching" for better code navigation

---

## 🎨 IDE Integration Features

### Quick Launch Shortcuts
| IDE Family | Shortcut | Action |
|------------|----------|---------|
| VS Code/Cursor/Windsurf | `Ctrl+Esc` (Win/Linux)<br>`Cmd+Esc` (Mac) | Launch Claude |
| JetBrains | Platform specific | Via Tools menu or custom keymap |

### File Reference Shortcuts
| IDE Family | Shortcut | Action |
|------------|----------|---------|
| VS Code/Cursor/Windsurf | `Ctrl+Alt+K` (Win/Linux)<br>`Cmd+Option+K` (Mac) | Reference file |
| JetBrains | Custom keymap | Configure in settings |

### Diff Viewing
- **VS Code Family**: Diffs appear in side-by-side editor tabs
- **JetBrains**: Integrated diff viewer with syntax highlighting
- **Terminal Fallback**: Available if IDE integration fails

### Selection Context Sharing
- Select code in your IDE
- Launch Claude with shortcut
- Selection automatically included as context
- Perfect for targeted code assistance

---

## 🧪 Testing Your Setup

### Automated Testing

```powershell
# Run comprehensive integration test
.\core-tools\scripts\setup-claude-ide.ps1 -TestMode

# Validate overall Lab setup including Claude Code
.\core-tools\scripts\validate-setup.ps1
```

### Manual Testing Checklist

**✅ Basic Functionality**
- [ ] `claude --version` works in terminal
- [ ] IDE opens when launching from terminal
- [ ] Integrated terminal available in IDE

**✅ Extension/Plugin**
- [ ] Claude Code extension/plugin installed
- [ ] Extension appears in extensions list
- [ ] No error messages in IDE console

**✅ Integration Features**
- [ ] Quick launch shortcut works (`Ctrl/Cmd+Esc`)
- [ ] File reference shortcut works (`Ctrl+Alt+K` / `Cmd+Option+K`)
- [ ] Selection context sharing works
- [ ] Diff viewing appears in IDE (not terminal)
- [ ] Claude remembers conversation history

**✅ Configuration**
- [ ] `/config` command works in Claude
- [ ] Diff tool set to "auto"
- [ ] Memory allocation appropriate
- [ ] IDE-specific settings optimized

---

## 🔧 Troubleshooting

### Common Issues & Solutions

#### ❌ Claude Code CLI Not Found
**Symptoms**: `claude: command not found`

**Solutions**:
1. **Verify Installation**:
   ```bash
   # Check if Claude is in PATH
   which claude    # macOS/Linux
   where claude    # Windows
   ```

2. **Reinstall**:
   - Uninstall current version
   - Download latest from https://claude.ai/download
   - Restart terminal/IDE after installation

3. **PATH Issues**:
   ```bash
   # Add to PATH manually (adjust path as needed)
   export PATH="$PATH:/path/to/claude"  # macOS/Linux
   # Or add via System Properties → Environment Variables (Windows)
   ```

#### ❌ IDE Extension Not Installing

**VS Code/Cursor/Windsurf**:
1. **CLI Command Missing**:
   - Install CLI command: `Cmd/Ctrl+Shift+P` → "Shell Command: Install 'code' command in PATH"
   - Restart terminal and try again

2. **Permission Issues**:
   ```bash
   # Check permissions for extensions directory
   ls -la ~/.vscode/extensions/     # macOS/Linux
   # Or check %USERPROFILE%\.vscode\extensions\ (Windows)
   ```

3. **Manual Installation**:
   - Visit VS Code Marketplace: https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code
   - Install manually through IDE extensions view

**JetBrains IDEs**:
1. **Must Run from Project Root**:
   ```bash
   # Ensure you're in project directory
   cd /path/to/your/project
   claude
   ```

2. **Complete IDE Restart Required**:
   - Close IDE completely
   - Restart (sometimes need 2-3 restarts)
   - Check Settings → Plugins

3. **Plugin Not Enabled**:
   - Go to Settings → Plugins
   - Search for "Claude"
   - Enable manually if disabled
   - Restart IDE

#### ❌ Shortcuts Not Working

1. **Keyboard Shortcut Conflicts**:
   - Check IDE keymap settings
   - Look for conflicting shortcuts
   - Reassign if needed

2. **Extension Not Active**:
   - Verify extension is installed and enabled
   - Check IDE status bar for Claude indicators
   - Restart IDE if needed

3. **Try Alternative Methods**:
   - Use Command Palette: `Cmd/Ctrl+Shift+P` → "Claude"
   - Use Tools menu (JetBrains)
   - Run `claude` in integrated terminal

#### ❌ Diff Not Showing in IDE

1. **Configuration Issue**:
   ```bash
   claude
   # In Claude:
   /config
   # Set diff tool to "auto"
   ```

2. **IDE Settings**:
   - Ensure diff viewing is enabled in IDE settings
   - Check file associations for diff files
   - Restart IDE after configuration changes

#### ❌ Selection Context Not Working

1. **IDE Integration**:
   - Verify extension is properly installed
   - Test with simple text selection
   - Check IDE console for errors

2. **Permissions**:
   - Some IDEs require additional permissions
   - Check IDE security settings
   - Allow clipboard access if prompted

#### ❌ Performance Issues

1. **Memory Allocation**:
   ```bash
   claude
   # In Claude:
   /config
   # Increase memory allocation
   ```

2. **IDE Resources**:
   - Close unnecessary IDE tabs/projects
   - Check available system memory
   - Consider increasing IDE memory allocation

3. **Extension Conflicts**:
   - Disable other AI coding extensions temporarily
   - Test with minimal extension set
   - Re-enable extensions one by one

### Remote Development

**VS Code Remote SSH/Containers**:
- Install Claude Code on the remote host
- Ensure SSH port forwarding is configured
- Test connection with `claude --version` on remote

**JetBrains Remote Development**:
- Install Claude Code on host machine
- Configure remote interpreter settings
- Test integration in remote environment

---

## 🎯 Best Practices

### Workflow Integration

1. **Start Development Session**:
   ```bash
   # Open project in IDE
   cursor my-project/    # or code, idea, etc.
   
   # Test Claude integration
   # Use Ctrl/Cmd+Esc to verify
   ```

2. **Daily Usage**:
   - Use selection context for targeted assistance
   - Leverage file references for broader context
   - Keep conversations focused and organized
   - Use diff viewing for code reviews

3. **Code Review Workflow**:
   - Select code sections for review
   - Use Claude for explanation and suggestions
   - Apply changes using IDE diff viewer
   - Commit changes with descriptive messages

### Performance Optimization

1. **IDE Configuration**:
   - Enable auto-save for better sync
   - Configure file watchers appropriately
   - Set up appropriate memory allocation
   - Use project-specific settings when needed

2. **Claude Configuration**:
   - Adjust memory based on project size
   - Use appropriate conversation history length
   - Configure diff tool for your workflow
   - Set up custom commands/shortcuts

3. **System Resources**:
   - Ensure adequate RAM (8GB+ recommended)
   - Use SSD storage for better performance
   - Close unnecessary applications during development
   - Monitor resource usage regularly

### Security Considerations

1. **Code Privacy**:
   - Review Claude's privacy policy
   - Understand data handling practices
   - Use appropriate privacy settings
   - Consider local model options for sensitive code

2. **Access Control**:
   - Secure your Claude account with 2FA
   - Use appropriate IDE security settings
   - Review extension permissions regularly
   - Monitor unauthorized access attempts

---

## 🔗 Integration with Lab Framework

### TaskMaster Integration

```bash
# Use Claude Code in TaskMaster workflow
tm next                              # Get next task
# Use Claude for implementation assistance
# Update task progress
tm update-subtask --id=5.2 --prompt="Implemented with Claude Code assistance"
```

### MCP Server Integration

Claude Code works seamlessly with other Lab Framework tools:
- **Desktop Commander**: File operations and system commands
- **BrowserBase**: Web automation and testing
- **Context7**: Documentation lookup and reference
- **Memory MCP**: Knowledge persistence across sessions

### Docker Integration

```dockerfile
# Example: Including Claude Code in development containers
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Install Claude Code CLI
RUN curl -L https://claude.ai/download/linux | bash

# Your development tools
RUN apt-get update && apt-get install -y nodejs npm

# IDE extensions will auto-install when container is used
```

---

## 📚 Additional Resources

### Documentation
- **Official Claude Code Docs**: https://docs.anthropic.com/en/docs/claude-code
- **VS Code Extension**: https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code
- **Lab Framework README**: [README.md](../../README.md)

### Community & Support
- **Lab Framework Issues**: Report setup issues via GitHub Issues
- **Claude Code Support**: Official Anthropic support channels
- **IDE-Specific Forums**: VS Code, JetBrains community forums

### Advanced Topics
- **Custom Keybindings**: IDE-specific configuration guides
- **Plugin Development**: Extending Claude Code functionality
- **Performance Tuning**: System optimization for AI development
- **Remote Development**: Cloud and container setups

---

## 🎉 Success Checklist

After completing setup, you should have:

- [ ] ✅ Claude Code CLI installed and working (`claude --version`)
- [ ] 🎨 IDE integration functional (shortcuts work)
- [ ] ⚡ Extension/plugin installed and enabled
- [ ] 🔧 Configuration optimized for your workflow
- [ ] 🧪 All integration features tested and working
- [ ] 📝 Lab Framework validation passing (run `validate-setup.ps1`)

**Congratulations!** You're now ready to experience AI-powered development with Claude Code in The Lab Framework! 🚀

---

*For issues or improvements to this guide, please contribute via GitHub Issues or Pull Requests.* 