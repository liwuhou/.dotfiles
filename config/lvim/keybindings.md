# LunarVim 快捷键列表

## 一、被禁用的默认快捷键

| 快捷键 | 模式 | 说明 |
|---|---|---|
| `<C-j>` `<C-k>` `<C-l>` `<C-h>` | n, v, t | 原默认的 buffer 导航已清除 |
| `<C-Up>` `<C-Down>` `<C-Left>` `<C-Right>` `<C-=>` | n, v, t | 原默认的窗口操作已清除 |
| `K` | n | 原默认的 LSP hover 已移除（替换为 `gh`） |

## 二、自定义快捷键

| 快捷键 | 模式 | 映射 | 说明 |
|---|---|---|---|
| `<C-j>` | n, v | `5j` | 向下快速移动 5 行 |
| `<C-k>` | n, v | `5k` | 向上快速移动 5 行 |
| `<C-j>` | i | `<ESC>5ji` | 插入模式下移 5 行 |
| `<C-k>` | i | `<ESC>5ki` | 插入模式下移 5 行 |
| `J` | n, v | `<C-w>j` | 切换到下方窗口 |
| `K` | n, v | `<C-w>k` | 切换到上方窗口 |
| `H` | n, v | `<C-w>h` | 切换到左方窗口 |
| `L` | n, v | `<C-w>l` | 切换到右方窗口 |
| `<C-M-j>` | n | `:resize -2` | 缩小窗口高度 |
| `<C-M-k>` | n | `:resize +2` | 增大窗口高度 |
| `<C-M-h>` | n | `:vertical resize -2` | 缩小窗口宽度 |
| `<C-M-l>` | n | `:vertical resize +2` | 增大窗口宽度 |
| `<` | v | `<gv` | 左缩进后保持选区 |
| `>` | v | `>gv` | 右缩进后保持选区 |
| `<C-s>` | n, i, v | `:w!` | 保存文件 |

## 三、LSP 快捷键

| 快捷键 | 模式 | 映射 | 说明 |
|---|---|---|---|
| `gh` | n | `vim.lsp.buf.hover()` | 显示悬浮文档（自定义） |
| `gd` | n | `vim.lsp.buf.definition()` | 跳转到定义 |
| `gD` | n | `vim.lsp.buf.declaration()` | 跳转到声明 |
| `gr` | n | `vim.lsp.buf.references()` | 查看引用 |
| `gI` | n | `vim.lsp.buf.implementation()` | 跳转到实现 |
| `gs` | n | `vim.lsp.buf.signature_help()` | 签名帮助 |
| `gl` | n | `vim.diagnostic.open_float()` | 显示行诊断信息 |

## 四、Which-Key 快捷键（`<Space>` 前缀）

### 基础

| 快捷键 | 说明 |
|---|---|
| `<Space>;` | Dashboard |
| `<Space>w` | **窗口分组**（自定义覆盖） |
| `<Space>w v` | 垂直分屏 |
| `<Space>w h` | 水平分屏 |
| `<Space>w c` | 关闭当前窗口 |
| `<Space>w o` | 关闭其他窗口 |
| `<Space>w =` | 均分所有窗口 |
| `<Space>q` | 退出 |
| `<Space>/` | 注释当前行 |
| `<Space>c` | 关闭 Buffer |
| `<Space>f` | 查找文件 |
| `<Space>h` | 取消搜索高亮 |
| `<Space>e` | 文件树 |
| `<Space>lm` | **Minimap 开关**（自定义） |

### `<Space>b` — Buffers

| 快捷键 | 说明 |
|---|---|
| `<Space>b j` | 跳转到 Buffer |
| `<Space>b f` | 查找 Buffer |
| `<Space>b b` | 上一个 Buffer |
| `<Space>b n` | 下一个 Buffer |
| `<Space>b W` | 不格式化保存 |
| `<Space>b e` | 选择关闭 Buffer |
| `<Space>b h` | 关闭左侧所有 Buffer |
| `<Space>b l` | 关闭右侧所有 Buffer |
| `<Space>b D` | 按目录排序 |
| `<Space>b L` | 按语言排序 |

### `<Space>d` — Debug

| 快捷键 | 说明 |
|---|---|
| `<Space>d t` | 切换断点 |
| `<Space>d b` | 回退一步 |
| `<Space>d c` | 继续 |
| `<Space>d C` | 运行到光标 |
| `<Space>d d` | 断开 |
| `<Space>d g` | 获取 Session |
| `<Space>d i` | Step Into |
| `<Space>d o` | Step Over |
| `<Space>d u` | Step Out |
| `<Space>d p` | 暂停 |
| `<Space>d r` | Toggle Repl |
| `<Space>d s` | 启动调试 |
| `<Space>d q` | 退出调试 |
| `<Space>d U` | Toggle DAP UI |

