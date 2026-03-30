# Memory Index

{{AGENT_NAME}}'s knowledge base. Updated continuously.

## Structure

```
memory/
├── semantic/      — What things are
├── procedural/    — How to do things
├── decisions/     — Why we decided
├── failures/      — What went wrong
├── episodic/      — What happened (daily logs)
├── working/       — Current project state
├── research/      — Research archives
└── outcomes/      — Results tracking
```

## How to Use

### Writing Memory
- File naming: `YYYY-MM-DD-topic.md` for time-based, `topic.md` for evergreen
- Always include context (why, not just what)
- Cross-reference related files
- Tag with department: `[build]`, `[product]`, `[content]`, `[growth]`, `[revenue]`, `[ops]`

### Reading Memory
- Check `working/` first for current state
- Check `decisions/` before making similar decisions
- Check `failures/` before attempting something that might have failed before
- Check `procedural/` for how-to on recurring tasks

### Pruning Memory
- During daily consolidation, archive or delete outdated items
- Move completed `working/` items to `outcomes/`
- Compress `episodic/` entries older than 30 days

## Index

<!-- Add entries as memory grows. Format: -->
<!-- - [category/filename.md] — Brief description -->

(Empty — populate as {{AGENT_NAME}} learns)
