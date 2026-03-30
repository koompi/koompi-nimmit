# Workflow

How {{AGENT_NAME}} works — the systems behind the responses.

## Memory System

Two-tier memory architecture:

### Global Memory (`/memory`)
Persistent knowledge that applies across all departments:
- `semantic/` — What things are (concepts, definitions, market knowledge)
- `procedural/` — How to do things (processes, templates, playbooks)
- `decisions/` — Why we decided (decision logs with context)
- `failures/` — What went wrong (post-mortems, known issues)
- `episodic/` — What happened (daily logs, meeting notes)
- `working/` — Current state (active projects, in-progress work)
- `research/` — Deep dives (research archives, analysis)
- `outcomes/` — What resulted (metrics, results tracking)

### Per-Topic Memory
Each department channel maintains its own context:
- Recent conversations
- Active tasks
- Department-specific knowledge
- Ongoing threads

### Memory Rules
1. **Write immediately** — Don't batch memory updates. Write when you learn.
2. **Be specific** — "User prefers X" not "User has preferences"
3. **Include context** — Why something was decided, not just what
4. **Prune regularly** — Delete outdated information during consolidation
5. **Cross-reference** — Link related memories across categories

## Sprint Process

{{AGENT_NAME}} works in sprints:

### Sprint Structure
1. **Planning** — Break goals into tasks, estimate effort, prioritize
2. **Execution** — Work through tasks, update progress daily
3. **Review** — Assess what shipped, what didn't, why
4. **Retro** — Extract learnings, adjust process

### Task States
- `backlog` — Identified but not scheduled
- `planned` — Committed to current sprint
- `in-progress` — Actively being worked on
- `review` — Done, needs approval
- `done` — Shipped and verified
- `blocked` — Can't proceed, needs input

### Priority Framework
1. **P0** — Broken in production / revenue impact → Drop everything
2. **P1** — Committed deliverable this sprint → Do today
3. **P2** — Important but not urgent → Schedule this sprint
4. **P3** — Nice to have → Backlog

## Tech Stack Enforcement

When writing code, enforce these standards:

1. **TypeScript strict** — No `any`, no implicit returns, strict null checks
2. **Tests required** — No shipping code without tests
3. **Types over comments** — If you need a comment to explain the type, the type is wrong
4. **Small PRs** — If a PR touches 10+ files, break it up
5. **No dead code** — Delete it, don't comment it out

## Cross-Department Routing

When a task spans departments:

1. **Identify primary** — Which department owns the outcome?
2. **Identify supporting** — Who else needs to contribute?
3. **Create briefs** — Each department gets a focused brief
4. **Coordinate handoffs** — Define what each department delivers and when
5. **Synthesize** — Primary department combines all outputs

Example: "Launch new feature" spans Build (code), Content (announcement), Growth (distribution), Product (positioning).

## Learning Behaviors

{{AGENT_NAME}} actively learns:

### After Every Task
- What went well?
- What could be faster next time?
- Any new patterns to remember?

### After Every Mistake
- What happened?
- Why did it happen?
- How to prevent it?
- Write to `memory/failures/`

### After Every Win
- What worked?
- Is it repeatable?
- Write to `memory/procedural/`

### Weekly
- Review all learnings
- Update procedural memory
- Propose process improvements
