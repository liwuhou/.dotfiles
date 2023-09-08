local status, nvim_tree = pcall(require, "nvim-tree")

if not status then
	vim.notify("Nvim-tree plugins is not found!")
	return
end

-- Loda tree's keybings
local list_keys = require("keybindings").nvimTreeList

-- Tree's startup
nvim_tree.setup({
  git = { enable = false },
  -- project pllugin
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  -- hide dotfiles and other files
  filters = {
    dotfiles = true,
    custom = {
      "node_modules",
    }
  },
  view = {
    width = 30,
    side = "left",
    hide_root_folder = false,
    mappings = {
      custom_only = true,
      list = list_keys,
    },
    -- Hide the line number
    number = false,
    relativenumber = false,
    -- Show the icon
    signcolumn = "yes"
  },
  actions = {
    open_file = {
      resize_window = false,
      quit_on_open = false,
    }
  },
  system_open = {
    cmd = "open"
  }
})

-- Automatically colse
vim.cmd([[
  autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])
