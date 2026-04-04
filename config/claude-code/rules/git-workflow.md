# Git Workflow

## Branches
- `main` — production-ready
- `feat/<short-name>` — features
- `fix/<short-name>` — bug fixes
- `hotfix/<short-name>` — urgent production fixes

## Commits
- Conventional commits: `feat(scope): description`, `fix(scope): description`
- Keep under 72 characters for the first line
- Reference issue numbers: `fix(api): handle timeout (#123)`

## PRs
- One concern per PR — don't bundle unrelated changes
- Include description of what changed and why
- All CI must pass before merge