### `<Space>p` — Plugins

| 快捷键 | 说明 |
|---|---|
| `<Space>p i` | Lazy install |
| `<Space>p s` | Lazy sync |
| `<Space>p S` | Lazy status |
| `<Space>p c` | Lazy clean |
| `<Space>p u` | Lazy update |
| `<Space>p p` | Lazy profile |
| `<Space>p l` | Lazy log |
| `<Space>p d` | Lazy debug |

### `<Space>g` — Git

| 快捷键 | 说明 |
|---|---|
| `<Space>g g` | Lazygit |
| `<Space>g j` | 下一个 Hunk |
| `<Space>g k` | 上一个 Hunk |
| `<Space>g l` | Blame 当前行 |
| `<Space>g L` | Blame 当前行（完整） |
| `<Space>g p` | 预览 Hunk |
| `<Space>g r` | 重置 Hunk |
| `<Space>g R` | 重置 Buffer |
| `<Space>g s` | Stage Hunk |
| `<Space>g u` | Undo Stage Hunk |
| `<Space>g o` | 查看变更文件 |
| `<Space>g b` | 切换分支 |
| `<Space>g c` | 查看提交 |
| `<Space>g C` | 查看当前文件提交 |
| `<Space>g d` | Git Diff |

### `<Space>l` — LSP

| 快捷键 | 说明 |
|---|---|
| `<Space>l a` | Code Action |
| `<Space>l d` | Buffer 诊断 |
| `<Space>l w` | 所有诊断 |
| `<Space>l f` | 格式化 |
| `<Space>l i` | LspInfo |
| `<Space>l I` | Mason Info |
| `<Space>l j` | 下一个诊断 |
| `<Space>l k` | 上一个诊断 |
| `<Space>l l` | CodeLens Action |
| `<Space>l q` | Quickfix |
| `<Space>l r` | 重命名 |
| `<Space>l s` | Document Symbols |
| `<Space>l S` | Workspace Symbols |
| `<Space>l e` | Telescope Quickfix |

### `<Space>L` — LunarVim

| 快捷键 | 说明 |
|---|---|
| `<Space>L c` | 编辑 config.lua |
| `<Space>L d` | 查看文档 |
| `<Space>L f` | 查找 LunarVim 文件 |
| `<Space>L g` | 搜索 LunarVim 文件 |
| `<Space>L k` | 查看快捷键 |
| `<Space>L i` | Toggle 信息弹窗 |
| `<Space>L I` | 查看更新日志 |
| `<Space>L l d` | 查看默认日志 |
| `<Space>L l D` | 打开默认日志 |
| `<Space>L l l` | 查看 LSP 日志 |
| `<Space>L l L` | 打开 LSP 日志 |
| `<Space>L l n` | 查看 Neovim 日志 |
| `<Space>L l N` | 打开 Neovim 日志 |
| `<Space>L r` | 重载配置 |
| `<Space>L u` | 更新 LunarVim |

### `<Space>s` — Search

| 快捷键 | 说明 |
|---|---|
| `<Space>s b` | 搜索分支 |
| `<Space>s c` | 搜索 Colorscheme |
| `<Space>s f` | 搜索文件 |
| `<Space>s h` | 搜索帮助 |
| `<Space>s H` | 搜索高亮组 |
| `<Space>s M` | 搜索 Man Pages |
| `<Space>s r` | 最近文件 |
| `<Space>s R` | 搜索寄存器 |
| `<Space>s t` | 全文搜索 |
| `<Space>s k` | 搜索快捷键 |
| `<Space>s C` | 搜索命令 |
| `<Space>s l` | 恢复上次搜索 |
| `<Space>s p` | 预览 Colorscheme |

### `<Space>T` — Treesitter

| 快捷键 | 说明 |
|---|---|
| `<Space>T i` | TSConfigInfo |

## 五、Visual 模式 Which-Key（`<Space>` 前缀）

| 快捷键 | 说明 |
|---|---|
| `<Space>/` | 注释选中区域 |
| `<Space>l a` | Code Action |
| `<Space>g r` | 重置 Hunk |
| `<Space>g s` | Stage Hunk |

## 六、终端快捷键

| 快捷键 | 说明 |
|---|---|
| `<C-\>` | 打开/关闭浮动终端 |
| `<M-1>` | 水平终端 |
| `<M-2>` | 垂直终端 |
| `<M-3>` | 浮动终端 |
