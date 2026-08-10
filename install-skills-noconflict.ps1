# install-skills-noconflict.ps1 — 安裝技能，但保留本機原本的 opencode 設定
# 用法:  powershell -ExecutionPolicy Bypass -File .\install-skills-noconflict.ps1
# 作用:  等同 install-skills.ps1 -SkipOpenCode
#         安裝 技能 + Antigravity SDK，但「不覆蓋」 ~/.config/opencode 的現有設定

$ErrorActionPreference = "Stop"

# 設定主控台為 UTF-8，避免中文亂碼
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
try { chcp 65001 | Out-Null } catch {}

Write-Host "=== 技能安裝工具 (保留本機 opencode 設定) ===" -ForegroundColor Cyan
Write-Host "說明: 只安裝技能 + Antigravity SDK，" -ForegroundColor Yellow
Write-Host "      不覆蓋 ~/.config/opencode 的現有設定。" -ForegroundColor Yellow
Write-Host ""

# 呼叫主安裝腳本，跳過 opencode 設定
& (Join-Path $PSScriptRoot "install-skills.ps1") -SkipOpenCode

if ($LASTEXITCODE -ne 0) {
  Write-Host ""
  Write-Host "!!! 安裝發生錯誤 (exit code: $LASTEXITCODE) !!!" -ForegroundColor Red
  if ([Environment]::UserInteractive) {
    Write-Host "按任意鍵關閉視窗..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  }
  exit 1
}
