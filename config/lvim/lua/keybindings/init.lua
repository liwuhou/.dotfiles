local utils = require("keybindings.utils")
local reset = utils.reset
local keymap = utils.keymap

local M = {}

function M.setup()
  reset()
  -- Keybindings

  -- Super cursor
  keymap("<C-j>", "5j", { "n", "v" })
  keymap("<C-K>", "5k", { "n", "v" })
  keymap("<C-j>", "<ESC>5ji", "i")
  keymap("<C-k>", "<ESC>5ki", "i")
  -- Editor group
  keymap("J", "<C-w>j", { "n", "v" })
  keymap("K", "<C-w>k", { "n", "v" })
  keymap("H", "<C-w>h", { "n", "v" })
  keymap("L", "<C-w>l", { "n", "v" })
  keymap("<C-M-j>", ":resize -2<CR>")
  keymap("<C-M-k>", ":resize +2<CR>")
  keymap("<C-M-h>", ":vertical resize -2<CR>")
  keymap("<C-M-l>", ":vertical resize +2<CR>")

  -- code
  keymap("<", "<gv", "v")
  keymap(">", ">gv", "v")
  keymap("<C-/>", "<Plug>(comment_toggle_linewise_current)")
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
  lvim.builtin.which_key.mappings["t"] = {
    name = "Terminal",
    v = { ":vsp | terminal<CR>", "Open terminal vertically" },
    h = { ":sp | terminal<CR>", "Open terminal horizontally" },
    f = {
      function()
        -- FIXME: toggleterm is not found
        local Terminal = require("toggleterm.terminal").Terminal
        local ter = Terminal:new({ cmd = vim.o.shell, direction = "float" })
        ter.toggleterm(lvim.builtin.terminal.size, "float")
      end,
      "Open float terminal" },
    c = { "<C-\\>", "Hide the terminal" }
  }
end

return M
