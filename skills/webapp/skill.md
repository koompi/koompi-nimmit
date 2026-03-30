# Webapp Builder Skill

Build full-stack web applications from a chat description. The client says "build me a restaurant ordering website" and gets a deployed, working app.

## Trigger

When a user asks to build, create, or scaffold a web application, website, landing page, dashboard, or web tool.

## Workflow

### 1. Clarify (30 seconds)
Ask 2-3 questions max. Never ask more than 4.
- What is the app for? (1 sentence)
- Any brand colors or style preference?
- Key features? (pick top 3)

If the user gives enough detail upfront, skip clarification entirely. **Don't ask when you can infer.**

### 2. Scaffold (use Claude Code sub-agent)
```
sessions_spawn(runtime="acp", agentId="claude", task="<brief>")
```
- Clone the `nextjs-supabase` template from `~/workspace/koompi-nimmit/templates/nextjs-supabase/`
- Customize: name, colors, pages based on user's description
- Set up Supabase tables and RLS policies
- Target directory: `~/workspace/<project-slug>/`

**Brief template for Claude Code:**
```
Build a <app type> app in ~/workspace/<slug>/
Based on the template at ~/workspace/koompi-nimmit/templates/nextjs-supabase/
User wants: <description>
Features: <features>
Style: <colors/brand>
Deploy target: <vercel|kconsole|self-hosted>
```

### 3. Database Setup
- Create Supabase project (or use existing)
- Run migrations for the app's schema
- Set up Row Level Security
- Create seed data for development

### 4. Deploy Preview
- Push to GitHub repo
- Deploy to Vercel preview or KConsole staging
- Return the preview URL

### 5. Screenshot & Send
- Use Playwright to screenshot the deployed preview
- Send screenshot to the user via Telegram
- Include: preview URL, what was built, what's next

### 6. Iterate
- Wait for feedback
- Each feedback round: modify → deploy preview → screenshot → send
- Maximum 3 rounds before confirming "good enough?"

### 7. Ship
- User approves → deploy to production
- Custom domain if requested
- Send final URL

## See Also
- `scaffold.md` — Step-by-step scaffold procedure
- `deploy.md` — Deploy procedures
- `modify.md` — How to edit existing projects
- `qa.md` — Screenshot, test, verify checklist
