# Skills Backup

所有 AI agent 技能包的統一備份 repo，用於跨電腦同步。

## 內容

| 資料夾 | 來源 | 說明 |
|---|---|---|
| `agents-skills/` | `~/.agents/skills/` | 共用技能（gstack、baoyu、ckm、superpowers 等，opencode/Claude Code/Cursor 通用） |
| `antigravity/google-antigravity-sdk/` | `~/.gemini/config/plugins/google-antigravity-sdk/` | Google Antigravity SDK 技能 |

## 同步到新電腦

```bash
git clone <repo-url> skills-backup
```

### opencode / 共用 agent
```bash
# 用 robocopy 複製到共用技能目錄（Windows）
robocopy "skills-backup\agents-skills" "%USERPROFILE%\.agents\skills" /E
```

### Antigravity (Gemini CLI)
```bash
mkdir -p ~/.gemini/config/plugins/google-antigravity-sdk
cp skills-backup/antigravity/google-antigravity-sdk/SKILL.md ~/.gemini/config/plugins/google-antigravity-sdk/
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
