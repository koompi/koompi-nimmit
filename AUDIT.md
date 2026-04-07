# Nimmit Product Audit

**Date:** 2026-04-03
**Auditor:** Claude (requested by product team)
**Scope:** Full product review — install.sh, onboarding CLI, all 4 skill packs, README, OpenClaw workspace

---

## Executive Summary

1. **The product is a prompt template system, not a product.** There are no data integrations, no APIs, no connectors. The morning briefing has no data sources — it generates templates, not actual intelligence. A minister who installs this gets an empty briefing format, not a briefing.
2. **The Khmer language in government and SME skill packs contains fabricated words and garbled sentences.** Ministry names are wrong, formal register guidance is incorrect, customer service templates are unnatural. This would embarrass you in front of any Cambodian government client.
3. **Critical security gap for the target market.** Government ministers and CEOs are asked to pipe sensitive data through third-party LLM APIs with no encryption at rest, no data residency guarantees, no audit trail. No Cambodian ministry IT team would approve this.
4. **Hard dependency on OpenClaw, an early-stage runtime** that is not widely adopted, has unclear maintenance status, and could disappear. The entire product breaks if OpenClaw breaks.
5. **The installer has bugs** — date arithmetic doesn't work, the TS setup is missing the "executive" option, error handling is incomplete, and secrets handling is inconsistent.

---

## 1. Critical Issues (Product-Killing)

### 1.1 No Actual Data Integration — The Briefing Is a Template, Not Intelligence

**Files:** `skill-packs/executive/SKILL.md:18-52`, `README.md:46-55`

The README promises: "morning briefing at 7 AM, overnight intelligence, decision support." The executive skill pack defines a beautiful briefing template with sections for "WHAT HAPPENED OVERNIGHT", "NUMBERS THAT MATTER", and "EXTERNAL INTELLIGENCE."

But there's **no mechanism to populate any of it**. No email connector, no calendar integration, no CRM hook, no news API, no metrics dashboard. The skill pack tells the AI what format to use, but gives it zero data to work with.

**What a minister actually gets:** An AI that writes `[Key emails/messages/events — 3-5 bullet points]` with placeholder brackets, or worse, hallucinated content presented as real intelligence.

**Fix:** Either (a) build actual integrations (Telegram message history, Google Calendar, RSS feeds for Cambodian news at minimum), or (b) reframe the product honestly as "AI writing assistant with Cambodian domain templates" and drop the "chief of staff" positioning until real integrations exist.

### 1.2 Fabricated Khmer in Government Skill Pack

**File:** `skill-packs/government/SKILL.md`

This skill pack would be shown to government ministry staff. It contains invented words:

- **Line 72:** `ក្រសួងអប់រំយុវជន អភិវឌ្ឍន៍កុមារធ្យាយាង (MoEYS)` — The actual name is **ក្រសួងអប់រំ យុវជន និងកីឡា** (Ministry of Education, Youth and Sport). "កុមារធ្យាយាង" is not a Khmer word. This would immediately destroy credibility.
- **Line 13:** The register guide claims `គោរព = មានអាណត្តិ` — this is nonsensical. គោរព means "respect"; មានអាណត្តិ means "having authority." These are not register equivalents.
- **Line 14:** `...ហេតុផលនេះដោយហេតុសារ័យថា...` — "សារ័យ" is not standard Khmer.
- **Line 65:** Procurement terminology appears fabricated rather than drawn from actual Cambodian public procurement law.

### 1.3 Garbled Khmer in SME Customer Service Templates

**File:** `skill-packs/sme/SKILL.md`

- **Line 32:** `ចុចចំហដំណើរមកជួបគ្រូ` — Not natural Khmer. "ចុចចំហដំណើរ" is meaningless.
- **Line 33:** `សូមអភ័យទោសពីការពន្យារពេលប្រឹងប្រែងបញ្ជូនបន្តក្នុងពេលឆាប់ឆ្លាតដាល` — This is garbled. "ឆាប់ឆ្លាតដាល" is not a natural Khmer phrase. A Cambodian business owner reading this would know instantly it was machine-generated.
- **Line 34:** `យើងខ្ញុំសូមអភ័យទោសបានដើម្បីបញ្ហានេះ` — Grammatically broken. "សូមអភ័យទោសបានដើម្បី" doesn't work in Khmer.

