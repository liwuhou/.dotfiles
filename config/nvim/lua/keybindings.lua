vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_feedkeys('', 't', true)

-- Abstract map key binding method
local map = function(key, mapping, mode, _opt)
	if mode == nil then
		mode = "n"
	end
	if _opt == nil then
		_opt = { noremap = true, silent = true }
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
map("<C-k>", "4k")
map("<C-j>", "<Esc>4ji", "i")
map("<C-k>", "<Esc>4ki", "i")

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
map("<A-[>", ":BufferLineCyclePrev<CR>")
map("<A-]>", ":BufferLineCycleNext<CR>")
-- Bufferline tab manager
map("<C-w>", ":Bdelete!<CR>")
map("<leader>w", ":Bdelete!<CR>")
map("<leader>bl", ":BufferLineCloseRight<CR>")
map("<leader>bh", ":BufferLineCloseLeft<CR>")
map("<leader>bc", ":BufferLinePickClose<CR>")

-- Telescope
map("<leader>p", ":Telescope find_files<CR>")
map("<C-p>", ":Telescope find_files<CR>")
map("<leader>f", ":Telescope live_grep<CR>")

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

return pluginKeys

