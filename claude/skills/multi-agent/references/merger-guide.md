# Merger Guide
## Responsibilities
1. **Output Collection** - Gather results from each sub-agent's output directory
2. **Merge Strategy Selection** - Choose appropriate strategy based on task type
3. **Conflict Resolution** - Handle code or content conflicts
4. **Summary Generation** - Create unified result report

## Input
- Task decomposition file (`task_decomposition.json`)
- Output directories for each sub-agent
- Main repository path

## Merge Strategies
### Strategy A: Code Merge (Git Merge)
Suitable for: Sub-agents modify different files or different regions

```bash
# 1. Ensure main repository is clean
git status
git stash  # If there are uncommitted changes

# 2. Merge one by one
for worktree in worktrees/*; do
    cd $worktree
    git add -A
    git commit -m "Subtask $(basename $worktree)"
    cd -
    
    git merge --no-commit $(cd $worktree && git rev-parse HEAD)
done

# 3. Handle conflicts (if any)
# 4. Commit
git commit -m "Merge all subtasks"
```

### Strategy B: Result Aggregation
Suitable for: Analysis, reporting, document generation tasks

Create summary report:
```markdown
# Multi-Agent Execution Result Summary

## Execution Overview
- Main task: {main_task}
- Total subtasks: {count}
- Completed: {completed}
- Failed: {failed}

## Subtask Results

### Subtask 1: {name}
**Status**: ✅ Completed / ❌ Failed
**Output**: 
```
{output_summary}
```
**Notes**: {user_notes}

### Subtask 2: {name}
...

## Comprehensive Analysis
{analysis}

## Recommended Next Steps
{next_steps}
```

### Strategy C: Solution Comparison & Selection
Suitable for: Multi-solution exploration tasks

```markdown
# Solution Comparison Report

| Dimension | Solution A | Solution B | Solution C |
|-----------|------------|------------|------------|
| Performance | ... | ... | ... |
| Maintainability | ... | ... | ... |
| Implementation Complexity | ... | ... | ... |

## Recommended Solution
{recommendation}

## Detailed Analysis
{detailed_analysis}
```

## Conflict Resolution
### Code Conflicts
1. **Auto-resolve** - If conflicts are obviously resolvable (e.g., different imports added by different subtasks)
2. **Human decision** - If conflicts require business understanding, show conflict points to user

### Content Conflicts
If different sub-agents provide contradictory results:
1. List the contradictions
2. Analyze their respective reasons
3. Provide judgment or ask user for decision

## Output Format
After merging is complete, output:
```markdown
**Merge Completed**

✅ Successfully merged results from X subtasks
⚠️  Y notes/pending issues

**Merge result location**: {output_path}

**Next steps**:
1. [Matters requiring user confirmation]
2. [Automatic cleanup work completed]
```

## Git Worktree Cleanup
After merging, ask user if they want to clean up worktrees:
```bash
# Keep branches and worktrees (for easy viewing)
# Or clean up:
for wt in worktrees/*; do
    git worktree remove $wt
    git branch -d $(basename $wt)
done
```

Default recommendation is to keep, clean up only after user confirmation.