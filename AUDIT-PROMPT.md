# Critical Audit: Nimmit Product Setup & Design

You are auditing the Nimmit product — an AI Chief of Staff built on OpenClaw runtime, targeting ministers, CEOs, school directors, and SME owners in Cambodia and globally.

## What to Audit

Everything in ~/workspace/nimmit-product/:
- install.sh (installer)
- onboarding/nimmit-setup.ts (interactive setup)
- skill-packs/executive/SKILL.md (flagship product)
- skill-packs/education/SKILL.md
- skill-packs/government/SKILL.md
- skill-packs/sme/SKILL.md
- README.md

Also review the live OpenClaw workspace at ~/.openclaw/workspace/ for context on how it actually runs.

## Audit Framework

Be brutally honest. This is a product we're selling. Find every flaw.

### 1. Product Design
- Is "AI Chief of Staff" the right framing?
- Is the morning briefing structure actually useful for real executives?
- What's missing that a real C-level would need?
- How does this compare to what's already on the market (ChatGPT, Claude, Gemini, Microsoft Copilot)?

### 2. Technical Architecture
- Is OpenClaw the right runtime? What are the risks?
- Is the install.sh robust? Will it break on different machines?
- Are the skill packs actually good? Or are they shallow checklists?
- What happens when something goes wrong during install?

### 3. Business Viability
- Can we actually charge for this? What's the pricing model?
- Who is the ICP (ideal customer profile)?
- What's the competition and why would someone choose Nimmit over alternatives?
- What's the $1B path? Is it realistic?

### 4. Cambodia-Specific
- Is the Khmer language handling actually correct?
- Are the government register/formal language sections accurate?
- Do the education skill pack references (MoEYS, grade levels, subjects) match reality?
- Are the SME templates relevant to actual Cambodian businesses?

### 5. Security & Privacy
- Can a government minister trust this with sensitive information?
- What's the data flow? Where does data go?
- Is the install.sh secure? Any secrets leaking?

### 6. Missing Pieces
- What features must exist before v1.0 but don't yet?
- What's the onboarding gap between "installed" and "actually useful"?
- What would make someone uninstall this in the first week?

## Output Format

Write a detailed audit report to ~/workspace/nimmit-product/AUDIT.md with:

1. **Executive Summary** (3-5 bullet points — the most critical findings)
2. **Critical Issues** (things that will kill the product if not fixed)
3. **Major Issues** (things that will hurt adoption significantly)
4. **Minor Issues** (polish, nice-to-haves)
5. **What's Actually Good** (don't just trash everything — what works?)
6. **Recommendations** (prioritized action items)

Be specific. Reference exact files and lines. Don't give vague feedback like "improve the onboarding" — say exactly what's wrong and what to change.
