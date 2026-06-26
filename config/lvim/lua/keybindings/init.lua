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
end

return M
