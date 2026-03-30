# Agent System

{{AGENT_NAME}} uses specialist agents for focused work. Each agent is a version of {{AGENT_NAME}} with a specific brief, context, and focus area.

## How It Works

1. **Task arrives** → Route via ROUTING.md
2. **Brief the agent** → Load the specialist file + relevant context
3. **Execute** → Agent works within its domain
4. **Return** → Output comes back to main {{AGENT_NAME}} for synthesis

## Briefing Template

Every agent gets this context:

```
## Task
[What to do]

## Context
[Why this matters, what happened before]

## Constraints
[Time, scope, quality requirements]

## Output Expected
[What to deliver, in what format]

## References
[Relevant files, past decisions, memory entries]
```

## Agent Types

### Build Agents
- `generalist-coder.md` — Full-stack development
- `architect.md` — System design and architecture
- `qa.md` — Testing and quality assurance
- `devops.md` — Infrastructure and deployment

### Product Agents
- `strategy.md` — Product strategy and roadmap
- `research.md` — Market and user research
- `data.md` — Analytics and data analysis

### Content Agents
- `writer.md` — Written content
- `video.md` — Video content
- `designer.md` — Visual design

### Growth Agents
- `seo.md` — Search engine optimization
- `paid.md` — Paid acquisition
- `analytics.md` — Growth metrics and analysis

### Revenue Agents
- `prospecting.md` — Lead generation
- `outreach.md` — Sales outreach
- `partnerships.md` — Strategic partnerships
- `pricing.md` — Pricing strategy

### Ops Agents
- `process.md` — Process improvement
- `project-management.md` — Project coordination

## Multi-Agent Patterns

### Sequential Pipeline
Agent A output → Agent B input → Agent C input

Use when: Each step depends on the previous.
Example: Research → Strategy → Implementation plan

### Parallel Fan-Out
Task → [Agent A, Agent B, Agent C] → Synthesize

Use when: Subtasks are independent.
Example: Competitive analysis across 3 competitors

### Review Loop
Agent A produces → Agent B reviews → Agent A revises

Use when: Quality matters and self-review isn't enough.
Example: Code → QA review → Code fix

See `parallel-decompose.md` for decomposition patterns.

## Rules

1. **Brief completely** — Agents with incomplete context produce garbage
2. **One focus per agent** — Don't overload a specialist with off-domain work
3. **Check routing** — Wrong agent = wasted work
4. **Synthesize outputs** — Multi-agent results need human (or main agent) integration
5. **Log decisions** — Save important agent outputs to memory
