# install-skills.ps1 — 把 gigi-skills repo 的技能安裝到本機
# 用法:  powershell -ExecutionPolicy Bypass -File .\install-skills.ps1
# 作用:  把 repo 的 agents-skills 複製到 ~/.agents/skills
#         把 Antigravity SDK 複製到 ~/.gemini/config/plugins/

$ErrorActionPreference = "Stop"

# 設定主控台為 UTF-8，避免中文亂碼
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
try { chcp 65001 | Out-Null } catch {}

$Repo = $PSScriptRoot
$agentsSkills = Join-Path $env:USERPROFILE ".agents\skills"
$antigravitySdk = Join-Path $env:USERPROFILE ".gemini\config\plugins\google-antigravity-sdk"

Write-Host "=== 技能安裝工具 ===" -ForegroundColor Cyan

# 1. 安裝主技能到 ~/.agents/skills
Write-Host "[1/2] 安裝技能 -> ~/.agents/skills" -ForegroundColor Yellow
New-Item -ItemType Directory -Path $agentsSkills -Force | Out-Null
robocopy (Join-Path $Repo "agents-skills") $agentsSkills /E /XD .git /XF .env /NFL /NDL /NJH /NJS
$rc = $LASTEXITCODE
if ($rc -ge 8) { Write-Error "robocopy 安裝失敗 (code $rc)"; exit 1 }
Write-Host "      完成 (robocopy code $rc, 0-7 皆為正常)" -ForegroundColor Green

# 2. 安裝 Antigravity SDK
Write-Host "[2/2] 安裝 google-antigravity-sdk" -ForegroundColor Yellow
New-Item -ItemType Directory -Path $antigravitySdk -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $Repo "antigravity\google-antigravity-sdk\SKILL.md") -Destination (Join-Path $antigravitySdk "SKILL.md") -Force
Write-Host "      完成" -ForegroundColor Green

Write-Host ""
Write-Host "=== 安裝完成 ===" -ForegroundColor Green
Write-Host "提示: 重啟你的 AI 工具 (opencode / Claude Code / Gemini CLI) 後生效"
Write-Host ""
if ([Environment]::UserInteractive) {
  Write-Host "按任意鍵關閉視窗..." -ForegroundColor DarkGray
  $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
