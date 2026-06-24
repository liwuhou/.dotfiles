# Configuration Options
Users can configure in `.claude/settings.json`:

```json
{
  "multi-agent": {
    "max_parallel_agents": 5,
    "use_git_worktree": true,
    "auto_cleanup": false,
    "worktree_base": "./worktrees"
  }
}
```

## Configuration Options Explained
- `max_parallel_agents`: Maximum number of agents to run in parallel (default: 5)
- `use_git_worktree`: Whether to use git worktree for environment isolation (default: true)
- `auto_cleanup`: Whether to automatically delete worktrees and branches after task completion (default: false)
- `worktree_base`: Base directory for storing worktrees (default: "./worktrees")