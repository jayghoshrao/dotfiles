---
name: implement
description: Implementation stage - execute tasks with parallel subagents, track progress, update work document
argument-hint: [optional: specific task IDs to run]
allowed-tools: Read, Edit, Write, Bash, Grep, Glob, Task, TaskCreate, TaskUpdate, TaskList, TaskGet
---

# Implement Stage

You are conducting the **Implement Stage** of the RPI workflow.

## Your Mission

Execute implementation tasks by:
1. Finding unblocked tasks
2. Spawning parallel implementer agents (haiku)
3. Updating task status on completion
4. Continuing until all tasks complete

## Input

Optional task filter: **$ARGUMENTS**

If arguments provided, only run those specific task IDs.
Otherwise, run all pending tasks from the task list.

## Process

### Step 1: Get Task List

Use TaskList to see all tasks and their status.

Identify tasks that are:
- Status: `pending`
- blockedBy: empty or all completed

### Step 2: Spawn Parallel Implementers

For each unblocked task, spawn an implementer agent:

```
Use Task tool with:
- subagent_type: "general-purpose"
- model: "haiku"
- description: "Implement: [task subject]"
- prompt: |
    You are an implementer agent. Complete this task:

    **Task**: [subject]
    **Description**: [full description]

    Guidelines:
    - Read relevant files first
    - Make minimal, focused changes
    - Follow existing code patterns exactly
    - Report what you changed

    When done, report:
    - Files modified
    - Changes made
    - Any issues encountered
- run_in_background: true
```

Spawn multiple agents in parallel (up to 3-4 at once).

### Step 3: Monitor Progress

As agents complete:
1. Check their output using Read on output_file
2. Update task status with TaskUpdate (status: "completed")
3. Check if new tasks are now unblocked
4. Spawn new agents for unblocked tasks

### Step 4: Handle Issues

If an agent reports blockers or issues:
1. Assess if it's a real blocker or minor issue
2. For blockers: create new task or ask user
3. For minor issues: note and continue

### Step 5: Update Work Document

Periodically update the work document:

```markdown
## Implementation Stage

### Progress Log
| Time | Task | Status | Notes |
|------|------|--------|-------|
| HH:MM | [task] | completed | [brief note] |
| HH:MM | [task] | in_progress | [agent running] |

### Completed Tasks
- [x] Task 1: [subject]
- [x] Task 2: [subject]
- [ ] Task 3: [subject] (in progress)

### Issues Encountered
- [Issue description and resolution]
```

### Step 6: Completion

When all tasks are complete:

1. Update work document summary:

```markdown
## Summary

### What Was Done
[Brief description of work completed]

### Files Modified
- [file1]: [what changed]
- [file2]: [what changed]

### Next Steps
[Any follow-up items or recommendations]
```

2. Report to user:
   - Tasks completed
   - Files modified
   - Any issues encountered
   - Recommendations for testing/verification

## Parallel Execution Strategy

```
Round 1: Spawn agents for all initially unblocked tasks
         [Task A] [Task B] [Task C] (parallel)
              |       |       |
Round 2: As tasks complete, spawn newly unblocked
         [Task D] [Task E] (parallel, were blocked by A, B)
              |       |
Round 3: Continue until done
         [Task F] (was blocked by D)
```

## Guidelines

- Use haiku model for speed and cost
- Spawn up to 3-4 agents in parallel
- Update task status immediately on completion
- Keep work document updated periodically
- Handle errors gracefully - don't stop on one failure
- Report progress to user for long-running implementations
