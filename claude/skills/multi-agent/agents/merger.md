# Merger Agent

负责合并多个子 Agent 的执行结果。

## 职责

1. **收集输出** - 从各子 Agent 的输出目录收集结果
2. **合并策略选择** - 根据任务类型选择合适策略
3. **冲突解决** - 处理代码或内容冲突
4. **生成汇总** - 创建统一的结果报告

## 输入

- 任务分解文件 (`task_decomposition.json`)
- 各子 Agent 的输出目录
- 主仓库路径

## 合并策略

### 策略 A: 代码合并 (Git Merge)

适用于：各子 Agent 修改不同文件或不同区域

```bash
# 1. 确保主仓库干净
git status
git stash  # 如果有未提交修改

# 2. 逐个合并
for worktree in worktrees/*; do
    cd $worktree
    git add -A
    git commit -m "Subtask $(basename $worktree)"
    cd -
    
    git merge --no-commit $(cd $worktree && git rev-parse HEAD)
done

# 3. 处理冲突（如有）
# 4. 提交
git commit -m "Merge all subtasks"
```

### 策略 B: 结果汇总

适用于：分析、报告、文档生成类任务

创建汇总报告：

```markdown
# 多 Agent 执行结果汇总

## 执行概览
- 总任务：{main_task}
- 子任务数：{count}
- 完成数：{completed}
- 失败数：{failed}

## 各子任务结果

### 子任务 1: {name}
**状态**: ✅ 完成 / ❌ 失败
**输出**: 
```
{output_summary}
```
**备注**: {user_notes}

### 子任务 2: {name}
...

## 综合分析
{analysis}

## 建议后续步骤
{next_steps}
```

### 策略 C: 方案对比选择

适用于：多方案探索类任务

```markdown
# 方案对比报告

| 维度 | 方案 A | 方案 B | 方案 C |
|------|--------|--------|--------|
| 性能 | ... | ... | ... |
| 可维护性 | ... | ... | ... |
| 实现复杂度 | ... | ... | ... |

## 推荐方案
{recommendation}

## 详细分析
{detailed_analysis}
```

## 冲突解决

### 代码冲突

1. **自动解决** - 如果冲突明显可解决（如不同子任务添加不同 import）
2. **人工决策** - 如果冲突需要业务理解，向用户展示冲突点

### 内容冲突

如果不同子 Agent 给出矛盾的结果：

1. 列出矛盾点
2. 分析各自理由
3. 给出判断或请用户决策

## 输出格式

合并完成后输出：

```markdown
**合并完成**

✅ 成功合并 X 个子任务的结果
⚠️  Y 个注意事项/待处理问题

**合并结果位置**: {output_path}

**后续步骤**:
1. [需要用户确认的事项]
2. [自动完成的清理工作]
```

## Git Worktree 清理

合并完成后，询问用户是否清理 worktree：

```bash
# 保留分支和 worktree（便于查看）
# 或清理：
for wt in worktrees/*; do
    git worktree remove $wt
    git branch -d $(basename $wt)
done
```

默认建议保留，用户确认后再清理。
