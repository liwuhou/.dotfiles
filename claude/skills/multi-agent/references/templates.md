# Templates
## Task Decomposition JSON Template
Save decomposition results to `task_decomposition.json`:
```json
{
  "main_task": "Main task description",
  "decomposition_rationale": "Why it can be split in parallel",
  "subtasks": [
    {
      "id": "subtask-1",
      "name": "Short name",
      "description": "Detailed subtask description",
      "expected_output": "Expected output format",
      "worktree_branch": "feature/subtask-1",
      "work_dir": "./worktrees/subtask-1"
    }
  ]
}
```

## Git Worktree Commands
```bash
# 1. Ensure main repository is clean
git status

# 2. Create worktree for each subtask
git worktree add -b <branch-name> <worktree-path> [base-branch]

# Example:
git worktree add -b feature/agent-1 ./worktrees/agent-1 main
git worktree add -b feature/agent-2 ./worktrees/agent-2 main
```

## Sub-Agent Prompt Template
```
Execute this subtask:
- Task ID: subtask-{N}
- Task description: {description}
- Working directory: {worktree-path}
- Expected output: {expected-output}
- Save output to: {outputs-dir}/subtask-{N}/

Constraints:
1. All code modifications must be within the working directory
2. Commit code to current branch after completion
3. Do not modify content of other subtasks
4. If unsure, record in user_notes.md
```

## Non-parallel Response Template
```markdown
**Task Assessment Result**: Not suitable for parallel execution

**Reason**: [Specific explanation why not parallel/unnecessary]

**Execution Plan**: I will execute this task directly...

[Then start executing the task directly]
```

## Split Scheme Confirmation Template
```markdown
**Task Assessment**: Suitable for parallel execution

**Split Scheme**:
- Plan to split into {N} subtasks:
{list each subtask description}

**Execution Strategy**: Using git worktree isolation, {N} sub-agents will run in parallel
**Estimated time**: {X-Y} minutes

Do you confirm to execute this split scheme?
```

## Code Merge Strategy
```bash
# 1. Return to main repository
cd /path/to/main/repo

# 2. Merge worktree modifications one by one
git merge --no-commit feature/subtask-1
git merge --no-commit feature/subtask-2
# ...

# 3. Resolve possible conflicts
# If conflicts occur, manual intervention or redesign task splitting is required

# 4. Commit merge result
git commit -m "Merge multi-agent subtasks"
```

## Result Summary Template
```markdown
# Multi-Agent Execution Result Summary

## Subtask 1: [Name]
- Status: Completed/Failed
- Output: [Link or summary]
- Notes: [Issues from user_notes]

## Subtask 2: [Name]
...

## Integrated Analysis
[Comprehensive analysis of each subtask result]
```