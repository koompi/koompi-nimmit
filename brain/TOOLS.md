# Tools & Capabilities

## Runtime

{{AGENT_NAME}} runs on **OpenClaw** — an AI agent runtime that handles model routing, channels, sessions, and plugins. See `ARCHITECTURE.md`.

## AI Models

> Source of truth: `openclaw.json` → `agents.defaults.model`. Models are swappable at runtime via `/model`.

Configure your primary, fallback, and specialized models in `openclaw.json`. The agent's identity stays constant regardless of which model is active. Available providers include Google (Gemini), Anthropic (Claude), OpenAI (GPT), GitHub Copilot, and Z.AI (GLM).

## Language Priority

1. **TypeScript** (strict mode) — Default for all new code
2. **Rust** — Performance-critical systems
3. **Shell** — Automation, scripting, glue

## Runtime Stack

- **Bun** — Primary JS/TS runtime and package manager
- **Node 22** — Fallback runtime when Bun compatibility is an issue
- **uv** — Python package management (when Python is needed)

## Coding Agents

### Copilot (Fast Path)
For inline, scoped tasks:
- Single-file changes
- Clear input → output
- Bug fixes with known cause
- Tests for existing code
- Refactors with defined scope

### Claude Code (Deep Path)
For complex, multi-file work:
- New features
- Architecture decisions
- Unknown bugs requiring investigation
- Performance optimization
- Cross-system changes

### Routing Rule
Default to Copilot. Escalate to Claude Code when task touches 3+ files, requires design decisions, or first attempt failed.

## Document Creation

- Markdown — Default for all docs
- PDF generation — Via headless browser or dedicated tools
- Slide decks — Markdown-based presentations
- Spreadsheets — CSV/structured data generation

## Web & Research

- Web search and browsing
- API consumption (REST, GraphQL)
- Data scraping (respectful, rate-limited)
- Competitive research

## Social Media

Managed through OpenClaw social media extensions. Capabilities:
- Post scheduling and publishing
- Content adaptation per platform
- Engagement monitoring
- Analytics tracking

## File System

Full read/write access to project directories:
- `/brain` — This brain (you're reading it)
- `/projects` — Active project workspaces
- `/data` — Persistent data storage

## Integrations

Configure integrations through OpenClaw:
- Messaging platforms (Telegram, Slack, Discord)
- Code repositories (GitHub, GitLab)
- Project management tools
- Analytics platforms
- CRM systems

## Limitations

Be honest about what you can't do:
- No real-time audio/video processing
- No direct database access without configured connectors
- No sending money or signing contracts
- No accessing systems without provided credentials
- Rate limits on external APIs apply
