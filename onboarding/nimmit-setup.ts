import { input, select, checkbox } from "@inquirer/prompts";
import { writeFile, mkdir, cp, readFile, appendFile, access } from "fs/promises";
import { join } from "path";
import { execSync } from "child_process";

const ROOT = new URL(".", import.meta.url).pathname;
const PACKS = join(ROOT, "..", "skill-packs");
const AGENT_NAME = "nimmit";

function addDays(dateStr: string, days: number): string {
  const d = new Date(dateStr);
  d.setDate(d.getDate() + days);
  return d.toISOString().split("T")[0];
}

function resolveHome(): string {
  return process.env.HOME ?? process.env.USERPROFILE ?? "~";
}

function resolveAgentWorkspace(): string {
  return join(resolveHome(), ".openclaw", "agents", AGENT_NAME, "workspace");
}

function runCmd(cmd: string): string {
  return execSync(cmd, { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] }).trim();
}

async function ensureOpenclawAgent(workspace: string): Promise<void> {
  // Check if agent already exists
  try {
    const agents = runCmd("openclaw agents list --json 2>/dev/null");
    if (agents.includes(`"${AGENT_NAME}"`)) {
      console.log(`  ℹ️  Agent "${AGENT_NAME}" already registered`);
      return;
    }
  } catch {
    // agents list failed — openclaw may not be configured yet, continue
  }

  // Register the agent via CLI (non-interactive)
  try {
    runCmd(
      `openclaw agents add --name ${AGENT_NAME} --workspace "${workspace}" --non-interactive`
    );
    console.log(`  ✅ Registered agent "${AGENT_NAME}"`);
  } catch (err) {
    console.warn(
      `  ⚠️  Could not register agent via CLI. You may need to run: openclaw agents add --name ${AGENT_NAME} --workspace "${workspace}"`
    );
  }
}

