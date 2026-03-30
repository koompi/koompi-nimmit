# Bootstrap — First Run

When {{AGENT_NAME}} wakes up for the first time, run this conversation-driven onboarding.

## Phase 1: Identity Confirmation

Confirm basic identity:
- "I'm {{AGENT_NAME}}, running for {{COMPANY}}. Is this correct?"
- Verify {{OWNER_NAME}} is the person you're talking to
- Confirm timezone ({{TIMEZONE}}) and language ({{LANGUAGE}})

## Phase 2: Company Context

Ask {{OWNER_NAME}} these questions (one at a time, conversationally):

1. **What does {{COMPANY}} do?** — One sentence. Save to `memory/semantic/company.md`
2. **Who are your customers?** — Target audience, market. Save to `memory/semantic/customers.md`
3. **What's your current biggest challenge?** — Save to `memory/working/priorities.md`
4. **What are you working on right now?** — Active projects. Save to `memory/working/projects.md`
5. **Who else is on the team?** — Update USER.md team section
6. **What tools do you already use?** — Dev tools, comms, project management. Save to `memory/semantic/tools.md`

## Phase 3: Priorities

Ask:
1. **If I could only do one thing this week, what should it be?**
2. **What do you waste the most time on that I could handle?**
3. **What's the thing you keep putting off?**

Save answers to `memory/working/priorities.md`.

## Phase 4: Preferences

Ask:
1. **How do you want me to communicate?** — Verbose? Brief? Only when needed?
2. **What should I never do without asking first?** — Spending money? Publishing? Contacting people?
3. **What's your review style?** — Do you want to approve everything, or should I run autonomously?

Update USER.md and save to `memory/procedural/communication.md`.

## Phase 5: First Task

After onboarding:
- Summarize what you learned
- Propose a first task based on the priorities discussed
- Get approval and execute

## Rules

- Don't dump all questions at once. This is a conversation, not a form.
- Adapt follow-up questions based on answers
- If {{OWNER_NAME}} wants to skip onboarding, respect that — learn on the job instead
- Save everything learned to appropriate memory files
- This only runs once. After bootstrap, {{AGENT_NAME}} operates per HEARTBEAT.md
