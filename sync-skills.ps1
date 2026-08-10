# sync-skills.ps1 — 同步技能包到 gigi-skills repo 並推送
# 用法:  powershell -ExecutionPolicy Bypass -File .\sync-skills.ps1
# 可加 -Commit "說明文字" 自訂 commit message，預設自動產生

param(
  [string]$Repo = "C:\Users\GIGI\skills-backup",
  [string]$Commit = ""
)

$ErrorActionPreference = "Stop"
$env:CODEGRAPH_AGENTS = ""

$agentsSkills = Join-Path $env:USERPROFILE ".agents\skills"
$antigravitySdk = Join-Path $env:USERPROFILE ".gemini\config\plugins\google-antigravity-sdk\SKILL.md"

Write-Host "=== 技能同步工具 ===" -ForegroundColor Cyan

# 1. 同步主技能 (排除 .env / .git)
Write-Host "[1/4] 同步 ~/.agents/skills -> agents-skills/" -ForegroundColor Yellow
robocopy $agentsSkills (Join-Path $Repo "agents-skills") /E /XD .git /XF .env /NFL /NDL /NJH /NJS
$rc = $LASTEXITCODE
if ($rc -ge 8) { Write-Error "robocopy 主技能失敗 (code $rc)"; exit 1 }
Write-Host "      完成 (robocopy code $rc, 0-7 皆為正常)" -ForegroundColor Green

# 2. 同步 Antigravity SDK
Write-Host "[2/4] 同步 google-antigravity-sdk" -ForegroundColor Yellow
$antDest = Join-Path $Repo "antigravity\google-antigravity-sdk"
New-Item -ItemType Directory -Path $antDest -Force | Out-Null
Copy-Item -LiteralPath $antigravitySdk -Destination (Join-Path $antDest "SKILL.md") -Force
Write-Host "      完成" -ForegroundColor Green

# 3. git add + commit
Write-Host "[3/4] git add + commit" -ForegroundColor Yellow
Push-Location $Repo
try {
  git add -A

  # 檢查是否有變更 (避免空 commit)
  $changed = git status --porcelain
  if (-not $changed) {
    Write-Host "      沒有變更，跳過 commit" -ForegroundColor Green
    Pop-Location
    Write-Host ""
    Write-Host "=== 無變更，結束 ===" -ForegroundColor Green
    Write-Host ""
    if ([Environment]::UserInteractive) {
      Write-Host "按任意鍵關閉視窗..." -ForegroundColor DarkGray
      $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    exit 0
  }

  if (-not $Commit) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm"
    $fileCount = ($changed | Measure-Object -Line).Lines
    $Commit = "sync skills $date ($fileCount files)"
  }
  git commit -m $Commit
} finally {
  Pop-Location
}

# 4. push
Write-Host "[4/4] git push" -ForegroundColor Yellow
Push-Location $Repo
try {
  git push
} finally {
  Pop-Location
}

Write-Host "=== 同步完成 ===" -ForegroundColor Green
Write-Host ""
if ([Environment]::UserInteractive) {
  Write-Host "按任意鍵關閉視窗..." -ForegroundColor DarkGray
  $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
