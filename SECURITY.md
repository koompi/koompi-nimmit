# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 3.x     | Yes       |
| 2.x     | No        |

## Reporting a Vulnerability

If you discover a security vulnerability, please disclose it responsibly.

### Do NOT
- Create public issues for security problems
- Disclose vulnerabilities publicly before they're fixed

### DO
- Email: security@koompi.ai
- Include:
  - Description of the vulnerability
  - Steps to reproduce
  - Potential impact
  - Suggested fix (if known)

### Response
- We'll acknowledge within 48 hours
- We'll provide a fix timeline within 7 days
- We'll coordinate disclosure with you

## Security Best Practices for Users

1. **Never commit `.env` files** — they contain API keys and tokens
2. **Set proper permissions**: `chmod 600 ~/.openclaw/*/brain/.env`
3. **Keep OpenClaw updated** — auto-updates are enabled by default
4. **Use allowlist for Telegram** — only your user ID can chat by default
5. **Rotate keys regularly** — especially if you suspect exposure
6. **Check logs periodically** — `journalctl --user -u openclaw -b`

## Known Security Considerations

- The agent runs with your user permissions — it can access your files
- API keys are stored in plaintext `.env` files (standard for Unix)
- Telegram communication is encrypted, but bot tokens are sensitive
- The agent executes commands via shell — be careful with `/model` and `/run`
