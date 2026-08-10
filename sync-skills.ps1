# sync-skills.ps1 — 同步技能包到 gigi-skills repo 並推送
# 用法:  powershell -ExecutionPolicy Bypass -File .\sync-skills.ps1
# 可加 -Commit "說明文字" 自訂 commit message，預設自動產生

param(
  [string]$Repo = $PSScriptRoot,
  [string]$Commit = ""
)

$ErrorActionPreference = "Stop"
$env:CODEGRAPH_AGENTS = ""

# 設定主控台為 UTF-8，避免中文亂碼
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
try { chcp 65001 | Out-Null } catch {}

$agentsSkills = Join-Path $env:USERPROFILE ".agents\skills"
$antigravitySdk = Join-Path $env:USERPROFILE ".gemini\config\plugins\google-antigravity-sdk\SKILL.md"

Write-Host "=== 技能同步工具 ===" -ForegroundColor Cyan

# 1. 同步主技能 (排除 .env / .git)
Write-Host "[1/5] 同步 ~/.agents/skills -> agents-skills/" -ForegroundColor Yellow
robocopy $agentsSkills (Join-Path $Repo "agents-skills") /E /XD .git /XF .env /NFL /NDL /NJH /NJS
$rc = $LASTEXITCODE
if ($rc -ge 8) { Write-Error "robocopy 主技能失敗 (code $rc)"; exit 1 }
Write-Host "      完成 (robocopy code $rc, 0-7 皆為正常)" -ForegroundColor Green

# 2. 同步 Antigravity SDK
Write-Host "[2/5] 同步 google-antigravity-sdk" -ForegroundColor Yellow
$antDest = Join-Path $Repo "antigravity\google-antigravity-sdk"
New-Item -ItemType Directory -Path $antDest -Force | Out-Null
Copy-Item -LiteralPath $antigravitySdk -Destination (Join-Path $antDest "SKILL.md") -Force
Write-Host "      完成" -ForegroundColor Green

# 3. 先在本地 commit（不上傳）
Write-Host "[3/5] 本地 commit" -ForegroundColor Yellow
$hasCommit = $false
Push-Location $Repo
try {
  git add -A
  $changed = git status --porcelain
  if ($changed) {
    if (-not $Commit) {
      $date = Get-Date -Format "yyyy-MM-dd HH:mm"
      $fileCount = ($changed | Measure-Object -Line).Lines
      $Commit = "sync skills $date ($fileCount files)"
    }
    git commit -m $Commit
    $hasCommit = $true
    Write-Host "      已建立本地 commit: $Commit" -ForegroundColor Green
  } else {
    Write-Host "      沒有本機變更" -ForegroundColor Green
  }
} finally {
  Pop-Location
}

# 4. 下載並整合遠端（pull --rebase，避免覆蓋其他電腦的上傳）
Write-Host "[4/5] 下載並整合遠端變更 (pull --rebase)" -ForegroundColor Yellow
Push-Location $Repo
try {
  git pull --rebase origin main
  $pullRc = $LASTEXITCODE
  if ($pullRc -ne 0) {
    Write-Host "" -ForegroundColor Red
    Write-Host "!!! 遠端整合發生衝突 !!!" -ForegroundColor Red
    Write-Host "遠端有其他電腦的變更，與本機變更衝突。" -ForegroundColor Red
    Write-Host "請勿直接上傳，否則可能覆蓋他人內容。" -ForegroundColor Red
    Write-Host "請手動解決衝突後再執行 sync-skills.ps1：" -ForegroundColor Red
    Write-Host "  1) git status  查看衝突檔案" -ForegroundColor Yellow
    Write-Host "  2) 編輯解決 <<<<<<< 標記的衝突" -ForegroundColor Yellow
    Write-Host "  3) git add -A && git rebase --continue" -ForegroundColor Yellow
    Write-Host "  4) 再執行 sync-skills.ps1 上傳" -ForegroundColor Yellow
    Write-Host "" -ForegroundColor Red
    if ([Environment]::UserInteractive) {
      Write-Host "按任意鍵關閉視窗..." -ForegroundColor DarkGray
      $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    exit 1
  }
  Write-Host "      遠端已整合" -ForegroundColor Green
} finally {
  Pop-Location
}

# 5. push
Write-Host "[5/5] git push" -ForegroundColor Yellow
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
