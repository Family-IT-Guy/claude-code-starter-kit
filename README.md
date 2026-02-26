# Claude Code Starter Kit

A session recovery and self-improvement system for Claude Code CLI.

## For Claude Code: Installation Instructions

When a user asks you to install or set up this starter kit, follow this process. Do not skip steps or batch questions. Work through this one decision at a time with the user.

### Step 0: Fetch the Kit

Clone the repo to a temporary location:
```bash
git clone https://github.com/Family-IT-Guy/claude-code-starter-kit.git /tmp/claude-code-starter-kit
```

Read every file in the cloned repo to understand what's available.

### Step 1: Audit the User's Existing Setup

Before proposing any changes, understand what the user already has. Read these locations if they exist:
- `~/.claude/CLAUDE.md`
- `~/.claude/settings.json`
- `~/.claude/commands/` (list all files)
- `~/.claude/workflows/` (list all files)
- `~/.claude/core/` (list all files)
- Any other `.yml`, `.md`, or `.sh` files in `~/.claude/`

Use the sequential thinking tool to analyze the gap between their current setup and what this kit provides. Categorize each component of the kit as:
- **New** -- user has nothing equivalent
- **Overlap** -- user has something similar that would need merging
- **Conflict** -- user has something that contradicts a kit component

### Step 2: Walk Through the System

Explain to the user what this kit does, in plain language:

> This is a system that gives me (Claude) persistent memory across sessions and a way to learn from my mistakes over time. It has three main pieces:
>
> 1. **Session recovery** -- When a session ends, I write a recovery guide and update a handoff file. When the next session starts, I read those files and pick up where I left off. You never have to re-explain context.
>
> 2. **Self-improvement loop** -- When you correct me, I capture it as a lesson. Next session, I surface it and ask if you want to make it a permanent rule. Over time, your CLAUDE.md accumulates rules specific to how you work.
>
> 3. **Thinking discipline** -- Rules that force me to reason from first principles, cite evidence, track hypotheses I've already tested (so I don't go in circles), and present both sides before proposing changes.

### Step 3: Brainstorm with the User

Go through each component of the kit **one at a time**. For each, explain what it does, how it compares to anything they already have, and ask whether they want it. Use the sequential thinking tool to reason through trade-offs before presenting each question.

Work through them in this order:

**Foundation (start here):**
1. `CLAUDE.md` -- Master rules. Does the user already have one? What rules overlap, what's new?
2. `preferences.yml` -- Communication style and work standards. Walk through the voice rules, email checklist, and self-improvement section. Ask what resonates and what doesn't match how they work.
3. `lessons-learned.yml` -- The improvement queue. This is just a template file. Explain the lifecycle: pending -> accepted (codified) / rejected (removed).

**Session recovery:**
4. `workflows/session-recovery.md` -- The core workflow. Explain the session-end and session-start flows. This is the highest-value piece.
5. `commands/session-start.md` and `commands/session-end.md` -- Slash command triggers for the workflow.
6. `core/session-management.yml` -- Hypothesis tracking. Explain the CLOSED-means-CLOSED rule and why it prevents wasted debugging effort.
7. `statusline-script.sh` -- Context window % display. Explain that this works with manual compaction (auto-compact should be disabled).

**Thinking discipline:**
8. `core/methodologies.yml` -- First principles and evidence-based standards.
9. `workflows/gather-context.md` -- Systematic codebase exploration.
10. `workflows/git-workflow.md` -- Commit conventions and safety protocols.

For each component, ask: **"Do you want this as-is, want to adapt it, or skip it?"**

Do not present all components at once. One question at a time.

### Step 4: Build the Plan

After working through all components, summarize what the user chose:
- Which files to install as-is
- Which files to merge with existing config
- Which files to skip
- What customizations to make (names in signoffs, any rules to adjust)

Present the complete plan and get explicit approval before making any changes.

### Step 5: Install

For each approved file:
- **New files:** Copy from `/tmp/claude-code-starter-kit/` to `~/.claude/`, preserving directory structure
- **Merges:** Read both the kit version and the user's existing file, merge without duplicating rules, and present the merged result for approval before writing
- **statusline-script.sh:** Make executable after copying

### Step 6: Configure Claude Code Settings

After files are in place, apply these settings (explain each one before running it):

**Disable auto-compact:**
```bash
claude config set --global autoCompact false
```
Explain: Auto-compact compresses conversation without running the session-end workflow. That means no recovery guide, no lessons captured, and the next session starts cold. With auto-compact off, the user controls when to end a session. The workflow is designed to be run at any context window %. It builds the recovery guide first (the most critical artifact), then handles lessons and handoff. After `/session-end` completes, the user runs `/compact` manually, then starts a new session with `/session-start` which reads the recovery guide automatically.

**Enable the status line:**
```bash
claude config set --global statusline '~/.claude/statusline-script.sh'
```
Explain: Shows git branch, context window usage %, and model name. The % tells the user when to start wrapping up. Requires `jq` (`brew install jq` on macOS).

### Step 7: Install Plugins

Walk through each recommended plugin one at a time. Explain what it does and ask if the user wants it.

**claude-mem** (cross-session memory):
The session-recovery workflow integrates with this plugin to save lessons and search past work across sessions. Structured observation-based memory with a 3-layer search workflow (search -> timeline -> get_observations).
```
/plugin install claude-mem@thedotmack
```

**superpowers** (development skills):
Brainstorming, systematic debugging, TDD, planning, and code review skills. Adds structured workflows for common development tasks.
```
/plugin install superpowers@superpowers-marketplace
```

**context7** (library docs):
Fast lookup for library documentation and code examples. Useful when working with external dependencies.
```
/plugin install context7@claude-plugins-official
```

**sequential-thinking** (reasoning tool):
Structured step-by-step reasoning for analysis, debugging, and planning. This kit's workflows reference it extensively. The MCP server is available at: https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```
Add this to the user's `~/.claude/settings.json` under `mcpServers` if they approve.

### Step 8: Clean Up

```bash
rm -rf /tmp/claude-code-starter-kit
```

Tell the user the system is active. Their next step is to start working normally. When they're ready to end a session, type `/session-end`. When starting the next session, type `/session-start`.

---

## For Humans: What This System Does

### The Problem
Claude Code starts every session with amnesia. It doesn't know how you like to work, what mistakes it made last time, or what you were working on yesterday.

### The Solution
A set of configuration files in `~/.claude/` that Claude reads at session start. Three main capabilities:

**Session recovery.** `/session-end` creates a recovery guide and handoff file. `/session-start` reads them and picks up where you left off. You never re-explain context.

**Self-improvement.** When you correct Claude, it captures the correction as a pending lesson. Next session, it asks: accept (make it a permanent rule), reject, or defer. Over time, your CLAUDE.md accumulates rules specific to how you work. Every correction becomes permanent.

**Thinking discipline.** Rules that force first-principles reasoning, evidence citation, hypothesis tracking (no re-testing what's already been ruled out), and presenting both sides before proposing changes.

### Context Window Management

After installing, your status line shows context window usage: `main | 42% | Opus 4.6`

When you're ready to wrap up, run `/session-end`. The workflow handles prioritization at any context level -- it builds the recovery guide first, then captures lessons and updates the handoff file. After it completes, run `/compact` manually. Start your next session with `/session-start`, which reads everything automatically.

Recommended to disable auto-compact so the session-end workflow runs before any compaction happens.

### Getting Started

Start a Claude Code session and say:

```
Set up the Claude Code Starter Kit from https://github.com/Family-IT-Guy/claude-code-starter-kit -- read the README for instructions.
```

Claude will walk you through the setup one step at a time.
