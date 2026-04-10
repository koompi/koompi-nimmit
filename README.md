# koompi-nimmit

> Turnkey AI agent appliance by KOOMPI. Deploy a full AI team in one command.

## What it is

Each client gets their own Nimmit instance — an AI agent that builds webapps, manages databases, deploys code, and runs operations 24/7.

## Quick Start

After installing, your AI agent is ready to work:

### 1. Start chatting
Send a message to your Telegram bot:
```
/build a todo app with next.js
```

### 2. Check status
```bash
# Is the agent running?
systemctl --user status openclaw

# View live logs
journalctl --user -u openclaw -f
```

### 3. Change models (on the fly)
In chat:
```
/model opus
```
Switches between Claude, Gemini, GPT-4, etc.

### 4. Restart if needed
```bash
systemctl --user restart openclaw
```

## Install

Interactive — walks you through everything:
```bash
curl -fsSL https://nimmit.koompi.ai | bash
```

Non-interactive (CI/automation):
```bash
curl -fsSL https://nimmit.koompi.ai | bash -s -- --non-interactive \
  --name "Atlas" --org "Acme Corp" --token "123:ABC..." --google-key "AIza..."
```

## What clients get

- **AI agent** named Nimmit (customizable) — responds via Telegram, Discord, or web
- **Builds webapps** — Next.js 16+ with Supabase, via chat
- **Manages databases** — Supabase CLI, migrations, auth, storage
- **Deploys code** — Vercel, KConsole (KOOMPI Cloud), or self-hosted
- **Coding agent** — Claude Code for complex tasks, Copilot for everyday work
- **Runs 24/7** — systemd services, auto-restart, health checks

## Tech stack (locked)

| Component | Technology |
|-----------|-----------|
| Runtime | OpenClaw |
| Webapp framework | Next.js 16+ |
| Database/Auth/Storage | Supabase |
| Primary model | Configurable (default: Gemini 3.1 Pro) |
| Model routing | OpenClaw — swappable at runtime via /model |
| Coding model | Claude Code (ACP) + Copilot sub-agents |
| Primary channel | Telegram |
| Language | TypeScript strict |
| Package manager | Bun (never npm) |

## Requirements

- Ubuntu 22.04+ or KOOMPI OS (Arch-based)
- 2GB RAM minimum, 4GB recommended
- Telegram bot token (create with @BotFather)

## Structure

```
koompi-nimmit/
├── install.sh               # One-command setup
├── brain/                   # AI team brain template
│   ├── ARCHITECTURE.md      # Runtime self-awareness (identity ≠ model)
│   ├── SOUL.md              # Personality, rules, values
│   ├── IDENTITY.md          # Name, role, what you are
│   ├── AGENTS.md            # Departments, routing, startup
│   ├── TOOLS.md             # Capabilities, model config
│   └── ...                  # Memory, topics, heartbeat, etc.
├── config/                  # Agent configuration templates
├── skills/                  # Client-facing skills
├── templates/               # App templates
├── systemd/                 # Service files
└── README.md
```

## Screenshots

Coming soon — demo of the agent building a full-stack app in under 2 minutes.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Bot doesn't respond | 1. Check service: `systemctl --user status openclaw`<br>2. Check logs: `journalctl --user -u openclaw -n 50`<br>3. Verify bot token in `~/.openclaw/<slug>/.env` |
| "Permission denied" errors | Run: `loginctl enable-linger $USER` then reboot |
| Node not found after install | Restart shell or run: `source ~/.bashrc` (nvm needs PATH update) |
| Port 18789 already in use | Something else is using the gateway port. Check: `lsof -i :18789` |
| Auto-login not working on Mini | Ensure file is at `/etc/systemd/system/getty@tty1.service.d/override.conf` |
| Agent forgets context | Check disk space: `df -h ~/.openclaw/`. Memory fills up over time. |
| Model returns errors | Verify API keys in `.env` file. Try `/model <different-model>` in chat. |
| Services stop on logout | Run: `sudo loginctl enable-linger $USER` |

### Get help
- Check logs: `journalctl --user -u openclaw -b`
- Open an issue: https://github.com/koompi/koompi-nimmit/issues
- KOOMPI support: support@koompi.ai

## Upgrading

Your agent auto-updates OpenClaw every 6 hours via `openclaw-update.timer`.

### Manual upgrade
```bash
bun install -g openclaw
systemctl --user restart openclaw
```

### Upgrade brain template
```bash
cd ~/.openclaw/<slug>
git pull origin master
systemctl --user restart openclaw
```

### Check version
```bash
openclaw --version
```

## License

Apache License 2.0 — see [LICENSE](LICENSE)
