# Modify Procedure

Edit an existing project based on user feedback.

## Trigger

User sends feedback after seeing a preview:
- "Change the header color to blue"
- "Add a contact form"
- "The menu items should show prices"
- "Fix the mobile layout"

## Steps

### 1. Parse the request

Extract:
- **What to change** (specific UI/feature/logic)
- **Where** (which page/component)
- **Priority** (visual fix > feature addition > architecture change)

### 2. Read the project

```bash
cd ~/workspace/<slug>/
# Find the relevant files
grep -rl "header\|Header" src/
ls src/app/
cat src/app/layout.tsx
```

### 3. Decide: quick fix or Claude Code?

| Complexity | Approach |
|-----------|----------|
| CSS/color change, text update, simple prop change | Edit directly (nimmit-queue or inline edit) |
| New component, new page, logic change | Spawn Claude Code sub-agent |
| Database schema change | Claude Code + migration |

### 4. Quick fix (inline)

```bash
# Example: change primary color
sed -i 's/#FF6B35/#2563EB/g' tailwind.config.ts
```

### 5. Claude Code (complex)

```
sessions_spawn(runtime="acp", agentId="claude", task="
Modify ~/workspace/<slug>/
Request: <user's feedback>
Specific changes:
1. <change 1>
2. <change 2>

After changes:
1. Run `bun run build` to verify
2. Report what was changed
")
```

### 6. Re-deploy preview

```bash
cd ~/workspace/<slug>/
git add -A
git commit -m "fix: <description of change>"
git push
vercel --yes  # preview deploy
```

### 7. Screenshot and send

Use Playwright to screenshot the updated preview. Send to user with:
- What changed
- Updated preview URL

## Iteration Rules

- Maximum 3 rounds of changes without user saying "looks good"
- After 3 rounds: "I've made 3 rounds of changes. Does this look right, or should we take a different approach?"
- Track all changes in git history
