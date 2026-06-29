local M = {}

function M.setup()
  -- utf8
  vim.g.encoding = "UTF-8"
  vim.o.fileencoding = 'utf-8'
  -- jkhl 移动时光标周围保留8行
  vim.o.scrolloff = 8
  vim.o.sidescrolloff = 8
  -- 使用相对行号
  vim.wo.number = true
  vim.wo.relativenumber = true
  -- 高亮所在行
  vim.wo.cursorline = false
  -- 显示左侧图标指示列
  vim.wo.signcolumn = "yes"
  -- 右侧参考线，超过表示代码太长了，考虑换行
  vim.o.colorcolumn = "120"
  -- 缩进2个空格等于一个Tab
  vim.o.tabstop = 2
  vim.o.softtabstop = 2
  vim.o.shiftround = true
  -- >> << 时移动长度
  vim.o.shiftwidth = 2
  -- 空格替代tab
  vim.o.expandtab = true
  -- 新行对齐当前行
  vim.o.autoindent = true
  vim.o.smartindent = true
  -- 搜索大小写不敏感，除非包含大写
  vim.o.ignorecase = true
  vim.o.smartcase = true
  -- 搜索高亮匹配结果
  vim.o.hlsearch = true
  -- 边输入边搜索
  vim.o.incsearch = true
  -- 命令行高为2，提供足够的显示空间
  vim.o.cmdheight = 0
  -- 当文件被外部程序修改时，自动加载
  vim.o.autoread = true
  -- 禁止折行
  vim.wo.wrap = true
  -- 光标在行首尾时<Left><Right>可以跳到下一行
  vim.o.whichwrap = '<,>,[,]'
  -- 允许隐藏被修改过的buffer (Neovim 0.11+ 默认已启用)
  -- 鼠标支持
  vim.o.mouse = "a"
  -- 禁止创建备份文件
  vim.o.backup = false
  vim.o.writebackup = false
  vim.o.swapfile = false
  -- smaller updatetime
  vim.o.updatetime = 300
  -- 等待键盘快捷键连击时间
  vim.o.timeoutlen = 350
  -- split window 从下边和右边出现
  vim.o.splitbelow = true
  vim.o.splitright = true
  -- 自动补全不自动选中
  vim.o.completeopt = "menu,menuone,noselect,noinsert"
  -- 样式
  vim.o.background = "dark"
  -- Terminal.app 无 24-bit 真彩色：在里面关掉 termguicolors，让 onedark.nvim 回退到
  -- 256 色 cterm 调色板，而不是发出 Apple Terminal 会直接丢弃的 #rrggbb 序列。
  vim.o.termguicolors = vim.env.TERM_PROGRAM ~= "Apple_Terminal"
  -- 不可见字符的显示，这里只把空格显示为一个点
  vim.o.list = true
  -- vim.o.listchars = "space:·"
  -- 补全增强
  vim.o.wildmode = "longest:full,full"
  -- Don't pass messages to |ins-completion menu|
  vim.opt.shortmess:append("c")
  -- 补全最多显示10行
  vim.o.pumheight = 10
  -- 永远显示 tabline
  vim.o.showtabline = 2
  -- 使用增强状态栏插件后不再需要 vim 的模式提示
  vim.o.showmode = false

  -- Format on save: 交给 conform.nvim（见 plugins.lua）。conform 自己监听
  -- BufWritePre，所以关掉 LunarVim 内置的 format_on_save 避免双重格式化。
  -- 必须在这里关——LunarVim 在 source config.lua 之后才注册 BufWritePre
  -- autocmd，等插件 config 函数（BufReadPre 才跑）去改 lvim.format_on_save
  -- 已经晚了，autocmd 不会因此移除。
  lvim.format_on_save.enabled = false

  -- Fix: indent-blankline v2 的 treesitter 功能不兼容 Neovim 0.12+
  lvim.builtin.indentlines.options.use_treesitter = false
  lvim.builtin.indentlines.options.show_current_context = false

  -- Fix: vim-illuminate 在加载时硬编码 require("nvim-treesitter.query")，不兼容 Neovim 0.12+
  lvim.builtin.illuminate.active = false

  -- Fix: LunarVim core 默认 ensure_installed 含 "regex"，每次启动自动装回 regex
  -- parser。而 nvim-treesitter runtime 里的 regex highlights.scm 第 9 行匹配了
  -- regex parser 不存在的节点 "<"，导致 js 文件里的正则字面量触发 regex 注入高亮时
  -- 报 "Query error at 9:4. Invalid node type <"。regex 高亮非必需，直接移除。
  lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline" }

  -- Fix: 屏蔽 LunarVim 内部 "Failed to load nvim-treesitter.configs" 错误
  -- (新版 nvim-treesitter 已移除 configs 模块，此错误无害)
  lvim.log.level = "fatal"

  -- Fix: 新版 nvim-treesitter 将 queries 放在 runtime/ 子目录下，需要手动加入 runtimepath
  -- 同时解析器安装到 stdpath('data')/site，也需要加入
  local ts_dir = vim.fn.glob("~/.local/share/lunarvim/site/pack/lazy/opt/nvim-treesitter")
  if ts_dir ~= "" then
    local ts_runtime = ts_dir .. "/runtime"
    if vim.fn.isdirectory(ts_runtime) == 1 then
      vim.o.runtimepath = vim.o.runtimepath .. "," .. ts_runtime
    end
  end
  local parser_dir = vim.fn.stdpath("data") .. "/site"
  if vim.fn.isdirectory(parser_dir) == 1 then
    vim.o.runtimepath = vim.o.runtimepath .. "," .. parser_dir
  end

  -- Fix: 新版 nvim-treesitter 不再自动启用高亮，通过 autocommand 启用
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitterHighlight", { clear = true }),
    callback = function()
      pcall(vim.treesitter.start)
    end,
  })
end

return M
