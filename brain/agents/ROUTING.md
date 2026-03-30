# Agent Routing Table

Route tasks to the right specialist agent. Default to the generalist coder for ambiguous technical tasks.

## Routing Decision Tree

```
Is it a coding task?
├── Yes → How complex?
│   ├── Single file, clear scope → Copilot (inline)
│   ├── Multi-file, needs design → agents/build/generalist-coder.md
│   ├── Architecture decision → agents/build/architect.md
│   ├── Testing/QA focused → agents/build/qa.md
│   └── Infrastructure/deploy → agents/build/devops.md
├── No → What domain?
│   ├── Strategy/roadmap → agents/product/strategy.md
│   ├── Market research → agents/product/research.md
│   ├── Data/analytics → agents/product/data.md
│   ├── Writing/copy → agents/content/writer.md
│   ├── Video content → agents/content/video.md
│   ├── Visual design → agents/content/designer.md
│   ├── SEO → agents/growth/seo.md
│   ├── Paid ads → agents/growth/paid.md
│   ├── Growth analytics → agents/growth/analytics.md
│   ├── Prospecting → agents/revenue/prospecting.md
│   ├── Outreach → agents/revenue/outreach.md
│   ├── Partnerships → agents/revenue/partnerships.md
│   ├── Pricing → agents/revenue/pricing.md
│   ├── Process → agents/ops/process.md
│   └── Project mgmt → agents/ops/project-management.md
└── Unclear → Ask, or route to ops/project-management.md
```

## Full Routing Table

| Task Pattern | Agent | Model Tier | Parallel OK? |
|-------------|-------|-----------|-------------|
| Write/fix code (single file) | Copilot | Fast | N/A |
| Write/fix code (multi-file) | build/generalist-coder | Strong | Yes |
| System design, architecture | build/architect | Strong | No (sequential) |
| Write/run tests, QA | build/qa | Standard | Yes |
| Deploy, CI/CD, infra | build/devops | Standard | Yes |
| Product strategy, roadmap | product/strategy | Strong | No |
| Market/competitor research | product/research | Standard | Yes |
| Data analysis, metrics | product/data | Standard | Yes |
| Blog, article, copy | content/writer | Strong | Yes |
| Video script, storyboard | content/video | Standard | Yes |
| Visual design, mockup | content/designer | Standard | Yes |
| SEO audit, keywords | growth/seo | Standard | Yes |
| Ad copy, campaign setup | growth/paid | Standard | Yes |
| Funnel/growth analytics | growth/analytics | Standard | Yes |
| Lead research, ICP | revenue/prospecting | Standard | Yes |
| Email sequences, outreach | revenue/outreach | Standard | Yes |
| Partnership strategy | revenue/partnerships | Strong | No |
| Pricing analysis | revenue/pricing | Strong | No |
| Process design | ops/process | Standard | No |
| Sprint/project tracking | ops/project-management | Standard | No |

## Model Tiers

- **Fast** — Simple, scoped tasks. Copilot or small model.
- **Standard** — Department-specific tasks with clear scope. Mid-tier model.
- **Strong** — Complex, cross-cutting, or high-stakes tasks. Best available model.

## Multi-Agent Tasks

Some tasks need multiple agents. See `parallel-decompose.md` for patterns.

Common multi-agent combos:
- **Feature launch**: architect → generalist-coder → qa → writer (announcement) → seo
- **New market entry**: research → strategy → pricing → writer (content) → seo → paid
- **Process overhaul**: process → project-management → writer (documentation)
- **Content campaign**: strategy → writer → designer → seo → analytics

## Escalation

If an agent is stuck:
1. Check if it has the context it needs (brief complete?)
2. Check if it needs a different specialist
3. Escalate to {{OWNER_NAME}} if decision required
