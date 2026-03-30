#!/usr/bin/env bash
set -euo pipefail

# configure.sh — Interactive setup for koompi-nimmit
# Run after install.sh to configure or reconfigure

INSTALL_DIR="${NIMMIT_HOME:-$HOME/.nimmit}"
CONFIG_FILE="$INSTALL_DIR/openclaw.json"
ENV_FILE="$INSTALL_DIR/.env"

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
info() { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()   { echo -e "${GREEN}[ OK ]${NC}  $*"; }

echo -e "\n${BOLD}${CYAN}🦅 koompi-nimmit configuration${NC}\n"

# Load current config if exists
if [[ -f "$CONFIG_FILE" ]]; then
    CURRENT_NAME=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)
    echo -e "Current agent: ${BOLD}${CURRENT_NAME:-unknown}${NC}"
fi
if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE" 2>/dev/null || true
    [[ -n "${TELEGRAM_BOT_TOKEN:-}" ]] && echo -e "Telegram:    ${BOLD}configured${NC}"
    [[ -n "${ZAI_API_KEY:-}" ]] && echo -e "ZAI:         ${BOLD}configured${NC}"
fi
echo ""

# ─── Agent Name ────────────────────────────────────────────────────────
read -rp "Agent name [${CURRENT_NAME:-Nimmit}]: " NEW_NAME
AGENT_NAME="${NEW_NAME:-${CURRENT_NAME:-Nimmit}}"

# ─── Telegram Token ─────────────────────────────────────────────────────
CURRENT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
if [[ -n "$CURRENT_TOKEN" ]]; then
    read -rp "Telegram bot token [keep current]: " NEW_TOKEN
    BOT_TOKEN="${NEW_TOKEN:-$CURRENT_TOKEN}"
else
    read -rp "Telegram bot token (from @BotFather): " BOT_TOKEN
fi

# ─── ZAI API Key ───────────────────────────────────────────────────────
CURRENT_ZAI="${ZAI_API_KEY:-}"
if [[ -n "$CURRENT_ZAI" ]]; then
    read -rp "ZAI API key [keep current]: " NEW_ZAI
    ZAI_KEY="${NEW_ZAI:-$CURRENT_ZAI}"
else
    read -rp "ZAI API key: " ZAI_KEY
fi

# ─── Claude Code Token ─────────────────────────────────────────────────
CURRENT_CLAUDE="${CLAUDE_CODE_TOKEN:-}"
if [[ -n "$CURRENT_CLAUDE" ]]; then
    read -rp "Claude Code token [keep current]: " NEW_CLAUDE
    CLAUDE_TOKEN="${NEW_CLAUDE:-$CURRENT_CLAUDE}"
else
    read -rp "Claude Code token (optional, press Enter to skip): " CLAUDE_TOKEN
fi

# ─── Telegram Allowed IDs ─────────────────────────────────────────────
echo ""
info "Add Telegram user IDs that can interact with ${AGENT_NAME}."
info "Find your ID: send /start to @userinfobot on Telegram"
echo ""
ALLOWED_IDS="["
FIRST=true
while true; do
    read -rp "User ID (or press Enter to finish): " TG_UID
    [[ -z "$TG_UID" ]] && break
    if [[ "$FIRST" == true ]]; then
        ALLOWED_IDS+="\"${TG_UID}\""
        FIRST=false
    else
        ALLOWED_IDS+=", \"${TG_UID}\""
    fi
done
ALLOWED_IDS+="]"

# ─── Deploy Target ─────────────────────────────────────────────────────
echo ""
info "Default deploy target:"
echo "  1) Vercel"
echo "  2) KConsole (KOOMPI Cloud)"
echo "  3) Self-hosted"
read -rp "Choice [1]: " DEPLOY_CHOICE
case "${DEPLOY_CHOICE:-1}" in
    2) DEPLOY_TARGET="kconsole" ;;
    3) DEPLOY_TARGET="self-hosted" ;;
    *) DEPLOY_TARGET="vercel" ;;
esac

# ─── Write env file ────────────────────────────────────────────────────
cat > "$ENV_FILE" <<ENVFILE
# koompi-nimmit secrets — NEVER commit this file
TELEGRAM_BOT_TOKEN=${BOT_TOKEN}
ZAI_API_KEY=${ZAI_KEY}
CLAUDE_CODE_TOKEN=${CLAUDE_TOKEN:-}
DEPLOY_TARGET=${DEPLOY_TARGET}
ALLOWED_TELEGRAM_IDS=${ALLOWED_IDS}
ENVFILE
chmod 600 "$ENV_FILE"
ok "Secrets written to ${ENV_FILE}"

# ─── Update openclaw.json ──────────────────────────────────────────────
if [[ -f "$CONFIG_FILE" ]]; then
    # Use simple sed to update values
    sed -i "s/\"botToken\".*\"[^\"]*\"/\"botToken\": \"${BOT_TOKEN}\"/" "$CONFIG_FILE"
    sed -i "s/\"allowFrom\".*\[.*\]/\"allowFrom\": ${ALLOWED_IDS}/" "$CONFIG_FILE"
    ok "Config updated"
fi

# ─── Update brain identity ─────────────────────────────────────────────
BRAIN_DIR="$INSTALL_DIR/brain"
if [[ -f "$BRAIN_DIR/IDENTITY.md" ]]; then
    sed -i "s/- \*\*Name:\*\* .*/- **Name:** ${AGENT_NAME}/" "$BRAIN_DIR/IDENTITY.md"
    ok "IDENTITY.md updated"
fi
if [[ -f "$BRAIN_DIR/SOUL.md" ]]; then
    sed -i "s/{{AGENT_NAME}}/${AGENT_NAME}/g" "$BRAIN_DIR/SOUL.md"
    ok "SOUL.md updated"
fi

# ─── Restart ────────────────────────────────────────────────────────────
echo ""
read -rp "Restart ${AGENT_NAME} now? [Y/n]: " RESTART
if [[ "${RESTART:-Y}" =~ ^[Yy] ]]; then
    systemctl --user restart openclaw 2>/dev/null && ok "${AGENT_NAME} restarted" || warn "Could not restart. Run manually: systemctl --user restart openclaw"
fi

echo ""
ok "Configuration complete!"
info "Agent: ${AGENT_NAME}"
info "Deploy: ${DEPLOY_TARGET}"
info "Telegram users: ${ALLOWED_IDS}"
