# Usage Examples
## Example 1: Parallel Component Writing
**User**: "Use multiple agents in parallel: Write React components for the home page, about page, and contact page respectively"

**Response**:
```
**Task Assessment**: Suitable for parallel execution

**Split Scheme**:
- Subtask 1: Write home page component (HomePage.tsx)
- Subtask 2: Write about page component (AboutPage.tsx)
- Subtask 3: Write contact page component (ContactPage.tsx)

Each subtask will run independently, using git worktree to isolate code modifications.
Estimated 15-20 minutes to complete all subtasks.

Do you confirm to execute this scheme?
```

## Example 2: Single Task No Split Needed
**User**: "Use multiple agents in parallel: Fix the issue where the login button click is invalid"

**Response**:
```
**Task Assessment Result**: Not suitable for parallel execution

**Reason**: This is a single debugging task that requires understanding the complete event flow of the login button. After splitting, each subtask will share the same context and cannot be truly parallel.

**Execution Plan**: I will execute this task directly, following these steps:
1. Check the login button's event binding
2. View the click handler function
3. Locate and fix the issue

Starting execution...
```

## Example 3: Solution Exploration
**User**: "Compare 3 different caching strategies for our API endpoints"

**Response**:
```
**Task Assessment**: Suitable for parallel execution

**Split Scheme**:
- Subtask 1: Research and implement Redis caching strategy
- Subtask 2: Research and implement in-memory caching strategy
- Subtask 3: Research and implement CDN caching strategy
- Each subtask will provide performance analysis and implementation costs

**Execution Strategy**: 3 sub-agents will run in parallel to research different strategies
**Estimated time**: 20-30 minutes

Do you confirm to execute this scheme?
```