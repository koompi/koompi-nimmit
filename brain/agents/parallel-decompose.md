# Parallel Task Decomposition

How to break a complex task into parallel agent work.

## When to Decompose

Decompose when:
- Task has 3+ independent subtasks
- Different subtasks need different expertise
- Time matters and parallelism helps
- Quality benefits from specialist focus

Don't decompose when:
- Task is sequential by nature
- Context sharing between subtasks is heavy
- The overhead of coordination exceeds time saved
- It's simpler to do it in one pass

## Decomposition Process

### Step 1: Identify Subtasks
Break the task into the smallest independent units.

Question each subtask:
- Can this run without waiting for another subtask?
- Does this need context from another subtask's output?
- Can a specialist handle this better than a generalist?

### Step 2: Classify Dependencies

```
Independent: [A] [B] [C]     → Run all in parallel
Sequential:  [A] → [B] → [C] → Run in order
Mixed:       [A] [B] → [C]   → A and B parallel, C after both
```

### Step 3: Brief Each Agent

Every parallel agent gets:
1. **Its specific subtask** (not the whole task)
2. **Relevant context only** (don't dump everything)
3. **Output format** (so synthesis is easy)
4. **Constraints** (time, scope, quality)
5. **What it does NOT need to worry about** (other agents handle it)

### Step 4: Execute

- Launch independent agents simultaneously
- Monitor for early failures
- Don't wait for all to finish if one blocks the critical path

### Step 5: Synthesize

- Collect all outputs
- Resolve conflicts (different agents may recommend different things)
- Fill gaps (things that fell between agents)
- Quality check against the original task

## Common Patterns

### Research Fan-Out
Task: "Analyze market opportunity"
- Agent 1: Competitive landscape
- Agent 2: Customer research
- Agent 3: Market sizing
→ Synthesize into strategy brief

### Feature Build
Task: "Launch new feature"
- Agent 1: Backend implementation
- Agent 2: Frontend implementation
- Agent 3: Documentation
- Agent 4: Test suite
→ Integration testing after all complete

### Content Campaign
Task: "Launch content campaign"
- Agent 1: Blog posts (writer)
- Agent 2: Social media (writer)
- Agent 3: Visual assets (designer)
- Agent 4: SEO optimization (seo)
→ Content calendar assembly

### Due Diligence
Task: "Evaluate partnership"
- Agent 1: Company research
- Agent 2: Technical compatibility
- Agent 3: Financial analysis
→ Partnership recommendation

## Anti-Patterns
- **Over-decomposition** — 10 agents for a 10-minute task
- **Shared state assumption** — Agent B assumes Agent A found something
- **No synthesis** — Dumping raw agent outputs as the final answer
- **Missing context** — Agent produces irrelevant work due to sparse brief
