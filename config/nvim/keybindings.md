# LazyVim 自定义快捷键

LazyVim 的默认快捷键由 WhichKey 动态展示；在普通模式按 `<Space>` 查看完整列表。以下仅记录本仓库的自定义映射。

| 快捷键 | 模式 | 说明 |
|---|---|---|
| `<C-j>` / `<C-k>` | n, x, i | 向下 / 向上移动 5 行 |
| `H` / `J` / `K` / `L` | n, x | 切换左 / 下 / 上 / 右窗口 |
| `<C-M-h/j/k/l>` | n | 调整当前窗口宽度 / 高度 |
| `<C-s>` | n, i, x | 保存文件 |
| `gh` | n | LSP 悬浮文档 |
| `<leader>wv` / `<leader>wh` | n | 垂直 / 水平分屏 |
| `<leader>wc` / `<leader>wo` / `<leader>w=` | n | 关闭窗口 / 仅保留当前 / 均分窗口 |
| `<leader>lm` | n | 切换 Neominimap |
| `<leader>ts` | n | 切换 Onedark 样式 |
| `zR` / `zM` | n | 展开 / 收起所有折叠 |
| `<leader>lf` | n, x | 使用 Conform 格式化 |
| `<leader>xx` | n | 打开诊断列表 |
| `<leader>S` | n | 打开 Spectre 查找替换 |
| `<leader>mt` / `mn` / `mp` | n | 切换 / 下一个 / 上一个标记 |
| `<leader>md` / `mD` | n | 删除当前行 / 当前 Buffer 的标记 |
| `<leader>ml` / `ma` / `mg` | n | 列出当前 Buffer / 全部 / 全局标记 |
| `<leader>yr` / `<leader>yR` | n, x | 复制相对 / 绝对 `@file:line` 引用 |
| `<C-\\>` / `<M-3>` | n, t | 切换浮动终端 |
| `<M-1>` / `<M-2>` | n, t | 切换底部 / 右侧终端 |
| `<leader>bf` / `<leader>bn` | n | 查找 / 下一个 Buffer |
| `<leader>la` / `ld` / `lw` | n, x | Code Action / 当前 Buffer / 工作区诊断 |
| `<leader>li` / `lI` / `lj` / `lk` | n | LSP 信息 / Mason / 下一个 / 上一个诊断 |
| `<leader>ll` / `lq` / `lr` | n | CodeLens / 诊断 Quickfix / 重命名 |
| `<leader>ls` / `lS` / `le` | n | 文档符号 / 工作区符号 / Quickfix 列表 |
| `<leader>gj` / `gk` / `gr` / `gR` / `gu` / `go` | n, x | Git hunk 导航、重置、撤销暂存与状态 |

仪表板：`p` 打开项目选择，`g` 在 `~/Data/frontend` 中全文搜索，`d` 打开 dotfiles，`q` 退出。