**Impact:** These templates are meant to be sent directly to customers. Sending garbled Khmer to your customers is worse than no templates at all.

### 1.4 Security: Government Data Through Third-Party LLMs

**Files:** `install.sh:126-137`, `~/.openclaw/workspace/README.md:96-99`

The product targets government ministers handling sensitive state information. The data flow is:

```
Minister types sensitive info → Telegram → OpenClaw gateway → External LLM API (Gemini/Claude/etc.) → Response
```

Problems:
- **No data residency.** Cambodian government data leaves the country to Google/Anthropic servers.
- **No audit trail.** No logging of what data was sent to which LLM.
- **No encryption at rest.** Memory files, task files, and conversation history sit as plaintext markdown on disk.
- **No access control beyond Telegram.** Anyone with the bot token can impersonate authorized users.
- The OpenClaw workspace README (`~/.openclaw/workspace/README.md:118-119`) mentions "Gateway bound to loopback only" and "Access control via allowFrom" — but the Nimmit installer (`install.sh`) **doesn't configure either of these**.

No Cambodian ministry IT/security team would approve this deployment. This isn't a polish issue — it's a blocker for the entire government vertical.

### 1.5 Executive Option Missing from TypeScript Setup

**File:** `onboarding/nimmit-setup.ts:13-21`

The TypeScript onboarding (`nimmit-setup.ts`) offers: Education, Government, SME, General. The bash installer (`install.sh:87`) offers: Executive, Education, Government, SME, General.

The **executive** option — the flagship skill pack, the one the README leads with — is missing from the interactive TypeScript setup. If someone runs `bun run onboarding/nimmit-setup.ts`, they cannot select the product's hero feature.

---

## 2. Major Issues (Adoption Blockers)

### 2.1 OpenClaw Dependency Risk

The entire product is built on OpenClaw as the runtime. Based on the workspace, OpenClaw is installed via `bun install -g openclaw`. Key concerns:

- **Maintenance status unclear.** Is OpenClaw actively maintained? What's the release cadence? Who else uses it?
- **No fallback.** If OpenClaw stops working, the entire product is dead. There's no abstraction layer.
- **"openclaw" as a global npm package** — if this package doesn't exist on npm, `install.sh:67` fails silently (the `|| true` patterns swallow the error).
- The workspace README references a complex ecosystem (agents, skills, extensions, heartbeats, topics) but it's unclear how much of this is actually implemented vs. aspirational.

### 2.2 install.sh Bugs

**File:** `install.sh`

- **Line 233-237:** Date arithmetic is broken. `${TODAY}+1` produces the literal string `"2026-04-03+1"`, not `"2026-04-04"`. Every due date after the first is invalid.
  ```
  | O-003 | Add team members to allowFrom | active | 2026-04-03+1 |
  ```

- **Line 43:** `sudo pacman -Syu --noconfirm` runs a **full system upgrade** without warning. On a production machine, this could break running services.

- **Line 53-54:** Piping curl to bash for Bun install. Standard practice but worth noting for security-conscious government deployments.

- **Line 129:** `.env` file is **overwritten**, not appended. If there were existing environment variables (API keys, etc.), they're destroyed:
  ```bash
  echo "TELEGRAM_BOT_TOKEN=\"$TG_TOKEN\"" > "$HOME/.openclaw/.env"
  ```

- **Line 287:** `$(which bun)` and `$(which openclaw)` are resolved at install time and hardcoded into the systemd unit. If paths change (e.g., bun updates), the service breaks.

- **Line 80:** `openclaw config set ... 2>/dev/null || true` — if OpenClaw doesn't exist or the command fails, the installer happily continues. The user thinks setup succeeded but the workspace isn't actually configured.

- **No rollback.** If the installer fails at step 5, steps 1-4 leave partial state with no cleanup.

### 2.3 nimmit-setup.ts Issues

**File:** `onboarding/nimmit-setup.ts`

