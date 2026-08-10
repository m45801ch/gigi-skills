# Skills Backup

所有 AI agent 技能包的統一備份 repo，用於跨電腦同步。

## 內容

| 資料夾 | 來源 | 說明 |
|---|---|---|
| `agents-skills/` | `~/.agents/skills/` | 共用技能（gstack、baoyu、ckm、superpowers 等，opencode/Claude Code/Cursor 通用） |
| `antigravity/google-antigravity-sdk/` | `~/.gemini/config/plugins/google-antigravity-sdk/` | Google Antigravity SDK 技能 |
| `opencode-config/` | `~/.config/opencode/` | opencode 設定（opencode.jsonc、AGENTS.md、package.json） |

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
- 安裝 opencode 設定 → `~/.config/opencode/`（opencode.jsonc、AGENTS.md、package.json）

安裝後**重啟你的 AI 工具**即生效。

> 若不想覆蓋本機現有的 opencode 設定，可加 `-SkipOpenCode` 跳過該步驟。

**opencode 設定的注意事項**：
- `package.json` 讓 opencode 啟動時自動安裝 superpowers plugin
- `opencode.jsonc` 內的 codegraph MCP server 需要先安裝 CLI：`npm i -g @colbymchenry/codegraph`，否則 MCP 不會連線

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

### 安全同步流程（先整合、後上傳）

為了避免 B 電腦上傳時覆蓋 A 電腦已上傳的技能，腳本採「先下載整合、再上傳」的流程：

1. 同步本機技能 → `agents-skills/`
2. 在**本地**建立 commit（尚未上傳）
3. `git pull --rebase`：先下載遠端最新變更，把本地 commit 疊在遠端之上
4. 才執行 `git push`

如此一來，若其他電腦有更新，會先整合進來（保留雙方變更），不會直接覆蓋。若發生衝突，腳本會**停止並提示手動解決**，不會盲目上傳覆蓋。

無本機變更時，仍會執行 pull 取得遠端最新內容，只是跳過 commit。

## 敏感檔案

`.env`、API key、憑證等已由 `.gitignore` 排除，**不會**提交。新電腦需手動重新設定（如 anysearch 的 `ANYSEARCH_API_KEY`）。
