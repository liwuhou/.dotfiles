# Coordinator Guide
## Responsibilities
1. **Task Splitting** - Split main task into independent subtasks
2. **Resource Allocation** - Assign working directories and branches for each subtask
3. **Sub-Agent Launch** - Start multiple sub-agents in parallel
4. **Progress Tracking** - Monitor status of each subtask
5. **Exception Handling** - Handle subtask failures or timeouts

## Input
- Main task description
- Maximum number of parallel agents (default 3-5)
- Base working directory path (default `./worktrees`)

## Output
- `task_decomposition.json` - Task decomposition details
- Output directories for each sub-agent
- Summary report

## Task Splitting Principles
### Good Splits
- **No shared state** between subtasks
- Each subtask has **clear input/output**
- Subtasks can be **completed independently** without intercommunication
- Low merge cost (no code conflicts or results are easy to aggregate)

### Bad Splits
- Subtasks require frequent synchronization
- Modifications to the same file are shared
- Output of one subtask is input to another
- Complex conflict resolution required during merging

## Parallel Execution Guide
### Launch all sub-agents at once
```python
# Pseudo-code example
subagents = []
for subtask in subtasks:
    sa = spawn_subagent(
        prompt=create_prompt(subtask),
        workdir=subtask.work_dir,
        output_dir=subtask.output_dir
    )
    subagents.append(sa)

# Wait for all to complete
results = wait_all(subagents)
```

**Critical**: Do not launch sequentially! All sub-agents should be started in the same turn to achieve true parallelism.

## Progress Tracking
Record for each subtask:
```json
{
  "subtask_id": "subtask-1",
  "status": "running|completed|failed",
  "started_at": "2024-01-01T10:00:00Z",
  "completed_at": "2024-01-01T10:15:00Z",
  "output_path": "/path/to/output",
  "user_notes": "/path/to/user_notes.md"
}
```

## Exception Handling
### Sub-Agent Failure
1. Record failure reason (error message, logs)
2. Assess if retry is possible
3. If unrecoverable:
   - Notify user
   - Provide fallback option (e.g., switch to single-agent execution)

### Timeout Handling
Set reasonable timeout for subtasks (default 30 minutes):
- Ask user if they want to continue waiting after timeout
- Or terminate the subtask and proceed with partial completion