- **Line 7:** `TEMPLATES` constant points to `../templates/` but this directory doesn't exist. Dead code.
- **Line 77:** Empty catch block: `try { await mkdir(...) } catch {}` — silently swallows all errors, including permissions failures.
- **Line 177:** Prints Telegram bot token to stdout in cleartext: `add your token to ~/.openclaw/.env as TELEGRAM_BOT_TOKEN="${telegramToken}"`. This ends up in terminal scrollback and potentially log files.
- **Line 124:** When language is English, this produces a blank bullet in SOUL.md:
  ```ts
  - ${language === "english" ? "" : "For code and technical work, use English."}
  ```
  Result: `- ` (empty bullet point in the generated file).
- **Line 12:** No validation that `orgName` is non-empty. An empty string produces `# SOUL.md — ` and broken identity files.

### 2.4 Education Skill Pack: Rubric Term Is Wrong

**File:** `skill-packs/education/SKILL.md:64`

```
Rubric for essays: គ្រោះថ្លៃ (40%) + រចនាសម្ព័ន្ធ (20%) + ភាសា (20%) + ទម្រង់ (20%)
```

"គ្រោះថ្លៃ" means something like "precious disaster" — it's not a rubric category. The intended word is likely **ខ្លឹមសារ** (content/substance). This is the essay grading rubric that would be shown to teachers.

### 2.5 Executive Skill Pack: Fabricated Government Hierarchy

**File:** `skill-packs/executive/SKILL.md:143`

```
Government hierarchy: ឯកឧត្តម (Minister) > រដ្ឋលេខាធិការ > អនាយករដ្ឋលេខាធិការ > ហេរក្តិ > ធ្វើការទូទៅ
```

"ហេរក្តិ" is not a real Cambodian government title. The hierarchy should use actual titles like ប្រធាននាយកដ្ឋាន (department director), អគ្គនាយក (director general), etc.

### 2.6 The "AI Chief of Staff" Framing Doesn't Work for 3 of 4 Verticals

The README and install.sh frame everything as "AI Chief of Staff." This makes sense for the executive pack. It does **not** make sense for:

- A **school director** — they need an admin assistant, not a chief of staff
- A **shop owner** — they need a social media manager / bookkeeper, not a chief of staff
- A **government department** — they need a document processor, not a chief of staff

The product tries to be one thing (chief of staff) while actually being four different things. This confuses the value proposition and makes marketing harder.

### 2.7 No Update Mechanism

Once installed, there's no way to:
- Update skill packs when they're improved
- Update the installer itself
- Receive patches or security fixes
- Know a new version exists

For a product you're charging for, this is a significant gap.

---

## 3. Minor Issues (Polish)

### 3.1 Test File Is Not a Real Test Suite

**File:** `onboarding/nimmit-setup.test.ts`

This is a manual test script that duplicates the generator logic (lines 11-48) instead of importing and testing the actual code. It uses `console.log` for assertions instead of a test framework. There's no CI integration. The generator logic can drift from the actual setup code since it's copy-pasted.

### 3.2 README Claims "Five Minutes" but Install Does Full System Upgrade

`install.sh:43` runs `sudo pacman -Syu --noconfirm` which can take 10-30 minutes on a machine that hasn't been updated recently. The "five minutes" claim in the README is misleading.

### 3.3 package.json Has No devDependencies or Test Script

**File:** `package.json`

No test runner, no linter, no build tooling. The `setup` script works but there's no `test` script for CI.

### 3.4 Inconsistent Skill Pack Naming

The education parent communication template (line 53-58 of `skill-packs/education/SKILL.md`) uses numbered items but some are Khmer text that aren't actual template content — they're descriptions of template types. The format inconsistency makes it unclear what's a template vs. a category label.

### 3.5 HEARTBEAT.md Escape Characters

**File:** `install.sh:208`

```bash
echo "- Prepare daily morning briefing at 7:00 AM\n- Gather overnight updates..."
```

The `\n` inside a heredoc produces literal `\n` characters, not newlines, depending on shell behavior. This may produce malformed HEARTBEAT.md output.

### 3.6 TASKS.md Due Date Format

