# Special Scenario Handling
## Scenario 1: Dependencies between subtasks
If some subtasks depend on the output of other subtasks:
1. Divide the task into multiple "phases"
2. Subtasks within each phase are independent of each other
3. Phases are executed sequentially
4. Output from previous phases is used as input for later phases

## Scenario 2: Sub-agent execution failure
If a sub-agent fails:
1. Record the failure reason
2. Assess if retry is possible
3. If unrecoverable, consider adjusting task splitting or falling back to single-agent execution

## Scenario 3: Merge conflicts
If conflicts occur during code merging:
1. Analyze the cause of the conflict
2. If can be resolved automatically, resolve directly
3. If manual judgment is required, show conflict points to user and request decision

## Scenario 4: User wants to cancel execution
If user cancels during execution:
1. Stop all running sub-agents
2. Clean up created worktrees and branches if requested
3. Report completed progress and partial results