# Skills Backup

所有 AI agent 技能包的統一備份 repo，用於跨電腦同步。

## 內容

| 資料夾 | 來源 | 說明 |
|---|---|---|
| `agents-skills/` | `~/.agents/skills/` | 共用技能（gstack、baoyu、ckm、superpowers 等，opencode/Claude Code/Cursor 通用） |
| `antigravity/google-antigravity-sdk/` | `~/.gemini/config/plugins/google-antigravity-sdk/` | Google Antigravity SDK 技能 |

## 同步到新電腦

### 一次性的安裝（repo → 本機）

Clone 後用 `install-skills.ps1` 把技能裝到新電腦：

```powershell
git clone https://github.com/m45801ch/gigi-skills.git
cd gigi-skills
powershell -ExecutionPolicy Bypass -File .\install-skills.ps1
```

它會自動：
- 安裝 `agents-skills/` → `~/.agents/skills`（opencode / Claude Code / Cursor 共用）
- 安裝 Antigravity SDK → `~/.gemini/config/plugins/google-antigravity-sdk/`

安裝後**重啟你的 AI 工具**即生效。

### 手動安裝（不跑腳本時）

```bash
robocopy "skills-backup\agents-skills" "%USERPROFILE%\.agents\skills" /E
robocopy "skills-backup\antigravity\google-antigravity-sdk" "%USERPROFILE%\.gemini\config\plugins\google-antigravity-sdk" /E
```

## 兩台電腦的使用流程

> 腳本自動偵測所在資料夾位置（`$PSScriptRoot`），Clone 到哪都能用。

**A 電腦（主機，有更新技能時）**
```powershell
powershell -ExecutionPolicy Bypass -File .\sync-skills.ps1
# 把 A 的技能推送回 GitHub repo
```

**B 電腦（新機，要取得最新技能時）**
```powershell
git pull                    # 先拉最新
powershell -ExecutionPolicy Bypass -File .\install-skills.ps1   # 安裝到本機
```

**B 電腦（想把自己的技能也上傳時）**
```powershell
powershell -ExecutionPolicy Bypass -File .\sync-skills.ps1
# 注意：這會把 B 本機的技能覆蓋 repo 內容並推送（含 B 的修改）
```

## 自動同步（本機 A）

`sync-skills.ps1` 會把本機最新的技能同步回 repo 並推送：

```powershell
# 一般同步（自動產生 commit message）
powershell -ExecutionPolicy Bypass -File .\sync-skills.ps1

# 自訂 commit 說明
powershell -ExecutionPolicy Bypass -File .\sync-skills.ps1 -Commit "新增某技能"
```

做的事：同步 `~/.agents/skills` → `agents-skills/`、同步 Antigravity SDK、git add/commit、push。無變更時自動跳過。

## 敏感檔案

`.env`、API key、憑證等已由 `.gitignore` 排除，**不會**提交。新電腦需手動重新設定（如 anysearch 的 `ANYSEARCH_API_KEY`）。
