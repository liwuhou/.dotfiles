local utils = require("keybindings.utils")
local reset = utils.reset
local keymap = utils.keymap

local M = {}

function M.setup()
  reset()
  -- Keybindings

  -- Super cursor
  keymap("<C-j>", "5j", { "n", "v" })
  keymap("<C-k>", "5k", { "n", "v" })
  keymap("<C-j>", "<ESC>5ji", "i")
  keymap("<C-k>", "<ESC>5ki", "i")
  -- Editor group
  keymap("J", "<C-w>j", { "n", "v" })
  keymap("K", "<C-w>k", { "n", "v" })
  keymap("H", "<C-w>h", { "n", "v" })
  keymap("L", "<C-w>l", { "n", "v" })
  keymap("<C-M-k>", ":resize -2<CR>")
  keymap("<C-M-j>", ":resize +2<CR>")
  keymap("<C-M-l>", ":vertical resize -2<CR>")
  keymap("<C-M-h>", ":vertical resize +2<CR>")

  keymap("<", "<gv", "v")
  keymap(">", ">gv", "v")
  -- keymap("<C-/>", "<Plug>(comment_toggle_linewise_current)")
  keymap("<C-s>", "<cmd>w!<CR>", { "n", "i", "v" })

  lvim.builtin.terminal.float_opts.width = 80
  lvim.builtin.terminal.float_opts.height = 20
  lvim.lsp.buffer_mappings.normal_mode["gh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" }
  lvim.builtin.which_key.mappings["w"] = {
    name = "Split editor group",
    v = { ":vsp<CR>", "Split editor group vertically" },
    h = { ":sp<CR>", "Split editor group horizontally" },
    c = { "<C-w>c", "Close current editor group" },
    o = { "<C-w>o", "Close other editor group" },
    ["="] = { "<C-w>=", "resize equally editor groups" }
  }
  lvim.builtin.which_key.mappings["lm"] = { "<cmd>Neominimap toggle<cr>", "Toggle Minimap" }
  lvim.builtin.which_key.mappings["ts"] = { "<cmd>lua require('onedark').toggle()<cr>", "Toggle Onedark Style" }

  -- Folding (nvim-ufo): zR/zM route through ufo so the fold provider stays
  -- consistent. Per-fold toggle (za/zo/zc) uses Neovim defaults, no remap needed.
  local ok, ufo = pcall(require, "ufo")
  if ok then
    vim.keymap.set("n", "zR", ufo.openAllFolds)
    vim.keymap.set("n", "zM", ufo.closeAllFolds)
  end

  -- Move (not duplicate) a few which-key entries:
  --   <leader>p  Plugins group   -> <leader>P
  --   <leader>f  Find File       -> <leader>p
  --   <leader>st Search Text     -> <leader>f   (and clear the old <leader>st)
  -- Order matters: each assignment reads the current value before it's overwritten.
  local wk = lvim.builtin.which_key.mappings
  wk["P"] = wk["p"]          -- Plugins group  -> <leader>P
  wk["p"] = wk["f"]          -- Find File      -> <leader>p
  wk["f"] = wk["s"]["t"]     -- live_grep Text -> <leader>f
  wk["s"]["t"] = nil         -- clear old      <leader>st

  -- ── <leader>m: Mark 菜单（marks.nvim） ──
  -- 打标记动作直接调 marks.nvim 的 Lua 函数（require("marks").xxx），不走按键
  -- 映射层，最可靠、不受 noremap/Plug 影响。列表用 :MarksList* 命令填 location
  -- list 窗口。原生键 m,/m;/m]/m[ 等仍保留（default_mappings=true），这里只是
  -- 额外的 leader 二级菜单，两套并存。
  lvim.builtin.which_key.mappings["m"] = {
    name = "Mark",
    t = { function() require("marks").toggle() end, "Toggle mark" },
    n = { function() require("marks").next() end, "Next mark" },
    p = { function() require("marks").prev() end, "Prev mark" },
    d = { function() require("marks").delete_line() end, "Delete line marks" },
    D = { function() require("marks").delete_buf() end, "Delete buffer marks" },
    l = { "<cmd>MarksListBuf<cr>", "List buffer marks" },
    a = { "<cmd>MarksListAll<cr>", "List all marks" },
    g = { "<cmd>MarksListGlobal<cr>", "List global marks" },
  }

  -- ── Yank reference: 复制 @path:line-line 格式到剪贴板 ──
  -- visual mode 框选范围,输出 @path:startLine-endLine
  -- normal mode 当前行,输出 @path:line
  -- <leader>yr 相对路径(cwd),<leader>yR 绝对路径
  local function yank_reference(opts)
    opts = opts or {}
    local use_absolute = opts.absolute or false

    -- 路径:绝对用 %:p,相对用 %:.
    local path = use_absolute and vim.fn.expand("%:p") or vim.fn.expand("%:.")

    -- 行号:visual mode 用 v(visual start)和.(current),normal 只有当前行
    local mode = vim.fn.mode()
    local start_line, end_line

    if mode == "v" or mode == "V" or mode == "\22" then
      start_line = vim.fn.line("v")
      end_line = vim.fn.line(".")
      if start_line > end_line then
        start_line, end_line = end_line, start_line
      end
    else
      start_line = vim.fn.line(".")
      end_line = start_line
    end

    -- 格式化
    local ref
    if start_line == end_line then
      ref = "@" .. path .. ":" .. start_line
    else
      ref = "@" .. path .. ":" .. start_line .. "-" .. end_line
    end

    -- 复制到系统剪贴板(+ 用于 macOS/Linux,也复制到 * 保险)
    vim.fn.setreg("+", ref)
    vim.fn.setreg("*", ref)

    -- 提示
    print("Yanked: " .. ref)
  end

  vim.keymap.set({"n", "v"}, "<leader>yr", function()
    yank_reference({ absolute = false })
  end, { desc = "Yank @file:line (relative)" })

  vim.keymap.set({"n", "v"}, "<leader>yR", function()
    yank_reference({ absolute = true })
  end, { desc = "Yank @file:line (absolute)" })

  -- which_key 菜单显示(和上面的 vim.keymap.set 并存,确保菜单可见)
  lvim.builtin.which_key.mappings["y"] = {
    name = "Yank",
    r = { function() yank_reference({ absolute = false }) end, "Yank @file:line (relative)" },
    R = { function() yank_reference({ absolute = true }) end, "Yank @file:line (absolute)" },
  }
  -- visual mode 也要单独设置 vmappings
  lvim.builtin.which_key.vmappings["y"] = {
    name = "Yank",
    r = { function() yank_reference({ absolute = false }) end, "Yank @file:line (relative)" },
    R = { function() yank_reference({ absolute = true }) end, "Yank @file:line (absolute)" },
  }
end

return M
