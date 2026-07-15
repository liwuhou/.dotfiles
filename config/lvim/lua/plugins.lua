local M = {}

function M.setup()
  -- plugins
  lvim.plugins = {
    -- theme
    { "Mofiqul/dracula.nvim" },
    { "EdenEast/nightfox.nvim" },
    -- { "folke/tokyonight.nvim" },
    {
      "navarasu/onedark.nvim",
      config = function()
        require("onedark").setup({
          style = "dark",
          toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
          transparent = lvim.transparent_window,
          lualine = { transparent = lvim.transparent_window },
        })
        require("onedark").load()
      end,
    },
    -- minimap: use a real split instead of the default float overlay so it
    -- never covers buffer text.
    {
      "Isrothy/neominimap.nvim",
      init = function()
        ---@type Neominimap.UserConfig
        vim.g.neominimap = {
          layout = "split",
          split = {
            direction = "rightbelow",
            minimap_width = 16,
            fix_width = true,
          },
        }
      end,
    },
    -- Code folding with a nicer look (colored fold bar + signature preview),
    -- layered on top of Neovim's native folding. Uses treesitter as the
    -- primary provider, indent as fallback for langs without a parser.
    {
      "kevinhwang91/nvim-ufo",
      dependencies = "kevinhwang91/promise-async",
      event = "BufReadPost",
      init = function()
        -- ufo manages foldmethod/foldexpr on attach; these are the window
        -- options its README asks for. foldcolumn=0: 关掉左侧折叠列——在
        -- treesitter/indent provider 下它会显示嵌套层级数字(1-9)，看着像
        -- 缩进深度标记、干扰阅读。折叠操作仍走 zR/zM/za 键盘，不受影响。
        -- foldlevel(start)=99 keeps everything open by default so folds
        -- don't snap shut on file open.
        vim.o.foldcolumn = "0"
        vim.o.foldlevelstart = 99
        vim.o.foldlevel = 99
        vim.o.foldenable = true
      end,
      opts = {
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      },
    },
    -- nvim-treesitter on `main` (also pinned by LunarVim's snapshot). main
    -- tracks Neovim's treesitter parser ABI and auto-registers parsers via
    -- vim.treesitter.language.add, so highlighting works on Neovim 0.12.
    -- (master/legacy compiles ABI-incompatible parsers and doesn't register
    -- them — vim.treesitter.start fails with "Parser could not be created".)
    -- main removed `nvim-treesitter.configs`, so LunarVim core's treesitter
    -- setup silently no-ops; basic.lua re-enables highlighting via a FileType
    -- autocmd and injects main's runtime/ parser path.
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      build = ":TSUpdate",
    },
    -- Project switcher: scan git repos under given base_dirs.
    -- Complements `:Telescope projects` (history) with directory-tree
    -- discovery of repos under ~/Data/frontend (xiaoe/, github/, ...).
    -- Config is fed through `lvim.builtin.telescope.extensions.project` so
    -- LunarVim's telescope.setup() picks it up; load_extension runs in
    -- on_config_done (after setup, the safe moment to load extensions).
    {
      "nvim-telescope/telescope-project.nvim",
      config = function()
        lvim.builtin.telescope = vim.tbl_deep_extend("force", lvim.builtin.telescope or {}, {
          extensions = {
            project = {
              base_dirs = {
                { path = "~/Data/frontend", max_depth = 3 },
              },
              -- "recent" orders recently-opened repos first; use "asc"/"desc"
              -- if you prefer a stable alphabetical sort.
              order_by = "recent",
              -- cd into the project on the current window+tab when picked.
              cd_scope = { "tab", "window" },
            },
            -- ui-select: 列表类选择用 dropdown 主题浮窗
            ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
          },
        })
        lvim.builtin.telescope.on_config_done = function(telescope)
          pcall(telescope.load_extension, "project")
          pcall(telescope.load_extension, "ui-select")
        end
      end,
    },
    -- ── 格式化：conform.nvim 接管，替代已归档的 none-ls ──
    -- none-ls.nvim 已停止维护，格式化迁到 conform。conform 自己监听
    -- BufWritePre，必须先关掉 LunarVim 内置的 format_on_save（在 basic.lua 里
    -- 关——LunarVim 在 source config.lua 之后才注册 autocmd，插件 config 函数
    -- 跑得太晚，改不动已注册的 autocmd）。formatters 用 mason 装：
    --   :MasonInstall prettierd stylua
    -- stop_after_first：prettierd 没装就退到 prettier；都没有时 lsp_fallback
    -- 让 conform 退回 LSP formatting。
    {
      "stevearc/conform.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("conform").setup({
          format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
          },
          formatters_by_ft = {
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            javascriptreact = { "prettierd", "prettier", stop_after_first = true },
            typescriptreact = { "prettierd", "prettier", stop_after_first = true },
            vue = { "prettierd", "prettier", stop_after_first = true },
            css = { "prettierd", "prettier", stop_after_first = true },
            scss = { "prettierd", "prettier", stop_after_first = true },
            html = { "prettierd", "prettier", stop_after_first = true },
            json = { "prettierd", "prettier", stop_after_first = true },
            jsonc = { "prettierd", "prettier", stop_after_first = true },
            yaml = { "prettierd", "prettier", stop_after_first = true },
            markdown = { "prettierd", "prettier", stop_after_first = true },
            lua = { "stylua" },
          },
        })
        -- 手动格式化沿用 LunarVim 的 <leader>lf，但改走 conform（覆盖原生
        -- vim.lsp.buf.format），这样非 LSP 的 prettier/stylua 也能触发。
        vim.keymap.set({ "n", "v" }, "<leader>lf", function()
          require("conform").format({ async = true, lsp_fallback = true })
        end, { desc = "Format (conform)" })
      end,
    },
    -- ── 成对符号操作：加/改/删括号引号标签 (ys/cs/ds, visual S) ──
    -- visual 模式的 S 给 surround；flash 的 S 只绑 normal+operator，不冲突。
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      opts = {},
    },
    -- ── 光标快速跳转：s 跳转, S treesitter 搜索 ──
    -- 按键取自 folke 官方 README：S 不绑 visual(x)，把 visual S 让给
    -- nvim-surround；visual R 给 flash treesitter search。
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {},
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "o" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
    },
    -- ── 诊断/引用/quickfix 侧栏聚合（trouble v3） ──
    -- v3 命令：:Trouble diagnostics toggle 等。<leader>x 作为 trouble 组。
    {
      "folke/trouble.nvim",
      cmd = "Trouble",
      opts = {},
      keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
        { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
        { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
        { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
      },
    },
    -- ── telescope 扩展：vim.ui.select 走 telescope ──
    -- LSP code action / 主题切换 / :LspInstall 选 server 等列表都变成可模糊
    -- 搜索的浮窗。extension 配置 + load_extension 合并进上面 telescope-project
    -- 的 on_config_done（telescope 只允许一个 on_config_done）。
    { "nvim-telescope/telescope-ui-select.nvim" },
    -- ── 全工程查找替换：跨文件正则匹配 + 实时 diff 预览 ──
    -- telescope 只搜不换，spectre 补这块。find 用 ripgrep（brew install ripgrep）。
    -- macOS 注意：replace 默认走 BSD sed，复杂正则替换可能出问题；若遇到，
    -- `brew install gnu-sed` 后在 opts.default.replace.cmd 改成 "gsed"。
    {
      "nvim-pack/nvim-spectre",
      dependencies = { "nvim-lua/plenary.nvim" },
      cmd = "Spectre",
      keys = {
        { "<leader>S", function() require("spectre").open() end, desc = "Spectre (find & replace)" },
        { "<leader>Sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Spectre: current word" },
        { "<leader>Sp", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Spectre: current file" },
      },
      opts = {},
    },
    -- ── 标记：类 VSCode bookmark，行号列显示标记 + :Marks 浮窗管理 ──
    -- m, 打标记(自动分配字母,不限量) · m; toggle+加注释 · m]/m[ 跳转上下个 ·
    -- dm- 删当前行标记 · dm= 删当前 buffer 所有标记 · :Marks 打开管理浮窗(可
    -- 模糊搜索+回车跳转)。走 vim 原生 mark 机制，不依赖 treesitter API，所以
    -- 这套关了 treesitter 配置的环境也能用。sign_priority 设高，避免被
    -- gitsigns 的 sign 盖住。
    {
      "chentoast/marks.nvim",
      event = "BufReadPost",
      -- cmd 列全所有用到的命令，确保 :MarksListBuf 等也能触发 lazy 加载
      -- （单个 "Marks" 只匹配 :Marks，不匹配 :MarksListBuf）。
      cmd = { "Marks", "MarksToggleSigns", "MarksListBuf", "MarksListAll", "MarksListGlobal", "BookmarksList" },
      opts = {
        default_mappings = true,
        builtin_marks = {},
        cyclic = true,
        refresh_interval = 250,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        excluded_filetypes = {
          "TelescopePrompt", "NvimTree", "lazy", "alpha", "mason", "Trouble", "spectre_panel",
        },
        excluded_buftypes = { "terminal", "nofile" },
      },
    },
  }
end

return M