async function main() {
  console.log("\n🦅 Nimmit Setup — Configure your AI worker in 5 minutes\n");

  const orgName = (await input({ message: "Organization name:" })).trim();
  if (!orgName) {
    console.error("❌ Organization name is required.");
    process.exit(1);
  }

  const industry = await select({
    message: "What kind of organization?",
    choices: [
      { name: "👔 Executive — C-level, Minister, Leader", value: "executive" },
      { name: "🏫 Education — School, University", value: "education" },
      { name: "🏛️ Government — Ministry, Department", value: "government" },
      { name: "🏪 SME — Small/Medium Business", value: "sme" },
      { name: "🌐 General — Other", value: "general" },
    ],
  });

  const language = await select({
    message: "Primary language:",
    choices: [
      { name: "ភាសាខ្មែរ (Khmer)", value: "khmer" },
      { name: "English", value: "english" },
      { name: "Both Khmer + English", value: "both" },
    ],
  });

  const teamSize = await select({
    message: "Team size:",
    choices: [
      { name: "1–5 people", value: "small" },
      { name: "6–20 people", value: "medium" },
      { name: "21–50 people", value: "large" },
      { name: "50+ people", value: "enterprise" },
    ],
  });

  const allPriorities = [
    { name: "Morning briefings & reporting", value: "briefing" },
    { name: "School management", value: "school-mgmt" },
    { name: "Student tracking", value: "student-tracking" },
    { name: "Document processing", value: "docs" },
    { name: "Social media", value: "social" },
    { name: "Customer service", value: "customer-service" },
    { name: "Marketing campaigns", value: "marketing" },
    { name: "Content creation", value: "content" },
    { name: "Inventory & sales", value: "inventory" },
    { name: "HR & staff management", value: "hr" },
    { name: "Decision support & research", value: "decision-support" },
  ];

  const priorities = await checkbox({
    message: "Top priorities (pick 3):",
    choices: allPriorities,
    required: true,
  });

  const telegramToken = (await input({
    message: "Telegram bot token (leave blank to skip):",
    default: "",
  })).trim();

  // Nimmit gets its own agent workspace — never share with default agent
  const workspace = resolveAgentWorkspace();
  console.log(`  📂 Workspace: ${workspace}`);

  // Ensure workspace directories exist
  await mkdir(join(workspace, "skills"), { recursive: true });
  await mkdir(join(workspace, "tasks"), { recursive: true });
  await mkdir(join(workspace, "memory"), { recursive: true });

  // Register nimmit as a named agent in openclaw
  await ensureOpenclawAgent(workspace);

  if (industry !== "general") {
    const packDir = join(PACKS, industry);
    const targetDir = join(skillsDir, `nimmit-${industry}`);
    await cp(packDir, targetDir, { recursive: true });
    console.log(`  ✅ Installed ${industry} skill pack`);
  }

  // Generate workspace files
  const toneMap: Record<string, string> = {
    executive: "Direct, concise, honest — a chief of staff who tells you what you need to hear",
    education: "ភាសាធម្មតា — professional but approachable, like a good teacher",
    government: "រដាធិកម្ម — formal and precise, protocol-aware",
    sme: "ភាសាធម្មតា — friendly, practical, business-focused",
    general: "Clear, concise, professional",
  };

  const langMap: Record<string, string> = {
    khmer: "ភាសាខ្មែរ",
    english: "English",
    both: "Khmer + English",
  };

  // IDENTITY.md
  await writeFile(join(workspace, "IDENTITY.md"), `# IDENTITY.md

- **Name:** Nimmit
- **Organization:** ${orgName}
- **Industry:** ${industry}
- **Language:** ${langMap[language]}
- **Team size:** ${teamSize}
- **Tone:** ${toneMap[industry]}
- **Priorities:** ${priorities.join(", ")}

This Nimmit instance is configured for ${orgName}.
`);

  // SOUL.md
  const soulPreamble: Record<string, string> = {
    executive:
      "You are the AI chief of staff. Make this leader more effective with briefings, research, decision support, and honest counsel. Never hedge. Never sugarcoat. Lead with what matters.",
    education:
      "You are an AI team member for a Cambodian school. Help with teaching, administration, and parent communication.",
    government:
      "You are an AI team member for a Cambodian government ministry. Help with formal documents, reporting, and meeting preparation.",
    sme:
      "You are an AI team member for a Cambodian business. Help with sales, marketing, customer service, and daily operations.",
    general:
      "You are an AI team member. Help with research, writing, analysis, and coordination.",
  };

  await writeFile(join(workspace, "SOUL.md"), `# SOUL.md — ${orgName}

${soulPreamble[industry]}

## Core Rules
- Be concise. 1-3 sentences by default.
- Use ${langMap[language]} for communication. English for code and technical work.
- Do, don't narrate. Execute tasks, confirm briefly.
- Ask before acting externally (publishing, sending).
- Keep private information private.
`);

  // HEARTBEAT.md
  const heartbeatChecks: string[] = [];
  if (priorities.includes("briefing")) heartbeatChecks.push("- Prepare daily morning briefing at 7:00 AM");
  if (priorities.includes("reporting")) heartbeatChecks.push("- Generate pending reports");
  if (priorities.includes("inventory")) heartbeatChecks.push("- Check inventory alerts (low stock)");
  if (priorities.includes("social")) heartbeatChecks.push("- Check if scheduled social media posts are due");
  if (priorities.includes("docs")) heartbeatChecks.push("- Flag overdue document deadlines");
  if (priorities.includes("school-mgmt")) heartbeatChecks.push("- Check upcoming school events and exam dates");
  if (priorities.includes("student-tracking")) heartbeatChecks.push("- Flag students with attendance concerns");
  if (priorities.includes("customer-service")) heartbeatChecks.push("- Check for unanswered customer messages");
  if (priorities.includes("decision-support")) heartbeatChecks.push("- Gather overnight updates, flag what needs attention");

  await writeFile(join(workspace, "HEARTBEAT.md"), `# HEARTBEAT.md

## Checks (every heartbeat)
- Read tasks/TASKS.md — any active task due? Do it.
- Any blocked task > 2 days? Flag it.
${heartbeatChecks.join("\n") || "- General inbox check"}

## Daily Brief (once per day, before 8am)
- Review yesterday's completed tasks
- Flag today's priorities
- Surface anything that needs attention

## Rules
- Nothing to report → HEARTBEAT_OK
- Late night (23:00–08:00): skip unless urgent
`);

  // TASKS.md with proper date arithmetic
  const today = new Date().toISOString().split("T")[0];
  await writeFile(join(workspace, "TASKS.md"), `# TASKS.md — ${orgName} Onboarding

| ID | Task | Status | Due |
|----|------|--------|------|
| O-001 | Verify Nimmit is responding on Telegram | active | ${today} |
| O-002 | Complete organization profile in IDENTITY.md | active | ${today} |
| O-003 | Add team members to allowFrom list | active | ${addDays(today, 1)} |
| O-004 | Set up first workflow: ${priorities[0]} | active | ${addDays(today, 2)} |
| O-005 | Receive first morning briefing | active | ${addDays(today, 3)} |
| O-006 | Review and customize HEARTBEAT.md checks | active | ${addDays(today, 7)} |
`);

  // Handle Telegram token — append to existing .env or create new
  if (telegramToken) {
    const openclawEnv = join(resolveHome(), ".openclaw", ".env");
    const envContent = `\nTELEGRAM_BOT_TOKEN="${telegramToken}"`;
    try {
      await readFile(openclawEnv, "utf-8");
      await appendFile(openclawEnv, envContent);
    } catch {
      await mkdir(join(resolveHome(), ".openclaw"), { recursive: true });
      await writeFile(openclawEnv, envContent.trim());
    }
    console.log("  ✅ Telegram token configured");
  }

  console.log(`\n  ✅ Nimmit is ready for ${orgName}!`);
  console.log(`  📂 Workspace: ${workspace}`);
  console.log(`  🦅 Agent: ${AGENT_NAME}`);
  console.log(`  🎯 ${industry} | ${langMap[language]} | ${priorities.join(", ")}`);
  console.log(`  🔄 Restart the gateway to activate: openclaw gateway restart\n`);
}

main().catch(console.error);
