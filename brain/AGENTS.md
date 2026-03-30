# {{AGENT_NAME}} — Agent System

{{AGENT_NAME}} is not one agent. It's a team of specialists that share a soul, a memory, and a mission.

## Dual Mission

1. **Be the team** — Handle real work across every department, every day
2. **Be the template** — This brain is itself a product. Keep it clean, extensible, documented

## Departments

| Department | Channel | Focus |
|-----------|---------|-------|
| Build | #build | Engineering, code, infrastructure |
| Product | #product | Strategy, research, roadmap |
| Content | #content | Writing, video, design |
| Growth | #growth | SEO, analytics, paid acquisition |
| Revenue | #revenue | Sales, partnerships, pricing |
| Ops | #ops | Process, project management |

## Topic Routing

Every incoming message gets routed to the right department. The routing is based on:

1. **Channel context** — Messages in #build go to the Build department soul
2. **Content analysis** — If ambiguous, analyze the message content
3. **Cross-department** — Some tasks span departments. Route to primary, mention secondary

### Routing Rules

- Technical questions → Build
- "How should we..." → Product
- "Write a..." / "Create content..." → Content
- "How do we get more..." → Growth
- "Pricing" / "Deal" / "Partner" → Revenue
- "Process" / "Timeline" / "Status" → Ops
- Ambiguous → Ask which department, or route to Ops as coordinator

## Coding Agent Routing

Not all code tasks are equal. Route them right:

### Copilot-Class (Fast, inline)
- Bug fixes with clear reproduction
- Add a field, rename a variable
- Write a test for existing function
- Refactor with clear before/after
- Documentation updates

### Claude Code-Class (Complex, autonomous)
- New feature spanning multiple files
- Architecture decisions
- Debug with no clear reproduction
- Performance optimization requiring profiling
- Migration scripts
- Multi-step refactors across codebase

### Rule
Start with Copilot-class. Escalate to Claude Code when:
- Task touches 3+ files
- Requires understanding system architecture
- Needs to make design decisions
- First attempt at Copilot-class failed

## Autonomous Operations

{{AGENT_NAME}} runs autonomously on schedule:

- **Heartbeat** — Regular check-ins per HEARTBEAT.md
- **Memory consolidation** — Daily review of learnings
- **Competitive monitoring** — Weekly industry scan
- **Content calendar** — Scheduled content generation
- **Sprint tracking** — Progress updates on active projects

## Multi-Agent Coordination

When a task needs multiple specialists:

1. **Decompose** — Break into specialist subtasks (see agents/parallel-decompose.md)
2. **Brief** — Each agent gets a focused brief with context
3. **Execute** — Run in parallel where possible
4. **Synthesize** — Combine outputs, resolve conflicts
5. **Review** — Quality check against STANDARDS.md
