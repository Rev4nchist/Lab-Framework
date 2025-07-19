# Git commit script for Lab Framework updates
Set-Location "C:\Users\david.hayes\Downloads\personal-agent-project\the-lab-framework"

Write-Host "Adding all changes..." -ForegroundColor Green
git add -A

Write-Host "`nCurrent git status:" -ForegroundColor Yellow
git status

Write-Host "`nCreating commit..." -ForegroundColor Green
git commit -m "feat: Browser MCP performance updates and comprehensive toolkit guide

- Add development_toolkit_guide.mdc with battle-tested MCP patterns
- Update BrowserBase to Smithery CLI config (95% success rate)
- Add MCP Tool Integration references to existing rules
- Create optimized mcp.json with cleaned entries
- Document 30x performance gains for file operations"

Write-Host "`nCommit complete!" -ForegroundColor Green