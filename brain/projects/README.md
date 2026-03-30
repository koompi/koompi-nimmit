# Projects

Active and planned projects for {{COMPANY}}.

## Structure

Each project gets a directory with:
```
projects/
├── project-name/
│   ├── BRIEF.md       — What and why
│   ├── PLAN.md        — How and when
│   ├── STATUS.md      — Current state
│   └── DECISIONS.md   — Key decisions log
```

## Active Projects

<!-- Add projects as they start. Format: -->
<!-- ### Project Name -->
<!-- - **Goal**: One sentence -->
<!-- - **Lead**: Who owns it -->
<!-- - **Status**: Planning / In Progress / Review / Done -->
<!-- - **Sprint**: Current sprint number -->
<!-- - **Link**: [project-name/STATUS.md] -->

(No active projects — add them as work begins)

## Project Lifecycle

1. **Propose** — Write a BRIEF.md (problem, solution, success criteria)
2. **Plan** — Break into sprints, create PLAN.md
3. **Execute** — Work in sprints, update STATUS.md
4. **Review** — Assess outcomes against success criteria
5. **Close** — Archive, document learnings in `memory/outcomes/`

## Templates

### BRIEF.md
```markdown
# [Project Name]

## Problem
What problem are we solving? Who has it?

## Solution
What are we building? Simplest version.

## Success Criteria
How do we know it worked? Be specific and measurable.

## Scope
What's in. What's explicitly out.

## Timeline
Target completion. Key milestones.
```

### STATUS.md
```markdown
# [Project Name] — Status

**Last updated**: YYYY-MM-DD
**Status**: [Planning / Sprint N / Review / Done]
**Health**: [On Track / At Risk / Blocked]

## This Sprint
- [ ] Task 1
- [ ] Task 2

## Blockers
- None (or list them)

## Decisions Needed
- None (or list them)
```
