---
name: multi-agent
description: "Coordinate multiple agents to execute tasks in parallel. Use when user says 'use multiple agents in parallel', 'split task', 'concurrent execution', 'do multiple things at the same time', '/multi-agent', or any explicit request for multi-agent collaboration on complex tasks. Automatically assesses task parallelizability, splits subtasks, and coordinates execution."
argument-hint: "[task] [--max-agents N] [--no-worktree] [--dry-run] [--no-confirm]"
allowed-tools:
  - Agent
  - Bash
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

# Multi-Agent Coordinator

Assess if a task can be split into multiple parallelizable subtasks, and coordinate multiple sub-agents to execute concurrently when appropriate. Execute directly when parallelism is unnecessary or impossible.

## Workflow Checklist
Copy this checklist and check off items as you complete them:

Multi-Agent Workflow Progress:
- [ ] Step 0: Load core concepts ⛔ BLOCKING
  - [ ] Read references/core-concepts.md for parallelizability assessment criteria
  - [ ] Load templates from references/templates.md if needed
- [ ] Step 1: Assess task parallelizability ⛔ BLOCKING
  - [ ] Ask yourself: Can this task be split into independent subtasks?
  - [ ] Ask yourself: Did the user explicitly request parallel execution?
  - [ ] Ask yourself: Will splitting provide significant performance benefits?
- [ ] Step 2: Decision Branch
  - [ ] Branch A: Not parallelizable/unnecessary → Go to Step 8 (Direct Execution)
  - [ ] Branch B: Parallelizable → Continue to Step 3
- [ ] Step 3: Split into subtasks
  - [ ] Split into 2-5 independent subtasks (max based on --max-agents parameter)
  - [ ] Define clear goals, inputs/outputs, and acceptance criteria for each subtask
  - [ ] Save decomposition to task_decomposition.json using template from references/templates.md
- [ ] Step 4: Confirm split scheme with user ⚠️ REQUIRED (unless --no-confirm flag is set)
  - [ ] Present split scheme to user using template from references/templates.md
  - [ ] Get explicit user approval before proceeding
  - [ ] Adjust split based on user feedback if needed
- [ ] Step 5: Prepare execution environment
  - [ ] If --no-worktree flag is NOT set: Create git worktree for each subtask
  - [ ] Create output directories for each subtask
- [ ] Step 6: Execute subtasks in parallel
  - [ ] Spawn one sub-agent per subtask with isolated working directory
  - [ ] Use sub-agent prompt template from references/templates.md
  - [ ] Start all agents concurrently, not sequentially
  - [ ] Read references/coordinator-guide.md for best practices
- [ ] Step 7: Collect and merge results
  - [ ] Wait for all sub-agents to complete
  - [ ] Collect outputs from each subtask directory
  - [ ] Choose appropriate merge strategy based on task type
  - [ ] Check for conflicts or issues
  - [ ] Read references/scenario-handling.md for edge case handling
  - [ ] Read references/merger-guide.md for merging best practices
- [ ] Step 8: Final output
  - [ ] If executed directly: Present task results
  - [ ] If parallel execution: Present merged results using summary template from references/templates.md
  - [ ] Clean up worktrees if auto_cleanup is enabled in settings
  - [ ] Ask user if they need further assistance

## Parameter Reference
| Parameter | Description | Default |
|-----------|-------------|---------|
| `--max-agents N` | Maximum number of parallel agents | 5 |
| `--no-worktree` | Don't use git worktree isolation | false |
| `--dry-run` | Only assess parallelizability and show split scheme, don't execute | false |
| `--no-confirm` | Skip user confirmation step for split scheme | false |

## Issue Severity Definitions
| Severity | Meaning | Handling |
|----------|---------|----------|
| P0 | Critical failure, task cannot continue | Notify user immediately and stop |
| P1 | Subtask failure, but overall task can continue | Record issue and proceed with remaining subtasks |
| P2 | Minor issue, no impact on overall execution | Record in notes and mention in final report |
| P3 | Optimization suggestion | Note for future improvements |

## Configuration
See references/configuration.md for available user configuration options.

## Usage Examples
See references/examples.md for detailed usage examples.

## Special Scenarios
See references/scenario-handling.md for handling edge cases and exceptions.