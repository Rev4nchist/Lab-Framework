# 🔑 API Key Management & Cost Control Guide

> Secure handling and cost optimization for The Lab's AI-powered services

## Overview

The Lab Framework leverages multiple AI services and APIs. This guide ensures secure key management and helps control costs while maintaining productivity.

## API Key Security

### Storage Best Practices

1. **Never Commit Keys**
   ```bash
   # Add to .gitignore
   .env
   .env.local
   .env.*.local
   *.key
   *.pem
   ```

2. **Use Environment Variables**
   ```bash
   # Development: .env file
   ANTHROPIC_API_KEY=sk-ant-xxx

   # Production: System environment
   export ANTHROPIC_API_KEY="sk-ant-xxx"

   # Azure Key Vault (recommended for teams)
   az keyvault secret set --vault-name lab-vault \
     --name anthropic-api-key --value "sk-ant-xxx"
   ```

3. **Separate Keys by Environment**
   ```
   .env.development    # Low rate limits, testing
   .env.staging       # Medium limits, QA
   .env.production    # Full limits, monitoring
   ```

### Key Rotation Strategy

```bash
# Quarterly rotation schedule
# 1. Generate new keys
# 2. Update in secure storage
# 3. Deploy to all environments
# 4. Revoke old keys after verification

# Automation script
./scripts/rotate-api-keys.ps1
```## Cost Monitoring & Control

### Service Cost Breakdown

| Service | Model | Input Cost | Output Cost | Monthly Budget |
|---------|-------|------------|-------------|----------------|
| Anthropic | Claude 3 Opus | $15/M tokens | $75/M tokens | $500 |
| Anthropic | Claude 3 Sonnet | $3/M tokens | $15/M tokens | $200 |
| OpenAI | GPT-4 | $30/M tokens | $60/M tokens | $300 |
| OpenAI | GPT-3.5 | $0.5/M tokens | $1.5/M tokens | $50 |
| Perplexity | Sonar Large | $5/M tokens | $5/M tokens | $100 |
| BrowserBase | Actions | $0.05/action | - | $50 |

### Cost Tracking Script

```python
# scripts/track-ai-costs.py
import os
import json
from datetime import datetime
import anthropic
import openai

def track_usage():
    """Track API usage across services"""
    usage = {
        "date": datetime.now().isoformat(),
        "anthropic": get_anthropic_usage(),
        "openai": get_openai_usage(),
        "total_cost": 0
    }
    
    # Calculate costs
    usage["total_cost"] = calculate_total_cost(usage)
    
    # Save to file
    with open('.lab/usage-stats.json', 'a') as f:
        f.write(json.dumps(usage) + '\n')
    
    # Alert if over budget
    if usage["total_cost"] > DAILY_BUDGET:
        send_cost_alert(usage)
```

### Cost Optimization Strategies1. **Model Selection**
   ```javascript
   // Use appropriate models for tasks
   const MODEL_SELECTION = {
     simple: 'gpt-3.5-turbo',        // Simple queries
     standard: 'claude-3-sonnet',     // Most development
     complex: 'claude-3-opus',        // Architecture, debugging
     research: 'perplexity-sonar'     // Documentation, research
   };
   ```

2. **Token Optimization**
   - Use `--compress` flag in SuperClaude
   - Implement context windowing
   - Cache common responses
   - Batch similar requests

3. **TaskMaster Configuration**
   ```bash
   # Set cost-effective defaults
   tm models --set-main=claude-3-sonnet
   tm models --set-research=perplexity-sonar
   tm models --set-fallback=gpt-3.5-turbo
   ```

## Team Management

### Shared Team Keys (Azure Key Vault)

```bash
# Setup team vault
az keyvault create --name lab-team-vault \
  --resource-group lab-resources \
  --location eastus

# Add team keys
az keyvault secret set --vault-name lab-team-vault \
  --name anthropic-team-key --value $ANTHROPIC_KEY

# Grant access
az keyvault set-policy --name lab-team-vault \
  --upn user@company.com \
  --secret-permissions get list### Individual Developer Keys

```yaml
# .cursor/mcp.json (personal keys)
{
  "mcpServers": {
    "taskmaster": {
      "env": {
        "ANTHROPIC_API_KEY": "${env:ANTHROPIC_PERSONAL_KEY}"
      }
    }
  }
}
```

## Monitoring & Alerts

### Usage Dashboard

```javascript
// scripts/usage-dashboard.js
const express = require('express');
const app = express();

app.get('/api/usage', async (req, res) => {
  const usage = await getUsageStats();
  res.json({
    daily: usage.daily,
    weekly: usage.weekly,
    monthly: usage.monthly,
    costByService: usage.byService,
    alerts: usage.alerts
  });
});

// Start dashboard
// npm run usage-dashboard
// Open http://localhost:3000/dashboard
```

### Alert Configuration

```javascript
// config/alerts.json
{
  "thresholds": {
    "daily": 50,      // $50/day
    "weekly": 200,    // $200/week
    "monthly": 500    // $500/month
  },
  "notifications": {
    "email": "team@company.com",
    "slack": "#lab-alerts"
  }
}## Emergency Procedures

### Key Compromise Response

1. **Immediate Actions**
   ```bash
   # Revoke compromised key immediately
   # Anthropic: dashboard.anthropic.com
   # OpenAI: platform.openai.com
   # GitHub: github.com/settings/tokens
   
   # Rotate all keys in same environment
   ./scripts/emergency-key-rotation.ps1
   ```

2. **Audit Usage**
   ```bash
   # Check for unauthorized usage
   python scripts/audit-api-usage.py --since="2024-01-01"
   ```

3. **Update All Services**
   ```bash
   # Update MCP configurations
   code .cursor/mcp.json
   
   # Update environment files
   code .env
   
   # Update Azure Key Vault
   az keyvault secret set --vault-name lab-vault \
     --name compromised-key --value "REVOKED"
   ```

## Cost Optimization Checklist

- [ ] Use appropriate models for each task type
- [ ] Enable caching where possible
- [ ] Batch similar API requests
- [ ] Set up usage alerts
- [ ] Review weekly cost reports
- [ ] Optimize prompts for token efficiency
- [ ] Use local models for testing
- [ ] Implement request rate limiting
- [ ] Cache documentation lookups
- [ ] Archive old conversation contexts

## Quick Reference

### Check Current Usage
```bash
# Anthropic
curl https://api.anthropic.com/v1/usage \
  -H "x-api-key: $ANTHROPIC_API_KEY"

# OpenAI  
curl https://api.openai.com/v1/usage \
  -H "Authorization: Bearer $OPENAI_API_KEY"
```

### Estimate Task Costs
```python
# Quick cost calculator
def estimate_cost(tokens, model="claude-3-sonnet"):
    rates = {
        "claude-3-opus": {"input": 0.015, "output": 0.075},
        "claude-3-sonnet": {"input": 0.003, "output": 0.015},
        "gpt-4": {"input": 0.03, "output": 0.06},
        "gpt-3.5-turbo": {"input": 0.0005, "output": 0.0015}
    }
    
    rate = rates.get(model, rates["claude-3-sonnet"])
    # Assume 30% output ratio
    input_tokens = tokens * 0.7
    output_tokens = tokens * 0.3
    
    cost = (input_tokens * rate["input"] + 
            output_tokens * rate["output"]) / 1000
    
    return f"${cost:.2f} for {tokens:,} tokens"
```

---

*Remember: Good API key hygiene protects both security and budget. Monitor actively, rotate regularly, and optimize constantly.*