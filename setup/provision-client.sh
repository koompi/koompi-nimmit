#!/usr/bin/env bash
set -euo pipefail

# provision-client.sh — KOOMPI internal: spin up a new client instance
# Usage: bash provision-client.sh --name "ClientName" --token "BOT_TOKEN" --vps-ip "1.2.3.4"

REPO="rithythul/koompi-nimmit"
BRANCH="main"
INSTALL_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.sh"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
info()  { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[ OK ]${NC}  $*"; }
die()   { echo -e "${RED}[ERR]${NC}   $*" >&2; exit 1; }
step()  { echo -e "\n${BOLD}${CYAN}▸${NC} ${BOLD}$*${NC}"; }

# ─── Args ──────────────────────────────────────────────────────────────

CLIENT_NAME=""
BOT_TOKEN=""
ZAI_KEY=""
VPS_IP=""
VPS_USER="root"
VPS_SSH_KEY=""
IS_MINI=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --name) CLIENT_NAME="$2"; shift 2 ;;
        --token) BOT_TOKEN="$2"; shift 2 ;;
        --zai-key) ZAI_KEY="$2"; shift 2 ;;
        --vps-ip) VPS_IP="$2"; shift 2 ;;
        --vps-user) VPS_USER="$2"; shift 2 ;;
        --ssh-key) VPS_SSH_KEY="$2"; shift 2 ;;
        --mini) IS_MINI=true; shift ;;
        -h|--help)
            cat <<HELP
Usage: bash provision-client.sh [OPTIONS]

KOOMPI internal tool: provision a new koompi-nimmit client instance.

Options:
  --name NAME         Client/agent name (required)
  --token TOKEN       Telegram bot token (required)
  --zai-key KEY       ZAI API key (required)
  --vps-ip IP         Target VPS IP (required)
  --vps-user USER     SSH user (default: root)
  --ssh-key KEY       SSH key file (default: ~/.ssh/id_rsa)
  --mini              Target is KOOMPI Mini (not VPS)

Examples:
  bash provision-client.sh --name "Atlas" --token "123:ABC" --zai-key "zai_xxx" --vps-ip "1.2.3.4"
  bash provision-client.sh --name "Nimmit" --token "123:ABC" --zai-key "zai_xxx" --mini --vps-user koompi
HELP
            exit 0 ;;
        *) die "Unknown option: $1" ;;
    esac
done

[[ -z "$CLIENT_NAME" ]] && die "Client name required (--name)"
[[ -z "$BOT_TOKEN" ]] && die "Telegram token required (--token)"
[[ -z "$ZAI_KEY" ]] && die "ZAI API key required (--zai-key)"
[[ -z "$VPS_IP" ]] && die "VPS IP required (--vps-ip)"

VPS_SSH_KEY="${VPS_SSH_KEY:-$HOME/.ssh/id_rsa}"
SSH_OPTS="-o StrictHostKeyChecking=no -o ConnectTimeout=10"
[[ -f "$VPS_SSH_KEY" ]] && SSH_OPTS+=" -i $VPS_SSH_KEY"

MINI_FLAG=""
[[ "$IS_MINI" == true ]] && MINI_FLAG="--mini"

echo -e "\n${BOLD}${GREEN}🦅 Provisioning koompi-nimmit for ${CLIENT_NAME}${NC}"
echo -e "${BOLD}   Target: ${VPS_USER}@${VPS_IP}${NC}\n"

# ─── SSH connectivity ──────────────────────────────────────────────────

step "Testing SSH connection..."
ssh $SSH_OPTS "${VPS_USER}@${VPS_IP}" "echo 'Connected'" || die "Cannot SSH to ${VPS_USER}@${VPS_IP}"
ok "SSH connection works"

# ─── Run installer ─────────────────────────────────────────────────────

step "Running koompi-nimmit installer..."

ssh $SSH_OPTS "${VPS_USER}@${VPS_IP}" bash -s << REMOTE_SCRIPT
set -euo pipefail

# Download and run installer
curl -fsSL "${INSTALL_URL}" -o /tmp/koompi-nimmit-install.sh
chmod +x /tmp/koompi-nimmit-install.sh

# Run with all credentials
bash /tmp/koompi-nimmit-install.sh \
    --name "${CLIENT_NAME}" \
    --org "${CLIENT_NAME}" \
    --token "${BOT_TOKEN}" \
    --zai-key "${ZAI_KEY}" \
    --channel telegram \
    ${MINI_FLAG}

# Clean up
rm /tmp/koompi-nimmit-install.sh
REMOTE_SCRIPT

ok "Installation complete"

# ─── Verify ────────────────────────────────────────────────────────────

step "Verifying installation..."

ssh $SSH_OPTS "${VPS_USER}@${VPS_IP}" << REMOTE_CHECK
set -euo pipefail

# Check services
if systemctl --user is-active openclaw &>/dev/null; then
    echo "✅ OpenClaw gateway: running"
else
    echo "❌ OpenClaw gateway: not running"
fi

if systemctl --user is-active xvfb &>/dev/null; then
    echo "✅ Xvfb: running"
else
    echo "⚠️  Xvfb: not running (optional)"
fi

if systemctl --user is-active nimmit-watchdog.timer &>/dev/null; then
    echo "✅ Watchdog timer: active"
else
    echo "⚠️  Watchdog timer: not active"
fi

# Check config
if [[ -f ~/.nimmit/openclaw.json ]]; then
    echo "✅ openclaw.json: exists"
else
    echo "❌ openclaw.json: missing"
fi

if [[ -f ~/.nimmit/.env ]]; then
    echo "✅ .env: exists"
else
    echo "❌ .env: missing"
fi
REMOTE_CHECK

# ─── Done ──────────────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✅ ${CLIENT_NAME} provisioned on ${VPS_IP}${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
info "SSH:       ssh ${VPS_USER}@${VPS_IP}"
info "Config:    ~/.nimmit/openclaw.json"
info "Secrets:   ~/.nimmit/.env"
info "Logs:      journalctl --user -u openclaw -f"
info "Restart:   systemctl --user restart openclaw"
echo ""
