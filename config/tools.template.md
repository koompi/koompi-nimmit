# TOOLS.md — What {{AGENT_NAME}} Can Do

## System
- **Machine:** Auto-detected (Linux preferred)
- **OS:** Arch-based (KOOMPI OS)
- **Runtime:** Bun (never npm/yarn/pnpm), Node 22
- **Python:** uv (never pip), venv at ~/.venv/
- **Rust:** rustc 1.85+, cargo
- **Shell:** bash/zsh
- **Browser:** Chromium (headless via Xvfb), Playwright
- **Timezone:** Auto-detected

## AI Models

### Chat & Reasoning
- **Primary:** GLM-5 Turbo — daily driver, fast + cheap
- **Deep reasoning:** Gemini 3.1 Pro — complex analysis, strategy (alias: `gemini-pro`)
- **Fast frontier:** Gemini 3 Flash — latest Google thinking (alias: `gemini-flash`)
- **Budget/Vision:** Gemini 3.1 Flash-Lite — light tasks + image analysis (alias: `gemini-flash-lite`)
- **Fallbacks:** GPT-4.1, Claude Sonnet 4.6

### Image Generation
- **Default:** ZAI API (GLM-Image, CogView-4) — cost-effective
- **Nano Banana 2:** Gemini 3.1 Flash Image — high-efficiency visual creation
- **Nano Banana Pro:** Gemini 3 Pro Image — studio-quality 4K

### Audio, Video & Music
- **Voice input:** Gemini processes audio natively
- **TTS:** Gemini 2.5 Flash TTS (fast), Gemini 2.5 Pro TTS (high-fidelity)
- **Video generation:** Veo 3.1 — cinematic with synced audio
- **Music:** Lyria 3 Pro — full songs; Lyria 3 Clip — 30s clips

### Specialized
- **Deep Research:** autonomous multi-source research agent
- **Computer Use:** UI automation (click, type, navigate)
- **Embeddings:** multimodal (text, image, video, audio, PDF)

## Coding Agents

**Default: Copilot sub-agents first. Claude Code for complex tasks only.**

**Copilot Sub-agents** — default for all coding tasks
- Available: `github-copilot/claude-opus-4.6`, `github-copilot/gpt-5.4`, `github-copilot/gpt-5.3-codex`
- Use for: scripts, configs, features, content, docs, simple to medium complexity code
- Escalate to Claude Code if sub-agent fails twice

**Claude Code (ACP)** — reserved for complex tasks only
- Spawn with `sessions_spawn`, runtime: "acp", agentId: "claude"
- Use for: multi-file refactors, complex debugging, git workflows, architecture decisions
- **Always `--continue`** — never start fresh, session memory accumulates
- **Use `/compact` proactively** — every 15-20min on long tasks as save points
- **Use `/plan` (Shift+Tab)** — plan before coding on complex tasks
- **Use `--fork-session`** — branch conversations like git branches for exploration
- **Use `CLAUDE_CODE_COORDINATOR_MODE=1`** — for large multi-file refactors, Claude becomes pure orchestrator
- **Headless mode** — `claude -p "query" --output-format json` for automation/CI
- **Config files**: `~/.claude/CLAUDE.md` (global, every turn), `~/.claude/rules/*.md` (modular), `./CLAUDE.md` (project)

## Tech Stack

### Languages
- **TypeScript** — primary web language. Always strict mode, no `any`
- **Rust** — performance-critical tools, CLIs, system software. Edition 2024
- **Python** — scripts, automation, data processing

### Backend
- **Hono** — lightweight HTTP framework (Bun-native)
- **Next.js** — fullstack web apps (App Router, Server Components)
- **Axum** — Rust async web framework

### Frontend
- **React 19** — Server Components, hooks, Suspense
- **Next.js** — App Router, ISR, streaming
- **Tailwind CSS 4** — utility-first styling
- **shadcn/ui** — component library (copy-paste, not dep)
- **Radix UI** — accessible headless primitives
- **Zustand** — client state management
- **TanStack Query v5** — server state, caching, mutations
- **Lucide** — icons (never FontAwesome or Heroicons)

### Database & Storage
- **PostgreSQL** — primary relational database
- **Supabase** — PostgreSQL + Auth + Storage + Edge Functions (managed)
- **Drizzle ORM** — type-safe SQL queries
- **SQLite** — embedded only (CLI tools, edge devices)
- **Redis** — caching, sessions, job queues

### Dev Tools
- **Biome** — formatter + linter (replaces ESLint + Prettier)
- **Conventional Commits** — `feat:`, `fix:`, `test:`, `docs:`, `chore:`
- **gh** — GitHub CLI
- **just** — command runner
- **Playwright** — browser automation and E2E testing

## Document Creation
- **Word (.docx)** — python-docx
- **PDF** — pypdf
- **Presentations (.pptx)** — python-pptx
- **Spreadsheets (.xlsx)** — openpyxl

## Web & Research
- **web-search** — Google-grounded search
- **web-fetch** — read any URL as markdown
- **browser** — Chromium: navigate, click, screenshot, fill forms
- **deep research** — Gemini Deep Research for autonomous multi-source analysis

## GitHub
- Create repos, push code, open PRs, manage issues, check CI

## Scheduling
- **Cron** — scheduled tasks and reminders
- **Heartbeat** — periodic checks (configurable interval)

## Workspace Rules
- Code projects → `~/workspace/<project-name>/` (flat, no subdirectories)
- Brain files → `~/.openclaw/nimmit/`
- CLI binaries → `~/.local/bin/`
- Secrets → `~/.secrets/` (never in brain files or config)
