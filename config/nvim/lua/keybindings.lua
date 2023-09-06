vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_feedkeys('', 't', true)

-- Abstract map key binding method
function map(key, mapping, mode, _opt)
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

-- super j/k
map("<C-j>", "4j")
map("<C-k>", "4k")
map("<C-j>", "<Esc>4ji", "i")
map("<C-k>", "<Esc>4ki", "i")
