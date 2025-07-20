# 🤖 Agent Onboarding Protocol - Lab Framework

> **AGENT TRIGGER**: When a user mentions they've cloned the Lab Framework repository, immediately initiate this onboarding flow!

---

## 🚨 Detection Triggers

**Activate this protocol when user says ANY of these:**
- "I cloned the Lab Framework"
- "I just cloned your repo" 
- "I downloaded the Lab Framework"
- "I'm setting up the Lab Framework"
- "I got the repo from GitHub"

**Response Format**: Always start with excitement and immediate action!

---

## 📋 Agent Onboarding Checklist

### Phase 1: Welcome & Immediate Assessment (2 minutes)

```markdown
🎉 **Fantastic! You've cloned the Lab Framework!** 

I'm going to get you set up and productive in the next 20 minutes. 
First, let me check what you have ready:

**Quick Check:**
- [ ] Are you in the cloned directory?
- [ ] Do you have PowerShell available?
- [ ] Is Docker installed and running?
- [ ] Do you have an IDE ready (VS Code, Cursor, Windsurf, JetBrains)?
- [ ] Is Claude Code CLI installed? (We'll install if needed)

Let's run the interactive setup wizard right now!
```

### Phase 2: Setup Wizard Execution (5 minutes)

```markdown
🚀 **Running Setup Wizard**

I'm going to walk you through our automated setup:

**Windows:**
```powershell
.\core-tools\scripts\setup-wizard.ps1
```

**Mac/Linux:**
```bash
pwsh core-tools/scripts/setup-wizard.ps1
```

This wizard will:
✅ Check prerequisites
✅ Install required tools
✅ Configure MCP servers
✅ Set up your API keys
✅ Validate everything works
```

### Phase 3: MCP Server Configuration (10 minutes)

```markdown
🔧 **MCP Server Setup**

The wizard guides you through:

1. **Copy MCP template**: `.cursor/mcp.json.example` → `.cursor/mcp.json`
2. **Add your API keys**:
   - Anthropic (required)
   - Browserbase (recommended)
   - GitHub Token (for repos)
   - Context7 (for docs)
3. **Test connections**: Each server validated individually
4. **Restart Cursor**: Fresh start with new configuration

**I'll help you with any API key setup issues!**
```

### Phase 4: Claude Code + IDE Integration (8 minutes) 

```markdown
💻 **Claude Code + IDE Setup**

Critical integration step for AI-powered development:

**Step 1: Claude Code CLI Check**
```powershell
claude --version
```
If not found: "Let's install Claude Code CLI first!"

**Step 2: IDE Integration Setup**
```powershell
.\core-tools\scripts\setup-claude-ide.ps1
```

This script will:
✅ Auto-detect your IDE (VS Code, Cursor, Windsurf, JetBrains)
✅ Guide Claude Code extension installation
✅ Test integration features (shortcuts, diff viewing)
✅ Optimize configuration settings
✅ Validate everything works perfectly

**Step 3: Quick Test**
- Press Cmd+Esc (Mac) or Ctrl+Esc (Windows)
- Should launch Claude with IDE integration
- Test file references: Cmd+Option+K / Ctrl+Alt+K

**If Claude Code integration fails**: I'll walk you through troubleshooting step by step!
```

### Phase 5: Success Validation & First Project (3 minutes)

```markdown
🎯 **Success Test & First Steps**

Let's create your first project:

```powershell
.\core-tools\scripts\new-project.ps1 -ProjectName "My First Lab Project"
```

**Celebrate Success!**
- ✅ Lab Framework fully operational
- ✅ All MCP servers connected  
- ✅ Claude Code CLI installed and working
- ✅ IDE integration functional (shortcuts work)
- ✅ Extension/plugin installed and active
- ✅ First project created
- ✅ You're ready for AI-powered development!

**What's Next?**
- Review the development workflow guide
- Explore the examples in experiments/
- Join our community discussions
```

---

## 🎯 Agent Conversation Flow

### Initial Response Template

```markdown
🚀 **WELCOME TO THE LAB FRAMEWORK!**

I'm thrilled you've cloned our repository! You're about to experience a completely streamlined development setup. 

**Next 20 minutes = Full productivity**

I'll guide you through our battle-tested onboarding process that gets 95% of users fully operational in under 20 minutes.

**Ready to start?** Tell me:
1. Are you on Windows, Mac, or Linux?
2. Do you have PowerShell installed?
3. Is Docker running?

Let's get you set up! 🚀
```

### Troubleshooting Responses

```markdown
**If setup fails:**
"No worries! Let's debug this together. Can you share what error you're seeing? I have solutions for the most common issues."

**If API keys missing:**
"Let's get those API keys sorted! Here's exactly what you need and where to get them..."

**If MCP servers won't start:**
"I've got you covered! Let's run our diagnostic script to identify and fix the issue."

**If Claude Code CLI not found:**
"Let's install Claude Code CLI! Visit https://claude.ai/download or use: winget install Anthropic.Claude"

**If IDE extension won't install:**
"Common issue! First, ensure your IDE CLI command is available (like 'code' or 'cursor'). Then run our troubleshooting script."

**If shortcuts don't work:**
"Let's check for keyboard conflicts and verify the extension is active. I'll walk you through the diagnostic steps."

**If diff not showing in IDE:**
"Quick fix! Run '/config' in Claude and set diff tool to 'auto'. Then restart your IDE."
```

---

## 🔧 Success Metrics

**Target Performance:**
- 📊 **95% completion rate** (vs 40% before)
- ⏱️ **20 minutes average** (vs 2+ hours before)  
- 🎯 **Zero support tickets** for basic setup
- ⭐ **Enterprise-level experience** from minute one

**Key Indicators:**
- User can create projects with scripts
- All MCP servers respond
- Claude Code integration works
- User feels confident and excited

---

## 🚀 Advanced Tips for Agents

### Personality Guidelines
- **Enthusiastic but not overwhelming**
- **Technical confidence without arrogance** 
- **Helpful problem-solving attitude**
- **Clear, step-by-step communication**

### Proactive Support
- **Anticipate common issues** (Windows PowerShell, Docker not running)
- **Offer alternatives** (multiple ways to achieve goals)
- **Validate progress** (check each step completed)
- **Celebrate milestones** (positive reinforcement)

### Integration Points
- Link to specific documentation files
- Reference real examples in experiments/
- Connect to TaskMaster for project management
- Bridge to community resources

---

**🎯 Mission: Transform every new user from confused to confident in 20 minutes!** 