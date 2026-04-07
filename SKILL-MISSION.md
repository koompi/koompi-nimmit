# Mission: Build Nimmit Domain Skill Packs + Onboarding

## Context
Nimmit is KOOMPI's AI team product, built on OpenClaw runtime. We need:
1. Domain skill packs (education, government, SME) for Cambodian market
2. An onboarding CLI that sets up a new Nimmit instance in 5 minutes

## OpenClaw Skill Spec
Skills go in `~/.openclaw/skills/<name>/` with a SKILL.md file. YAML frontmatter required:
```yaml
---
name: skill-name
description: When to use this skill
---
```
Skills provide domain-specific workflows, knowledge, and procedures. Be token-efficient — the agent is smart, skills give it domain context it wouldn't have otherwise.

## Build These

### 1. Education Skill Pack → skill-packs/education/SKILL.md
For Cambodian schools using Nimmit:
- Lesson planning aligned with MoEYS curriculum (Khmer language)
- Student management: attendance, grades, progress reports
- School admin: timetables, announcements to parents (Khmer), exam schedules
- Khmer content generation: worksheets, quizzes, study guides, flash cards
- Exam prep and grading rubrics
- Parent communication templates (polite everyday Khmer)
- Reference: Cambodian school year structure, grade levels (ចំណាត់ថ្នាក់ ១-១២), subjects

### 2. Government Skill Pack → skill-packs/government/SKILL.md
For Cambodian government ministries:
- Document processing: សេចក្តីណែនាំ (memos), របាយការណ៍ (reports), គោលនយោបាយ (policy briefs)
- Meeting prep and minutes in រដាធិកម្ម (formal register) Khmer
- Reporting: weekly ប្រចាំសប្តាហ៍, monthly ប្រចាំខែ, quarterly
- Procurement workflow templates
- Inter-ministry communication
- Khmer formal vs everyday register guidance (know when to use which)

### 3. SME Skill Pack → skill-packs/sme/SKILL.md
For Cambodian small/medium businesses:
- Social media content in Khmer (Facebook posts, TikTok captions)
- Customer service response templates
- Inventory and sales tracking (daily/weekly reports)
- Marketing campaign planning (Khmer market context)
- Basic financial reports (លក់/ទិញ/ចំណូល/ចំណាយ)
- Staff management (schedules, leave, announcements)

### 4. Onboarding CLI → onboarding/nimmit-setup.ts
Build with Bun/TypeScript. Interactive prompts.
Steps:
1. Organization name (text input)
2. Industry: education / government / sme / general (select)
3. Primary language: Khmer / English / both (select)
4. Team size: 1-5 / 6-20 / 21-50 / 50+ (select)
5. Top 3 priorities from list (multi-select): school management, student tracking, document processing, social media, customer service, marketing, reporting, content creation, inventory, HR
6. Telegram bot token (optional, text input)

Based on selections:
- Copy matching skill pack(s) to target workspace
- Generate customized IDENTITY.md (org name, industry)
- Generate customized SOUL.md (language, tone appropriate to industry)
- Generate HEARTBEAT.md with relevant periodic checks
- Generate initial TASKS.md with 7-day onboarding checklist
- Print "✅ Nimmit is ready for [org name]. Restart gateway to activate."

### 5. Templates → templates/
Base workspace templates that get customized during onboarding:
- IDENTITY.md.template
- SOUL.md.template  
- HEARTBEAT.md.template
- TASKS.md.template

## Style Rules
- Khmer: natural everyday register (ភាសាខ្មែរថ្មី) for education and SME, formal (រដាធិកម្ម) for government
- Token-efficient: assume the AI agent is smart, skills provide domain-specific knowledge only
- No filler content — every line should teach the agent something it wouldn't know
- Production quality, not prototype

## Output
All files in ~/workspace/nimmit-product/
