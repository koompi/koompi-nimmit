#!/usr/bin/env bash
set -euo pipefail

# Nimmit Installer — One-command setup for KOOMPI Mini
# Usage: curl -fsSL https://nimmit.koompi.ai/install | bash
# Or:   bash install.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}🦅${NC} $1"; }
ok()    { echo -e "${GREEN}✅${NC} $1"; }
warn()  { echo -e "${YELLOW}⚠️${NC} $1"; }
fail()  { echo -e "${RED}❌${NC} $1"; exit 1; }

# ─── Preflight ───
info "Nimmit Installer — KOOMPI AI Team Setup"
echo ""

if [[ $EUID -eq 0 ]]; then
  fail "Don't run as root. Run as your user."
fi

# Check OS
if ! command -v pacman &>/dev/null; then
  warn "Not Arch-based. Best experience on KOOMPI OS (Arch). Continuing anyway..."
fi

# Check minimum RAM (2GB)
TOTAL_MEM=$(awk '/MemTotal/ {printf "%d", $2/1024}' /proc/meminfo 2>/dev/null || echo 4096)
if [[ $TOTAL_MEM -lt 2000 ]]; then
  warn "Less than 2GB RAM detected. Some features may be slow."
fi

echo ""
info "Step 1/6: Installing system dependencies..."

# ─── System deps ───
if command -v pacman &>/dev/null; then
  sudo pacman -S --noconfirm --needed curl git base-devel chromium 2>/dev/null
else
  warn "Install curl, git, chromium manually if not present."
fi

echo ""
info "Step 2/6: Installing Bun..."

if ! command -v bun &>/dev/null; then
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  ok "Bun installed"
else
  ok "Bun already installed ($(bun --version))"
fi

echo ""
info "Step 3/6: Installing OpenClaw..."

if command -v openclaw &>/dev/null; then
  ok "OpenClaw already installed ($(openclaw --version 2>/dev/null | head -1))"
else
  bun install -g openclaw 2>&1 | tail -1
  ok "OpenClaw installed"
fi

echo ""
info "Step 4/6: Configuring Nimmit workspace..."

AGENT_NAME="nimmit"
WORKSPACE="$HOME/.openclaw/agents/$AGENT_NAME/workspace"
mkdir -p "$WORKSPACE/skills"
mkdir -p "$WORKSPACE/tasks"
mkdir -p "$WORKSPACE/memory"

# Register nimmit as a named agent (skip if already exists)
if openclaw agents list --json 2>/dev/null | grep -q "\"$AGENT_NAME\""; then
  ok "Agent '$AGENT_NAME' already registered"
else
  openclaw agents add --name "$AGENT_NAME" --workspace "$WORKSPACE" --non-interactive 2>/dev/null \
    && ok "Agent '$AGENT_NAME' registered" \
    || warn "Could not register agent via CLI. Run manually: openclaw agents add --name $AGENT_NAME --workspace $WORKSPACE"
fi

# ─── Select industry ───
echo ""
info "Step 5/6: Select your industry"
echo ""
echo "  1) 👔 Executive (C-level, Minister, Leader)"
echo "  2) 🏫 Education (School)"
echo "  3) 🏛️ Government (Ministry)"
echo "  4) 🏪 SME (Small/Medium Business)"
echo "  5) 🌐 General"
echo ""
read -rp "Choose [1-5]: " INDUSTRY_CHOICE

case $INDUSTRY_CHOICE in
  1) INDUSTRY="executive" ;;
  2) INDUSTRY="education" ;;
  3) INDUSTRY="government" ;;
  4) INDUSTRY="sme" ;;
  5) INDUSTRY="general" ;;
  *) INDUSTRY="general" ;;
esac

# ─── Org name ───
echo ""
read -rp "Organization name: " ORG_NAME
ORG_NAME="${ORG_NAME:-My Organization}"

# ─── Language ───
echo ""
echo "  1) ភាសាខ្មែរ (Khmer)"
echo "  2) English"
echo "  3) Both"
echo ""
read -rp "Primary language [1-3]: " LANG_CHOICE

