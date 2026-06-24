# multi-agent

A powerful LLM Skill for coordinating multiple agents to execute tasks in parallel. Compatible with any LLM client that supports the skills.sh protocol.

## ✨ Features

- **Intelligent Parallelizability Assessment**: Automatically determines if a task can be split into independent subtasks
- **Smart Task Splitting**: Splits complex tasks into clear, independent subtasks with well-defined inputs/outputs
- **Isolated Execution**: Uses git worktree to isolate each sub-agent's work environment, preventing conflicts
- **Concurrent Execution**: Launches all sub-agents in parallel for maximum efficiency
- **Flexible Merge Strategies**: Supports code merging, result aggregation, and solution comparison based on task type
- **User Confirmation**: Optional confirmation step before executing split schemes
- **Configurable**: Customizable max parallel agents, worktree settings, and cleanup behavior

## 🚀 Installation

```bash
npx skills add awu/skills/multi-agent
```

## 📖 Usage

### Basic Usage
```bash
/multi-agent "Your complex task description here"
```

### With Parameters
```bash
# Limit to 3 parallel agents
/multi-agent "Task description" --max-agents 3

# Don't use git worktree isolation
/multi-agent "Task description" --no-worktree

# Only show split scheme, don't execute
/multi-agent "Task description" --dry-run

# Skip user confirmation step
/multi-agent "Task description" --no-confirm
```

### Common Use Cases
```bash
# Parallel component development
/multi-agent "Write React components for home, about, and contact pages"

# Multi-solution exploration
/multi-agent "Compare Redis, in-memory, and CDN caching strategies for our API"

# Batch processing
/multi-agent "Add TypeScript types to all 15 API endpoint files"

# Multi-domain analysis
/multi-agent "Analyze frontend performance, backend latency, and database query efficiency"
```

## ⚙️ Configuration
Add to `.claude/settings.json`:
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

## 📋 Workflow
1. **Assessment**: Analyze task to determine if parallel execution is beneficial
2. **Splitting**: Break into independent subtasks with clear goals
3. **Confirmation**: Present split scheme to user for approval (optional)
4. **Isolation**: Create git worktrees for each subtask
5. **Execution**: Launch sub-agents in parallel
6. **Collection**: Gather results from all sub-agents
7. **Merging**: Combine results using appropriate strategy
8. **Reporting**: Present unified results to user

## 🛡️ Best Practices Followed
This skill follows all official Skill best practices:
- ✅ Progressive loading: SKILL.md < 100 lines, all detailed content in references/
- ✅ Rich trigger keywords in description for high trigger rate
- ✅ Clear step-by-step workflow checklist with blocking nodes
- ✅ All templates and guides loaded on demand
- ✅ User confirmation nodes before critical operations
- ✅ Flexible parameter system with argument hints
- ✅ Well-organized references directory structure

## 📝 License
MIT