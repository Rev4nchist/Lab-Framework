# ✅ Claude Code Integration Checklist

> Use this checklist to verify your Claude Code + IDE integration is working properly

## 🚀 Pre-Integration Setup

- [ ] **Claude Code CLI Installed**
  ```bash
  claude --version
  # Should output version number without errors
  ```

- [ ] **IDE with CLI Available**
  - [ ] VS Code: `code --version` works
  - [ ] Cursor: `cursor --version` works  
  - [ ] Windsurf: `windsurf --version` works
  - [ ] JetBrains: `idea --version` / `pycharm --version` works

- [ ] **Lab Framework Setup Complete**
  ```powershell
  .\core-tools\scripts\validate-setup.ps1
  # Should show high success rate
  ```

---

## 🔧 Integration Setup

- [ ] **Run Integration Script**
  ```powershell
  .\core-tools\scripts\setup-claude-ide.ps1
  ```

- [ ] **Extension/Plugin Auto-Installed**
  - [ ] VS Code: Check Extensions panel for "Claude Code"
  - [ ] Cursor: Check Extensions panel for "Claude Code"
  - [ ] Windsurf: Check Extensions panel for "Claude Code" 
  - [ ] JetBrains: Check Settings → Plugins for "Claude Code"

- [ ] **Extension/Plugin Enabled**
  - [ ] Appears in extensions/plugins list
  - [ ] No error indicators
  - [ ] IDE restarted after installation (especially JetBrains)

---

## ⚡ Feature Testing

### Basic Integration
- [ ] **Quick Launch Shortcut**
  - [ ] `Ctrl+Esc` (Windows/Linux) opens Claude
  - [ ] `Cmd+Esc` (Mac) opens Claude
  - [ ] OR accessible via Command Palette/Tools menu

- [ ] **File Reference Shortcut**
  - [ ] `Ctrl+Alt+K` (Windows/Linux) works
  - [ ] `Cmd+Option+K` (Mac) works
  - [ ] File context properly shared with Claude

### Advanced Features
- [ ] **Selection Context Sharing**
  - [ ] Select code in editor
  - [ ] Launch Claude with shortcut
  - [ ] Selected code appears in Claude context

- [ ] **Diff Viewing in IDE**
  - [ ] Ask Claude to modify code
  - [ ] Diff appears in IDE editor tabs (not terminal)
  - [ ] Syntax highlighting works in diff view

- [ ] **Conversation Persistence**
  - [ ] Claude remembers conversation history
  - [ ] Context carries between interactions
  - [ ] File references maintained

---

## 🎛️ Configuration Optimization

- [ ] **Claude Code Configuration**
  ```bash
  # In Claude, run:
  /config
  ```
  - [ ] Diff tool set to "auto"
  - [ ] Memory allocation appropriate for system
  - [ ] Other settings optimized

- [ ] **IDE Settings**
  - [ ] Auto-save enabled (recommended)
  - [ ] File watchers configured (if needed)
  - [ ] Bracket matching enabled
  - [ ] Custom shortcuts configured (if desired)

---

## 🔍 Troubleshooting (If Issues Found)

### Claude Code CLI Issues
- [ ] **Reinstall Claude Code**
  ```bash
  # Windows
  winget install Anthropic.Claude
  
  # Mac
  brew install claude
  
  # Or download: https://claude.ai/download
  ```

- [ ] **Check PATH**
  ```bash
  # Check if Claude is in PATH
  which claude    # Mac/Linux
  where claude    # Windows
  ```

### IDE Integration Issues
- [ ] **VS Code/Cursor/Windsurf CLI Missing**
  - [ ] VS Code: `Cmd/Ctrl+Shift+P` → "Shell Command: Install 'code' command in PATH"
  - [ ] Cursor: Should be available after installation
  - [ ] Windsurf: Should be available after installation

- [ ] **JetBrains CLI Missing**
  - [ ] Open JetBrains Toolbox → Settings
  - [ ] Enable "Generate shell scripts"
  - [ ] Ensure CLI commands in PATH

### Extension/Plugin Issues
- [ ] **Extension Not Installing**
  - [ ] Check IDE permissions
  - [ ] Try manual installation from marketplace
  - [ ] Restart IDE completely

- [ ] **Plugin Not Working (JetBrains)**
  - [ ] Must run `claude` from project root directory
  - [ ] Restart IDE 2-3 times (known requirement)
  - [ ] Manually enable plugin in Settings → Plugins

### Feature Issues
- [ ] **Shortcuts Not Working**
  - [ ] Check for keyboard shortcut conflicts
  - [ ] Verify extension is active in IDE
  - [ ] Try Command Palette as alternative

- [ ] **Diff Not in IDE**
  - [ ] Run `/config` in Claude
  - [ ] Set diff tool to "auto"
  - [ ] Restart IDE after configuration change

---

## 🎉 Success Confirmation

When all items are checked, you should have:

✅ **Claude Code CLI working**  
✅ **IDE integration functional**  
✅ **Extension/plugin active**  
✅ **All shortcuts working**  
✅ **Diff viewing in IDE**  
✅ **Selection context sharing**  
✅ **Configuration optimized**

**Congratulations!** Your Claude Code + IDE integration is complete! 🚀

---

## 📚 Additional Resources

- **Setup Guide**: [claude-code-setup-guide.md](../guides/claude-code-setup-guide.md)
- **Troubleshooting**: See setup guide for detailed solutions
- **Lab Framework**: [README.md](../../README.md)
- **Agent Onboarding**: [AGENT_ONBOARDING_PROTOCOL.md](../../AGENT_ONBOARDING_PROTOCOL.md)

---

*Save this checklist and use it whenever setting up Claude Code integration on a new system!* 