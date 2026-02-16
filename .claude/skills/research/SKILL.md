---
name: research
description: Research stage - explore codebase, web search, ask clarifying questions, document findings
argument-hint: <topic or problem description>
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch, AskUserQuestion, Task, Write
---

# Research Stage

You are conducting the **Research Stage** of the RPI workflow.

## Your Mission

Deeply understand the problem space by:
1. Exploring relevant codebase areas
2. Gathering external context (with permission)
3. Asking clarifying questions
4. Documenting findings

## Input

Research topic: **$ARGUMENTS**

## Process

### Step 1: Initial Exploration

Launch 1-2 researcher agents in parallel to explore different aspects:

```
Use Task tool with:
- subagent_type: "general-purpose"
- prompt: Include the researcher agent instructions
- description: "Research [aspect]"
```

Example prompts for researchers:
- "Explore the codebase for code related to [topic]. Find entry points, core files, patterns."
- "Search the web for best practices, documentation, similar implementations for [topic]."

### Step 2: Synthesize Findings

After agents return:
1. Read the key files they identified
2. Compile a unified understanding
3. Identify gaps and ambiguities

### Step 3: Ask Clarifying Questions

Use AskUserQuestion to gather missing information:
- Ask specific, concrete questions
- Prioritize by impact on solution
- Group related questions

### Step 4: Iterate

If answers reveal new areas to explore:
1. Launch additional research if needed
2. Continue until understanding is sufficient

### Step 5: Document

Create or update the work document:

**Location**: `Notes/Work/<TIMESTAMP> <title>.md`
- Or with ticketID: `Notes/Work/<ticketID>/<TIMESTAMP> <title>.md`

Use this structure for the Research Stage section:

```markdown
## Research Stage

### Requirements
[What needs to be done, constraints, goals]

### Clarifying Questions & Answers
| Question | Answer |
|----------|--------|
| [Q1] | [A1] |

### Findings
[Key discoveries, patterns observed, architecture insights]

### Key Files
| File | Purpose |
|------|---------|
| [path] | [why it's relevant] |
```

### Step 6: Present Summary

Present findings to user:
1. Summary of understanding
2. Key files and patterns discovered
3. Remaining questions (if any)
4. Readiness assessment for planning

Ask: "Research complete. Ready to proceed to planning?"

## Guidelines

- Be thorough but efficient
- Always include file:line references
- Don't make assumptions - ask questions
- Web search requires user permission
- Document as you go, not just at the end
