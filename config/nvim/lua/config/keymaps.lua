local function del(mode, lhs)
  pcall(vim.keymap.del, mode, lhs)
end

for _, mode in ipairs({ "n", "v", "t" }) do
  for _, lhs in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>", "<C-Up>", "<C-Down>", "<C-Left>", "<C-Right>", "<C-=>" }) do
    del(mode, lhs)
  end
end

del("n", "K")

local map = vim.keymap.set
map({ "n", "x" }, "<C-j>", "5j", { desc = "Move down 5 lines" })
map({ "n", "x" }, "<C-k>", "5k", { desc = "Move up 5 lines" })
map("i", "<C-j>", "<Esc>5ji", { desc = "Move down 5 lines" })
map("i", "<C-k>", "<Esc>5ki", { desc = "Move up 5 lines" })
map({ "n", "x" }, "J", "<C-w>j", { desc = "Window down" })
map({ "n", "x" }, "K", "<C-w>k", { desc = "Window up" })
map({ "n", "x" }, "H", "<C-w>h", { desc = "Window left" })
map({ "n", "x" }, "L", "<C-w>l", { desc = "Window right" })
map("n", "<M-C-k>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<M-C-j>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<M-C-l>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<M-C-h>", ":vertical resize +2<CR>", { desc = "Increase window width" })
map("x", "<", "<gv", { desc = "Indent left" })
map("x", ">", ">gv", { desc = "Indent right" })
map({ "n", "i", "x" }, "<C-s>", "<cmd>w!<cr>", { desc = "Save file" })
map("n", "gh", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<leader>;", function()
  require("snacks").dashboard.open()
end, { desc = "Dashboard" })

local function toggle_terminal(position)
  return function()
    require("snacks").terminal.toggle(nil, { win = { position = position } })
  end
end

map({ "n", "t" }, "<C-\\>", toggle_terminal("float"), { desc = "Toggle floating terminal" })
map({ "n", "t" }, "<M-1>", toggle_terminal("bottom"), { desc = "Toggle horizontal terminal" })
map({ "n", "t" }, "<M-2>", toggle_terminal("right"), { desc = "Toggle vertical terminal" })
map({ "n", "t" }, "<M-3>", toggle_terminal("float"), { desc = "Toggle floating terminal" })


map("n", "<leader>bf", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })

map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>ld", function()
  vim.diagnostic.setloclist({ open = true })
end, { desc = "Buffer diagnostics" })
map("n", "<leader>lw", function()
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Workspace diagnostics" })
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
map("n", "<leader>lI", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>lj", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
map("n", "<leader>lk", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })
map("n", "<leader>ll", vim.lsp.codelens.run, { desc = "CodeLens action" })
map("n", "<leader>lq", function()
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Diagnostics quickfix" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
map("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace symbols" })
map("n", "<leader>le", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix list" })

map("n", "<leader>gj", function()
  require("gitsigns").next_hunk()
end, { desc = "Next hunk" })
map("n", "<leader>gk", function()
  require("gitsigns").prev_hunk()
end, { desc = "Previous hunk" })
map({ "n", "x" }, "<leader>gr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
map("n", "<leader>gR", function()
  require("gitsigns").reset_buffer()
end, { desc = "Reset buffer" })
map("n", "<leader>gu", function()
  require("gitsigns").undo_stage_hunk()
end, { desc = "Undo stage hunk" })
map("n", "<leader>go", function()
  require("snacks").picker.git_status()
end, { desc = "Git status" })

map("n", "<leader>Pi", "<cmd>Lazy install<cr>", { desc = "Install plugins" })
map("n", "<leader>Ps", "<cmd>Lazy sync<cr>", { desc = "Sync plugins" })
map("n", "<leader>PS", "<cmd>Lazy show<cr>", { desc = "Plugin status" })
map("n", "<leader>Pc", "<cmd>Lazy clean<cr>", { desc = "Clean plugins" })
map("n", "<leader>Pu", "<cmd>Lazy update<cr>", { desc = "Update plugins" })
map("n", "<leader>Pp", "<cmd>Lazy profile<cr>", { desc = "Profile plugins" })
map("n", "<leader>Pl", "<cmd>Lazy log<cr>", { desc = "Plugin log" })
map("n", "<leader>Pd", "<cmd>Lazy debug<cr>", { desc = "Debug plugins" })

map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split vertically" })
map("n", "<leader>wh", "<cmd>split<cr>", { desc = "Split horizontally" })
map("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })
map("n", "<leader>lm", "<cmd>Neominimap toggle<cr>", { desc = "Toggle minimap" })
map("n", "<leader>ts", function()
  require("onedark").toggle()
end, { desc = "Toggle Onedark style" })
map("n", "zR", function()
  require("ufo").openAllFolds()
end, { desc = "Open all folds" })
map("n", "zM", function()
  require("ufo").closeAllFolds()
end, { desc = "Close all folds" })
map({ "n", "x" }, "<leader>lf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix" })

map("n", "<leader>S", function()
  require("spectre").open()
end, { desc = "Find and replace" })
map("n", "<leader>Sw", function()
  require("spectre").open_visual({ select_word = true })
end, { desc = "Replace current word" })
map("n", "<leader>Sp", function()
  require("spectre").open_file_search({ select_word = true })
end, { desc = "Replace in current file" })

map("n", "<leader>mt", function()
  require("marks").toggle()
end, { desc = "Toggle mark" })
map("n", "<leader>mn", function()
  require("marks").next()
end, { desc = "Next mark" })
map("n", "<leader>mp", function()
  require("marks").prev()
end, { desc = "Previous mark" })
map("n", "<leader>md", function()
  require("marks").delete_line()
end, { desc = "Delete line marks" })
map("n", "<leader>mD", function()
  require("marks").delete_buf()
end, { desc = "Delete buffer marks" })
map("n", "<leader>ml", "<cmd>MarksListBuf<cr>", { desc = "List buffer marks" })
map("n", "<leader>ma", "<cmd>MarksListAll<cr>", { desc = "List all marks" })
map("n", "<leader>mg", "<cmd>MarksListGlobal<cr>", { desc = "List global marks" })

local function yank_reference(absolute)
  local path = vim.fn.expand(absolute and "%:p" or "%:.")
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if not vim.fn.mode():find("^[vV\22]") then
    start_line = end_line
  elseif start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local reference = "@" .. path .. ":" .. start_line
  if start_line ~= end_line then
    reference = reference .. "-" .. end_line
  end
  vim.fn.setreg("+", reference)
  vim.fn.setreg("*", reference)
  vim.notify("Yanked: " .. reference)
end

map({ "n", "x" }, "<leader>yr", function()
  yank_reference(false)
end, { desc = "Yank relative @file:line" })
map({ "n", "x" }, "<leader>yR", function()
  yank_reference(true)
end, { desc = "Yank absolute @file:line" })
