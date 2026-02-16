---
name: plan
description: Planning stage - design solution options, break into phases and tasks, create task list with dependencies
argument-hint: [requirements or context]
allowed-tools: Read, Grep, Glob, Task, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion, Write
---

# Plan Stage

You are conducting the **Plan Stage** of the RPI workflow.

## Your Mission

Create a comprehensive implementation plan by:
1. Presenting solution options
2. Getting user selection
3. Breaking into phases (user stories)
4. Creating atomic tasks with dependencies

## Input

Planning context: **$ARGUMENTS**

If no arguments, check the work document or ask user for requirements.

## Process

### Step 1: Understand Requirements

If research was done, review the work document:
- Look in `Notes/Work/` for recent work docs
- Understand the problem and constraints
- Note clarified requirements

### Step 2: Design Solution Options

Present 2-3 approaches using AskUserQuestion:

```
Question: "Which approach should we take?"
Options:
- Option A: [Name] - [Brief description, key trade-off]
- Option B: [Name] - [Brief description, key trade-off]
- Option C: [Name] - [Brief description, key trade-off]
```

Include your recommendation with reasoning.

### Step 3: Break Into Phases

After user selects an approach, divide into phases:
- Each phase = a user story (delivers value)
- Phases should be independently testable
- Order by dependency and value

### Step 4: Create Atomic Tasks

For each phase, create tasks using TaskCreate:

```
TaskCreate:
- subject: "Brief imperative title"
- description: "Full context needed to implement"
- activeForm: "Present tense status"
```

Task guidelines:
- Small enough for one agent (30 min - 2 hours)
- Clearly scoped and testable
- Include acceptance criteria in description

### Step 5: Set Dependencies

Use TaskUpdate to set blockedBy relationships:

```
TaskUpdate:
- taskId: "[task id]"
- addBlockedBy: ["[blocking task ids]"]
```

Minimize blocking relationships to maximize parallel execution.

### Step 6: Document the Plan

Update the work document with:

```markdown
## Plan Stage

### Solution Options
| Option | Description | Pros | Cons |
|--------|-------------|------|------|
| A | ... | ... | ... |

### Selected Approach
[Which option and why]

### Phases & Tasks
#### Phase 1: [User Story Title]
**Value**: [What user gets]

| ID | Task | Status | Blocked By |
|----|------|--------|------------|
| 1 | ... | pending | - |
| 2 | ... | pending | 1 |

#### Phase 2: [User Story Title]
...
```

### Step 7: Present Plan

Show user:
1. Selected approach summary
2. Phase breakdown with value delivered
3. Task list with dependencies
4. Estimated parallel execution flow

Ask: "Plan complete. Ready to proceed to implementation?"

## Guidelines

- Phases should deliver user value
- Tasks should be atomic and independent
- Minimize dependencies for parallel execution
- Flag risks and mitigation strategies
- Get explicit user approval before proceeding
