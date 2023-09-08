local uConfig = require("u-config")

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_feedkeys('', 't', true)

local default_opt = { noremap = true, silent = true }

-- Abstract map key binding method
local map = function(key, mapping, mode, _opt)
  if mode == nil then
    mode = "n"
  end
  if _opt == nil then
    _opt = default_opt
  end

  vim.api.nvim_set_keymap(mode, key, mapping, _opt)

end

-- # Manage editor group

-- Split editor group
map("<leader>sv", ":vsp<CR>")
map("<leader>sh", ":sp<CR>")

-- Close current editor group
map("<leader>sc", "<C-w>c")

-- Close other editor groups
map("<leader>so", "<C-w>o")

-- Navigate editor group cursor
map("<leader>h", "<C-w>h")
map("<leader>j", "<C-w>j")
map("<leader>k", "<C-w>k")
map("<leader>l", "<C-w>l")

-- Adjust editor group sizes
map("<C-A-h>", ":vertical resize -2<CR>")
map("<C-A-l>", ":vertical resize +2<CR>")
map("<C-A-j>", ":resize +2<CR>")
map("<C-A-k>", ":resize -2<CR>")
-- make a balance sizes of group
map("<C-=>", "<C-w>=")

-- # Terminal
map("<leader>t", ":sp | terminal<CR>")
map("<leader>vt", ":vsp | terminal<CR>")
map("<Esc>", "<C-\\><C-n>", "t")
map("<leader>h", "[[ <C-\\><C-N><C-w>h ]]", "t")
map("<leader>j", "[[ <C-\\><C-N><C-w>j ]]", "t")
map("<leader>k", "[[ <C-\\><C-N><C-w>k ]]", "t")
map("<leader>l", "[[ <C-\\><C-N><C-w>l ]]", "t")

-- # Visule keybindings

-- Quick indent selected block
map("<", "<gv", "v")
map(">", ">gv", "v")

map("J", ":move '>+1<CR>gv-gv", "v")
map("K", ":move '<-2<CR>gv-gv", "v")

-- # Move cursor

-- Super j/k
map("<C-j>", "4j")
map("<C-j>", "4j", "v")
map("<C-k>", "4k")
map("<C-k>", "4k", "v")
map("<C-j>", "<Esc>4ji", "i")
map("<C-k>", "<Esc>4ki", "i")

-- # Other
-- map("<leader>fm", "gg=G<C-o>")

-- # Plugins mapping
local pluginKeys = {}

-- Nvim-tree
-- Open the tree sider
map("<A-b>", ":NvimTreeToggle<CR>")
map("<leader>b", ":NvimTreeToggle<CR>")

pluginKeys.nvimTreeList = {
  -- Open the folder or file
  { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
  -- Split editor group
  { key = "v", action = "vsplit" },
  { key = "h", action = "split" },
  -- show the hidden files
  { key = ".", action = "toggle_dotfiles" },
  { key = "i", action = "toggle_custom" },
  -- File's actions
  { key = "<C-r>", action = "refresh" },
  { key = "a", action = "create" },
  { key = "d", action = "remove" },
  { key = "r", action = "rename" },
  { key = "x", action = "cut" },
  { key = "c", action = "copy" },
  { key = "p", action = "paste" },
  { key = "s", action = "system_open" },
}

-- Bufferline
map("<C-[>", ":BufferLineCyclePrev<CR>")
map("<C-]>", ":BufferLineCycleNext<CR>")
-- Bufferline tab manager
map("<C-w>", ":Bdelete!<CR>")
map("<leader>w", ":Bdelete!<CR>")
map("<leader>bl", ":BufferLineCloseRight<CR>")
map("<leader>bh", ":BufferLineCloseLeft<CR>")
map("<leader>bc", ":BufferLinePickClose<CR>")

-- Telescope
map("<leader>p", ":Telescope find_files<CR>")
map("<C-p>", ":Telescope find_files<CR>")
map("<leader><leader>f", ":Telescope live_grep<CR>")

pluginKeys.telescopeList = {
  i = {
    -- Move search result selection item any mode
    ["<C-j>"] = "move_selection_next",
    ["<C-k>"] = "move_selection_previous",
    ["<C-u>"] = "preview_scrolling_up",
    ["<C-d>"] = "preview_scrolling_down",
    -- Close the fuzzy search window
    ["<C-c>"] = "close",
  }
}

-- Dashboard
map("<leader><leader>h", ":Dashboard<CR>")

-- Lsp
local lsp = uConfig.lsp
pluginKeys.mapLsp = function(mapbuf)
  vim.notify("I'm in!!!!")
  mapbuf("n", lsp.rename, "<cmd>lua vim.lsp.buf.rename()<CR>")
  mapbuf("n", lsp.code_action, "<cmd>lua vim.lsp.buf.code_action()<CR>")
  mapbuf("n", lsp.code_action, function()
    require("telescope.builtin").lsp_definitions({
      initial_mode = "normal",
    })
  end)
  mapbuf("n", lsp.hover, "<cmd>lua vim.lsp.buf.hover()<CR>")
  mapbuf(
    "n", 
    lsp.references, 
    "<cmd>lua require'telescope.builtin'.lsp_references(require('telescope.themes').get_ivy())<CR>"
  )
  mapbuf("n", lsp.open_flow, "<cmd>lua vim.diagnostic.open_float()<CR>")
  mapbuf("n", lsp.goto_next, "<cmd>lua vim.diagnostic.goto_next()<CR>")
  mapbuf("n", lsp.goto_prev, "<cmd>lua vim.diagnostic.goto_prev()<CR>")
end

return pluginKeys

