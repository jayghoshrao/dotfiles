---
name: rpi
description: Full Research-Plan-Implement workflow with explicit user approvals between stages
argument-hint: [ticketID] <problem description>
allowed-tools: Read, Edit, Write, Bash, Grep, Glob, Task, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion, WebSearch, WebFetch, Skill
---

# RPI Workflow

You are orchestrating the **Research-Plan-Implement (RPI)** workflow.

## Input

**Arguments**: $ARGUMENTS

Parse arguments:
- If first word looks like a ticket ID (e.g., PROJ-123, #456, issue-789): extract as ticketID
- Remaining text is the problem description

## Work Document Setup

Create work document at:
- With ticketID: `Notes/Work/<ticketID>/<TIMESTAMP>-<slug>.md`
- Without ticketID: `Notes/Work/<TIMESTAMP>-<slug>.md`

Where:
- TIMESTAMP: YYYYMMDD format (e.g., 20260126)
- slug: kebab-case summary of problem (e.g., "user-auth-refactor")

Initialize with:

```markdown
# <Title from problem description>

**Date**: <today's date>
**TicketID**: <ticketID or "N/A">
**Status**: Research

---

## Research Stage

*In progress...*

---

## Plan Stage

*Pending research completion*

---

## Implementation Stage

*Pending plan approval*

---

## Summary

*To be completed*
```

## Workflow Stages

### Stage 1: Research

Invoke the research skill:
```
Use Skill tool with:
- skill: "research"
- args: "<problem description>"
```

After research completes:
1. Update work document status to "Planning"
2. Present research summary to user
3. Ask for approval to proceed:

```
AskUserQuestion:
- question: "Research complete. Ready to proceed to planning?"
- options:
  - "Yes, proceed to planning"
  - "Need more research" (describe what)
  - "Stop here for now"
```

### Stage 2: Plan

After research approval, invoke the plan skill:
```
Use Skill tool with:
- skill: "plan"
- args: "<requirements summary from research>"
```

After planning completes:
1. Update work document status to "Implementation"
2. Present plan summary to user
3. Ask for approval to proceed:

```
AskUserQuestion:
- question: "Plan complete. Ready to proceed to implementation?"
- options:
  - "Yes, start implementing"
  - "Modify the plan" (describe changes)
  - "Stop here for now"
```

### Stage 3: Implement

After plan approval, invoke the implement skill:
```
Use Skill tool with:
- skill: "implement"
```

After implementation completes:
1. Update work document status to "Complete"
2. Present implementation summary
3. Show files modified and next steps

## Error Handling

### If research needs more input:
- Ask clarifying questions
- Continue research after answers

### If plan needs adjustment:
- Modify tasks as requested
- Re-present for approval

### If implementation hits blockers:
- Report blocker to user
- Ask how to proceed
- Update tasks accordingly

## Stage Transitions

Each stage transition requires **explicit user approval**:

```
Research ──[approval]──> Plan ──[approval]──> Implement ──> Complete
    │                      │                      │
    └── [need more] ───────┴── [modify] ──────────┘
```

Users can:
- Continue to next stage
- Request more work in current stage
- Stop and resume later

## Guidelines

- Always create/update work document first
- Get explicit approval before stage transitions
- Keep user informed of progress
- Document everything in the work document
- Handle interruptions gracefully (user can `/rpi` again to continue)

## Resuming Work

If `/rpi` is called with a ticketID that has an existing work document:
1. Find the most recent work document for that ticketID
2. Check its status
3. Ask user if they want to continue or start fresh

```
AskUserQuestion:
- question: "Found existing work for <ticketID> at status: <status>. Continue or start fresh?"
- options:
  - "Continue from <status>"
  - "Start fresh"
```