Even if the date arithmetic worked, `${TODAY}+7` is not a date format any task tracker would parse. These should be actual ISO dates or relative indicators like "Day 1", "Day 3", "Week 1".

---

## 4. What's Actually Good

### 4.1 Executive Skill Pack Is Strong

`skill-packs/executive/SKILL.md` is the best file in the repo. The morning briefing format is well-structured. The decision support framework (lines 93-104) is genuinely useful — especially the "Never just list pros and cons" principle. The weekly review template is practical. The tone section (lines 135-139) is sharp. This skill pack alone has real value.

### 4.2 The Product Vision Is Sound

"Every leader deserves an AI chief of staff" is a compelling pitch. The Cambodian market positioning is smart — less competition, high need, language barrier keeps out generic solutions. The idea of pre-configured, industry-specific AI workers is the right direction.

### 4.3 The Installer UX Flow Is Good

The step-by-step flow (industry → org name → language → Telegram) is intuitive. Generating workspace files from selections is the right approach. The systemd service setup is practical for always-on deployment.

### 4.4 Education Skill Pack Structure

The school year calendar, grade structure, subject lists, and lesson plan template align with actual Cambodian education. The attendance tracking thresholds and grading scale are reasonable. The parent communication section addresses a real pain point.

### 4.5 SME Pack Knows the Cambodian Market

Facebook-first social media strategy is correct for Cambodia. The posting time recommendations match Cambodian user behavior. The daily sales report format is practical for shop owners.

### 4.6 The OpenClaw Workspace Design

The brain file architecture (SOUL.md, IDENTITY.md, HEARTBEAT.md, MEMORY.md) is elegant. The separation of identity, behavior, and memory into discrete files is a good design for customizable AI workers. The existing workspace at `~/.openclaw/workspace/` shows this architecture works in practice.

---

## 5. Business Viability Assessment

### 5.1 Can You Charge for This?

**In its current state: No.** It's a set of markdown templates and a bash installer. The value is in the domain knowledge (Cambodian education/government/SME workflows) and the Khmer language templates — but both have quality issues that undermine the credibility needed to charge.

**What would make it chargeable:**
- Working data integrations (even just Telegram message history + Google Calendar)
- Correct, polished Khmer reviewed by a native speaker
- A managed service (not just an installer — ongoing updates, support, monitoring)
- The KOOMPI Mini hardware bundle (hardware + pre-configured AI = tangible product)

### 5.2 Pricing Model

The hardware bundle is the right approach:
- KOOMPI Mini + pre-installed Nimmit = one-time hardware sale + monthly service fee
- Monthly fee covers: LLM API costs, cloud storage, updates, support
- Tier by vertical: Education ($X/mo), Government ($X/mo), Enterprise ($X/mo)

Pure software pricing is hard to justify when ChatGPT/Claude are available.

### 5.3 Competition

| Competitor | What They Have | What Nimmit Has |
|-----------|---------------|-----------------|
| ChatGPT/Claude | General AI, massive capability | Cambodia-specific, Khmer language, pre-configured workflows |
| Microsoft Copilot | Deep Office/Teams integration | Telegram-native (matches Cambodian comms) |
| Custom GPTs | Easy to build, free/cheap | Persistent memory, always-on, proactive briefings |
| Local consultants | Relationship, trust | Scalable, 24/7, lower ongoing cost |

**Nimmit's real moat (if executed):** Khmer language quality + Cambodian domain knowledge + hardware bundle + local support. This is defensible but requires the Khmer to actually be correct.

### 5.4 The $1B Path

Not realistic as a prompt template product. Potentially realistic as:
- AI-powered business OS for Southeast Asian SMEs (expand beyond Cambodia)
- Hardware + AI service bundle (KOOMPI Mini as the delivery vehicle)
- Platform play: Nimmit marketplace where domain experts publish skill packs

But all of these require the core product to work first, which it currently doesn't.

---

## 6. Recommendations (Prioritized)

### P0 — Fix Before Showing to Anyone

1. **Have a native Khmer speaker review and rewrite all Khmer content** in government, SME, and education skill packs. Every fabricated word and garbled sentence must be fixed. Budget 2-3 days with a fluent reviewer who understands government/education terminology.