case $LANG_CHOICE in
  1) LANGUAGE="khmer"; LANG_DISPLAY="ភាសាខ្មែរ" ;;
  2) LANGUAGE="english"; LANG_DISPLAY="English" ;;
  3) LANGUAGE="both"; LANG_DISPLAY="Khmer + English" ;;
  *) LANGUAGE="khmer"; LANG_DISPLAY="ភាសាខ្មែរ" ;;
esac

# ─── Telegram ───
echo ""
read -rp "Telegram bot token (leave blank to skip): " TG_TOKEN

if [[ -n "$TG_TOKEN" ]]; then
  mkdir -p "$HOME/.openclaw"
  if [[ -f "$HOME/.openclaw/.env" ]]; then
    grep -q "TELEGRAM_BOT_TOKEN" "$HOME/.openclaw/.env" && \
      sed -i "s/TELEGRAM_BOT_TOKEN=.*/TELEGRAM_BOT_TOKEN=\"$TG_TOKEN\"/" "$HOME/.openclaw/.env" || \
      echo "TELEGRAM_BOT_TOKEN=\"$TG_TOKEN\"" >> "$HOME/.openclaw/.env"
  else
    echo "TELEGRAM_BOT_TOKEN=\"$TG_TOKEN\"" > "$HOME/.openclaw/.env"
  fi
  # Restrict .env permissions
  chmod 600 "$HOME/.openclaw/.env"
  
  openclaw config set channels.telegram.enabled true 2>/dev/null || true
  ok "Telegram configured"
else
  warn "No Telegram token. Configure later with: openclaw configure"
fi

# ─── Install skill pack ───
if [[ "$INDUSTRY" != "general" ]]; then
  PACK_URL="https://nimmit.koompi.ai/skill-packs/${INDUSTRY}/SKILL.md"
  PACK_DIR="$WORKSPACE/skills/nimmit-${INDUSTRY}"
  mkdir -p "$PACK_DIR"
  
  if curl -fsSL "$PACK_URL" -o "$PACK_DIR/SKILL.md" 2>/dev/null; then
    ok "${INDUSTRY} skill pack installed"
  else
    warn "Could not download skill pack. Install manually to $PACK_DIR"
  fi
fi

# ─── Generate workspace files ───
info "Generating workspace files..."

# IDENTITY.md
cat > "$WORKSPACE/IDENTITY.md" << EOF
# IDENTITY.md

- **Name:** Nimmit
- **Organization:** ${ORG_NAME}
- **Industry:** ${INDUSTRY}
- **Language:** ${LANG_DISPLAY}
- **Tone:** $(
  case $INDUSTRY in
    executive) echo "Direct, concise, honest — a chief of staff who tells you what you need to hear" ;;
    education) echo "ភាសាធម្មតា — professional but approachable" ;;
    government) echo "រដាធិកម្ម — formal and precise" ;;
    sme) echo "ភាសាធម្មតា — friendly and practical" ;;
    *) echo "Clear, concise, professional" ;;
  esac
)

This Nimmit instance is configured for ${ORG_NAME}.
EOF

# SOUL.md
cat > "$WORKSPACE/SOUL.md" << EOF
# SOUL.md — ${ORG_NAME}

$(
  case $INDUSTRY in
    executive) echo "You are the AI chief of staff. Make this leader more effective with briefings, research, decision support, and honest counsel. Never hedge. Never sugarcoat. Lead with what matters." ;;
    education) echo "You are an AI team member for a Cambodian school. Help with teaching, administration, and parent communication." ;;
    government) echo "You are an AI team member for a Cambodian government ministry. Help with formal documents, reporting, and meeting preparation." ;;
    sme) echo "You are an AI team member for a Cambodian business. Help with sales, marketing, customer service, and daily operations." ;;
    *) echo "You are an AI team member. Help with research, writing, analysis, and coordination." ;;
  esac
)

## Core Rules
- Be concise. 1-3 sentences by default.
- Use ${LANG_DISPLAY} as the primary language.
- Do, don't narrate. Execute tasks, confirm briefly.
- Ask before acting externally.
- Keep private information private.
EOF

# HEARTBEAT.md
cat > "$WORKSPACE/HEARTBEAT.md" << EOF
# HEARTBEAT.md

