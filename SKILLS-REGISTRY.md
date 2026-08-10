# Skill Registry — 技能清單與來源

> 本清單記錄使用者已安裝的所有 AI agent 技能及其 GitHub 來源。
> 用途：載入此清單給 agent，即可依照來源一鍵重新安裝全部技能。

## 安裝目標

所有技能統一安裝到共用技能目錄 `~/.agents/skills/`（opencode、Claude Code、Cursor 皆讀取此目錄）。

## 技能來源清單

### 1. baoyu-skills（21 個技能 + release-skills）
- **來源**: `https://github.com/JimLiu/baoyu-skills`
- **安裝**: 每個技能從該 repo 的 `skills/<name>/` 目錄複製到 `~/.agents/skills/<name>/`
- **技能列表**:
  - baoyu-article-illustrator
  - baoyu-comic
  - baoyu-compress-image
  - baoyu-cover-image
  - baoyu-danger-gemini-web
  - baoyu-danger-x-to-markdown
  - baoyu-diagram
  - baoyu-electron-extract
  - baoyu-format-markdown
  - baoyu-image-gen
  - baoyu-infographic
  - baoyu-markdown-to-html
  - baoyu-post-to-wechat
  - baoyu-post-to-weibo
  - baoyu-post-to-x
  - baoyu-slide-deck
  - baoyu-translate
  - baoyu-url-to-markdown
  - baoyu-wechat-summary
  - baoyu-xhs-images
  - baoyu-youtube-transcript
  - release-skills
- **注意**: baoyu 系列含 `release-skills`，兩者同源

### 2. gstack（1 個大套件 + 60+ 子技能）
- **來源**: `https://github.com/garrytan/gstack`
- **安裝**: `git clone --depth 1 https://github.com/garrytan/gstack.git ~/gstack`，內含 autoplan、browse、qa、review、ship、spec、investigate 等子技能

### 3. superpowers（14 個技能，opencode plugin）
- **來源**: `https://github.com/obra/superpowers`
- **安裝**: 在 `~/.config/opencode/opencode.jsonc` 的 `plugin` 加入 `superpowers@git+https://github.com/obra/superpowers.git`；或在 `~/.agents/skills/` 手動複製技能
- **技能列表**:
  - brainstorming
  - dispatching-parallel-agents
  - executing-plans
  - finishing-a-development-branch
  - receiving-code-review
  - requesting-code-review
  - subagent-driven-development
  - systematic-debugging
  - test-driven-development
  - using-git-worktrees
  - using-superpowers
  - verification-before-completion
  - writing-plans
  - writing-skills

### 4. anthropics/skills（2 個技能）
- **來源**: `https://github.com/anthropics/skills`
- **安裝**: `npx skills add https://github.com/anthropics/skills --skill <name>`
- **技能列表**:
  - frontend-design（本機為改寫版，加中文描述）
  - skill-creator

### 5. ui-ux-pro-max（1 個技能）
- **來源**: `https://github.com/nextlevelbuilder/ui-ux-pro-max-skill`
- **安裝**: `git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill`

### 6. ckm 系列（6 個技能，同屬 ui-ux-pro-max-skill）
- **來源**: `https://github.com/nextlevelbuilder/ui-ux-pro-max-skill`（`.claude/skills/` 目錄，author: claudekit）
- **技能列表**:
  - ckm-banner-design
  - ckm-brand
  - ckm-design
  - ckm-design-system
  - ckm-slides
  - ckm-ui-styling

### 7. anysearch（1 個技能）
- **來源**: `https://github.com/anysearch-ai/anysearch-skill`
- **安裝**: 下載 release 或 clone 後，將 `anysearch-skill-<version>` 改名為 `anysearch` 放入 `~/.agents/skills/`
- **注意**: 需設定 `ANYSEARCH_API_KEY`（`.env` 檔案，未打包）

### 8. karpathy-guidelines（1 個技能）
- **來源**: `https://github.com/forrestchang/andrej-karpathy-skills`
- **安裝**: `npx skills add https://github.com/forrestchang/andrej-karpathy-skills --skill karpathy-guidelines`

### 9. find-skills（1 個技能）
- **來源**: `https://github.com/vercel-labs/skills`
- **安裝**: `npx skills add https://github.com/vercel-labs/skills --skill find-skills`
- **注意**: 此技能為 skills.sh 生態的安裝助手，本身即用於安裝其他技能

### 10. grill-me（1 個技能，極簡版）
- **來源**: 無明確上游（本機為自訂極簡 wrapper，內容為 `Run a /grilling session`）
- **安裝**: 直接複製 `~/.agents/skills/grill-me/` 目錄

## 一鍵安裝指令（agent 可用）

```bash
# 主要來源一次抓取
git clone https://github.com/JimLiu/baoyu-skills.git          # baoyu + release-skills
git clone --depth 1 https://github.com/garrytan/gstack.git     # gstack 套件
git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git  # ui-ux-pro-max + ckm
git clone https://github.com/anysearch-ai/anysearch-skill.git  # anysearch

# 透過 skills CLI
npx skills add https://github.com/anthropics/skills --skill frontend-design --skill skill-creator
npx skills add https://github.com/forrestchang/andrej-karpathy-skills --skill karpathy-guidelines
npx skills add https://github.com/vercel-labs/skills --skill find-skills

# superpowers（opencode plugin）
# 在 ~/.config/opencode/opencode.jsonc 的 plugin 陣列加入：
#   "superpowers@git+https://github.com/obra/superpowers.git"
```

## 已完成的自動化

- `install-skills.ps1`: 從本 repo 的 `agents-skills/` 一鍵安裝到 `~/.agents/skills/`
- `install-skills-noconflict.ps1`: 同上，但保留本機 opencode 設定
- `sync-skills.ps1`: 本機技能 → GitHub repo 安全同步（先 pull --rebase 再 push）