2. **Add the "executive" option to `nimmit-setup.ts:13-21`.** Your flagship feature is missing from the interactive setup.

3. **Fix install.sh date arithmetic** (line 233-237). Replace `${TODAY}+N` with actual computed dates using `date -d "+N days"`.

4. **Fix install.sh `.env` overwrite** (line 129). Change `>` to `>>` or read/merge existing content.

5. **Fix the empty bullet in SOUL.md** when English is selected (`nimmit-setup.ts:124`).

### P1 — Fix Before First Paying Customer

6. **Build at least one real data integration.** Minimum viable: parse recent Telegram group messages to populate the "WHAT HAPPENED OVERNIGHT" briefing section. This turns the template into actual intelligence.

7. **Add a security model.** At minimum: document the data flow, add encryption at rest for memory files, configure the gateway to loopback-only by default, generate a random gateway auth token during install.

8. **Extract generator logic from `nimmit-setup.ts` into importable functions** so the test file actually tests the real code instead of a copy.

9. **Add input validation** to both install.sh and nimmit-setup.ts — empty org names, invalid workspace paths, unreachable Telegram tokens.

10. **Remove `sudo pacman -Syu --noconfirm`** from install.sh or make it opt-in. A full system upgrade is not the installer's job.

### P2 — Fix Before Scaling

11. **Build an update mechanism.** Skill pack versioning, `nimmit update` command, changelog notifications.

12. **Decide the OpenClaw dependency question.** Either invest heavily in OpenClaw (contribute, co-maintain) or build an abstraction layer so you can swap runtimes.

13. **Separate the product messaging by vertical.** "AI Chief of Staff" for executives. "AI School Admin" for education. "AI Business Assistant" for SMEs. Same product, different positioning.

14. **Build a proper test suite** with a real test runner (bun test), covering all generator paths.

15. **Create the `templates/` directory** referenced in SKILL-MISSION.md and move template generation out of inline string concatenation.

---

## Appendix: File-by-File Issue Index

| File | Line(s) | Severity | Issue |
|------|---------|----------|-------|
| `install.sh` | 43 | Major | Full system upgrade without warning |
| `install.sh` | 67 | Major | OpenClaw install may silently fail |
| `install.sh` | 80 | Minor | Config errors silently swallowed |
| `install.sh` | 129 | Critical | `.env` overwritten, not appended |
| `install.sh` | 208 | Minor | `\n` may produce literal characters in heredoc |
| `install.sh` | 233-237 | Major | Date arithmetic produces invalid strings |
| `install.sh` | 287 | Minor | Hardcoded paths in systemd unit |
| `onboarding/nimmit-setup.ts` | 7 | Minor | TEMPLATES constant unused, directory missing |
| `onboarding/nimmit-setup.ts` | 13-21 | Critical | Executive option missing |
| `onboarding/nimmit-setup.ts` | 77 | Minor | Empty catch swallows errors |
| `onboarding/nimmit-setup.ts` | 124 | Major | Empty bullet when English selected |
| `onboarding/nimmit-setup.ts` | 177 | Major | Token printed to stdout |
| `skill-packs/government/SKILL.md` | 13-14 | Critical | Fabricated/incorrect register guidance |
| `skill-packs/government/SKILL.md` | 65 | Major | Fabricated procurement terms |
| `skill-packs/government/SKILL.md` | 72 | Critical | Wrong ministry name (invented word) |
| `skill-packs/education/SKILL.md` | 64 | Major | Wrong rubric term (គ្រោះថ្លៃ) |
| `skill-packs/sme/SKILL.md` | 32-34 | Critical | Garbled customer-facing Khmer |
| `skill-packs/executive/SKILL.md` | 143 | Major | Fabricated government title (ហេរក្តិ) |

---

*This audit is based on a complete review of all source files in `~/workspace/nimmit-product/` and the live OpenClaw workspace at `~/.openclaw/workspace/`. Findings are intended to be constructive — the product vision is strong, but execution needs significant work before it's ready for paying customers.*