## Checks (every heartbeat)
- Read tasks/TASKS.md — any active task due? Do it.
- Any blocked task > 2 days? Flag it.
$(
  case $INDUSTRY in
    executive) echo "- Prepare daily morning briefing at 7:00 AM\n- Gather overnight updates and flag what needs attention\n- Check upcoming meetings and prepare one-pagers" ;;
    education) echo "- Check upcoming school events and exam dates\n- Flag students with attendance concerns" ;;
    government) echo "- Check pending report deadlines\n- Flag overdue document requests" ;;
    sme) echo "- Check inventory alerts (low stock)\n- Check scheduled social media posts" ;;
    *) echo "- General inbox and task check" ;;
  esac
)

## Daily Brief (once per day, before 8am)
- Review completed tasks
- Flag today's priorities

## Rules
- Nothing to report → HEARTBEAT_OK
- Late night (23:00–08:00): skip unless urgent
EOF

# TASKS.md
TODAY=$(date +%Y-%m-%d)
D1=$(date -d "+1 day" +%Y-%m-%d 2>/dev/null || date -v+1d +%Y-%m-%d 2>/dev/null || echo "${TODAY}")
D2=$(date -d "+2 days" +%Y-%m-%d 2>/dev/null || date -v+2d +%Y-%m-%d 2>/dev/null || echo "${TODAY}")
D7=$(date -d "+7 days" +%Y-%m-%d 2>/dev/null || date -v+7d +%Y-%m-%d 2>/dev/null || echo "${TODAY}")
cat > "$WORKSPACE/TASKS.md" << EOF
# TASKS.md — ${ORG_NAME} Onboarding

| ID | Task | Status | Due |
|----|------|--------|------|
| O-001 | Verify Nimmit is responding | active | ${TODAY} |
| O-002 | Complete organization profile | active | ${TODAY} |
| O-003 | Add team members to allowFrom | active | ${D1} |
| O-004 | Set up first workflow | active | ${D2} |
| O-005 | Receive first morning briefing | active | ${D2} |
| O-006 | Review and customize HEARTBEAT.md | active | ${D7} |
EOF

# AGENTS.md (minimal)
cat > "$WORKSPACE/AGENTS.md" << EOF
# AGENTS.md

## Session Startup
1. Read SOUL.md, IDENTITY.md, USER.md
2. Check memory/ for recent context
3. Read tasks/TASKS.md

## Memory
- Daily notes: memory/YYYY-MM-DD.md
- Long-term: MEMORY.md

## Red Lines
- Don't exfiltrate private data
- trash > rm
- Ask before external actions
EOF

# MEMORY.md (minimal)
cat > "$WORKSPACE/MEMORY.md" << EOF
# MEMORY.md — ${ORG_NAME}

## Quick Reference
- Organization: ${ORG_NAME}
- Industry: ${INDUSTRY}
- Language: ${LANG_DISPLAY}
- Installed: ${TODAY}
EOF

ok "Workspace files generated"

# ─── Set up systemd service ───
echo ""
info "Step 6/6: Setting up Nimmit service..."

SERVICE_FILE="$HOME/.config/systemd/user/openclaw-gateway.service"
mkdir -p "$(dirname "$SERVICE_FILE")"

cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Nimmit AI Gateway (OpenClaw)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
EnvironmentFile=$HOME/.openclaw/.env
ExecStart=$(which bun) run $(which openclaw) gateway
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload 2>/dev/null || warn "Could not reload systemd"
systemctl --user enable openclaw-gateway 2>/dev/null || warn "Could not enable service"

ok "Service configured"

# ─── Done ───
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ${GREEN}🦅 Nimmit is ready for ${ORG_NAME}!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  📂 Workspace:   $WORKSPACE"
echo "  🦅 Agent:       $AGENT_NAME"
echo "  🏭 Industry:    $INDUSTRY"
echo "  🌐 Language:    $LANG_DISPLAY"
echo ""
echo "  To start Nimmit:"
echo "    openclaw gateway --force"
echo ""
echo "  Or start as a background service:"
echo "    systemctl --user start openclaw-gateway"
echo ""
if [[ -n "$TG_TOKEN" ]]; then
  echo "  📱 Telegram:   Configured (test by messaging your bot)"
  echo ""
fi
echo "  ⚠️  IMPORTANT: Enable BotFather Group Privacy OFF if using groups"
echo ""
