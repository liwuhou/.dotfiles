# Core Concepts
## Task Parallelizability Assessment

### Parallelizable Features (meet any one to split)
1. **Independent subtasks** - Task can be split into multiple independent parts
   - Example: "Write components for 3 different pages", "Analyze 5 different data files"

2. **Parallel exploration of solutions** - Need to explore multiple solutions/implementations simultaneously
   - Example: "Compare 3 different design solutions", "Try multiple repair methods"

3. **Batch processing** - Perform the same operation on multiple similar items
   - Example: "Add TypeScript types to all 10 components", "Write tests for each API endpoint"

4. **Multi-domain/multi-dimensional analysis** - Task involves multiple independent domains
   - Example: "Simultaneously analyze frontend performance, backend latency, database queries"

### Non-parallelizable Features
1. **Strong dependency chain** - Subsequent steps depend on the output of previous steps
   - Example: "First analyze the code, then refactor based on the analysis results"

2. **Single atomic task** - Task itself is the smallest unit
   - Example: "Fix this specific bug", "Explain this code"

3. **Context sensitive** - Need to continuously understand the evolution of the same context
   - Example: "Gradually debug this problem", "Help me sort out the design idea of this feature"

### Cases where parallelism is unnecessary
1. **Simple tasks** - Single agent can complete quickly
2. **Exploratory tasks** - Need to understand the problem first before deciding direction
3. **User did not explicitly request** - User did not express willingness for multi-agent collaboration