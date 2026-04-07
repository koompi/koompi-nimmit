# Nimmit — Your AI Chief of Staff

> One install. One AI worker. Every leader deserves one.

Built on [OpenClaw](https://github.com/openclaw/openclaw). Shipped by KOOMPI.

## The Product

Nimmit isn't a chatbot. It's an **AI worker** you hire for your organization:

- **For the Minister** — morning briefing at 7 AM, overnight intelligence, decision support, report drafting. Know what matters before you walk into the office.
- **For the CEO** — metrics that matter, risks to flag, suggested actions. Never be surprised by something you should have known.
- **For the school director** — student alerts, exam prep, parent communication, teacher schedules. Run the school without drowning in admin.
- **For the shop owner** — social media, customer responses, inventory alerts, daily sales reports. Your business, always on top of it.

## How It Works

```
Install Nimmit → Choose your role → Get your AI chief of staff
```

One command. Five minutes. Running as a service.

## Install

```bash
curl -fsSL https://nimmit.koompi.ai/install | bash
```

Or for development:
```bash
bun run onboarding/nimmit-setup.ts
```

## Skill Packs

| Pack | Who It's For | What It Does |
|------|-------------|-------------|
| 👔 **Executive** | Ministers, CEOs, C-level, leaders | Morning briefings, decision support, info gathering, report drafting, weekly reviews |
| 🏫 **Education** | School directors, principals | Lesson planning (MoEYS), student management, exams, Khmer content, parent comms |
| 🏛️ **Government** | Ministry staff, departments | Formal documents (រដាធិកម្ម), meeting minutes, reporting, procurement |
| 🏪 **SME** | Business owners, managers | Social media, customer service, inventory, marketing, financials |

## The Morning Briefing

Every Nimmit instance generates a **daily morning briefing**:

- 🔥 Today's priorities (top 3, with what decisions are needed)
- 📬 What happened overnight (only what matters)
- 📊 Key metrics and changes
- ⚠️ Risks and blockers
- 💡 Suggested actions
- 📅 What's coming in the next 3 days

The leader wakes up informed. Not overwhelmed. Ready to lead.

## Tech Stack

- **Runtime:** OpenClaw (open-source AI gateway)
- **Brain:** Workspace (SOUL.md, IDENTITY.md, MEMORY.md, skills)
- **Skills:** Modular domain packs (education, government, sme, executive)
- **Install:** Bash (one command), TypeScript (interactive)
- **Service:** systemd (auto-start, auto-restart)
- **Hardware:** KOOMPI Mini (perfect fit), any Linux machine

## Deployment

```bash
# On a fresh KOOMPI Mini:
bash install.sh

# Answers: org name → role → language → Telegram token
# Result: Nimmit running as a service, morning briefings ready
```

## Structure

```
nimmit-product/
├── install.sh              # One-command installer
├── onboarding/
│   └── nimmit-setup.ts     # Interactive CLI setup
├── skill-packs/
│   ├── executive/SKILL.md  # AI Chief of Staff
│   ├── education/SKILL.md  # School operations
│   ├── government/SKILL.md # Government workflows
│   └── sme/SKILL.md        # Business operations
└── README.md
```

## License

Proprietary — KOOMPI / SmallWorld
