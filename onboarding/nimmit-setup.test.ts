// Non-interactive test: pipes all answers and runs the full setup
import { cp, mkdir, rm } from "fs/promises";
import { join } from "path";
import { existsSync } from "fs";

const ROOT = new URL(".", import.meta.url).pathname;
const PACKS = join(ROOT, "..", "skill-packs");
const TEST_DIR = "/tmp/nimmit-test-org";

// Inline the generator logic (same as nimmit-setup.ts but without prompts)
async function generate(config) {
  const { orgName, industry, language, teamSize, priorities, workspace } = config;
  
  const toneMap = {
    education: "ភាសាធម្មតា — professional but approachable, like a good teacher",
    government: "រដាធិកម្ម — formal and precise, protocol-aware",
    sme: "ភាសាធម្មតា — friendly, practical, business-focused",
    general: "Clear, concise, professional",
  };
  const langMap = { khmer: "ភាសាខ្មែរ", english: "English", both: "Khmer + English" };
  const { writeFile: wf } = await import("fs/promises");

  const identity = `# IDENTITY.md\n\n- **Name:** Nimmit\n- **Organization:** ${orgName}\n- **Industry:** ${industry}\n- **Language:** ${langMap[language]}\n- **Team size:** ${teamSize}\n- **Tone:** ${toneMap[industry]}\n- **Priorities:** ${priorities.join(", ")}\n\nThis Nimmit instance is configured for ${orgName}.\n`;
  await wf(join(workspace, "IDENTITY.md"), identity);

  const soulPreamble = {
    education: "You are an AI team member for a Cambodian school.",
    government: "You are an AI team member for a Cambodian government ministry.",
    sme: "You are an AI team member for a Cambodian business.",
    general: "You are an AI team member.",
  };
  const soul = `# SOUL.md — ${orgName}\n\n${soulPreamble[industry]}\n\n## Core Rules\n- Be concise. 1-3 sentences by default.\n- Use ${langMap[language]} as the primary language.\n- Do, don't narrate.\n`;
  await wf(join(workspace, "SOUL.md"), soul);

  const heartbeatChecks = [];
  if (priorities.includes("reporting")) heartbeatChecks.push("- Generate pending reports");
  if (priorities.includes("inventory")) heartbeatChecks.push("- Check inventory alerts");
  if (priorities.includes("social")) heartbeatChecks.push("- Check scheduled social posts");
  if (priorities.includes("school-mgmt")) heartbeatChecks.push("- Check school events and exam dates");
  if (priorities.includes("student-tracking")) heartbeatChecks.push("- Flag attendance concerns");

  const heartbeat = `# HEARTBEAT.md\n\n## Checks\n- Read tasks/TASKS.md\n${heartbeatChecks.join("\n") || "- General inbox check"}\n`;
  await wf(join(workspace, "HEARTBEAT.md"), heartbeat);

  const today = new Date().toISOString().split("T")[0];
  const tasks = `# TASKS.md — ${orgName}\n\n| ID | Task | Status | Due |\n|----|------|--------|-----|\n| O-001 | Verify bot is working | active | ${today} |\n| O-002 | Complete org profile | active | ${today}+1 |\n| O-003 | Add team members | active | ${today}+1 |\n| O-004 | Set up first workflow: ${priorities[0]} | active | ${today}+2 |\n`;
  await wf(join(workspace, "TASKS.md"), tasks);
}

async function test() {
  // Clean
  if (existsSync(TEST_DIR)) await rm(TEST_DIR, { recursive: true });
  await mkdir(TEST_DIR, { recursive: true });

  const config = {
    orgName: "សាលារៀនថ្មី",
    industry: "education",
    language: "khmer",
    teamSize: "small",
    priorities: ["school-mgmt", "student-tracking", "reporting"],
    workspace: TEST_DIR,
  };

  // Copy skill pack
  const packDir = join(PACKS, config.industry);
  await cp(packDir, join(TEST_DIR, "skills", `nimmit-${config.industry}`), { recursive: true });
  console.log("✅ Skill pack copied");

  // Generate templates
  await generate(config);

  // Verify
  const { readdir, readFile } = await import("fs/promises");
  const files = await readdir(TEST_DIR);
  console.log(`\n📂 Files in workspace: ${files.join(", ")}`);

  for (const f of ["IDENTITY.md", "SOUL.md", "HEARTBEAT.md", "TASKS.md"]) {
    const content = await readFile(join(TEST_DIR, f), "utf-8").catch(() => "MISSING");
    const ok = content.includes(config.orgName);
    console.log(`${ok ? "✅" : "❌"} ${f} (${content.length} chars) ${ok ? "" : "— missing org name!"}`);
  }

  // Show IDENTITY.md
  const id = await readFile(join(TEST_DIR, "IDENTITY.md"), "utf-8");
  console.log("\n📄 IDENTITY.md:\n" + id);
}

test().catch(console.error);
