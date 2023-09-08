local status, db = pcall(require, "dashboard")
local acii = require("plugin-config.config.acii-art")

if not status then
  vim.notify("Dashboard is not found!")
  return 
end


db.setup({
  theme = "hyper",
  config = {
    -- week_header = { enable = true },
    shortcut = {
      { 
        icon = "",
        desc = " Settings", 
        group = "@property", 
        action = "edit ~/.dotfiles/config/nvim/init.lua", 
        key = "e" 
      },
      {
        icon = "",
        icon_hl = "@variable",
        desc = " Find Files",
        group = "Label",
        action = "Telescope find_files",
        key = "f",
      },
      {
        icon = "",
        desc = " Projects",
        group = "DiagnosticHint",
        action = "Telescope projects",
        key = "p",
      },
      {
        icon = "",
        desc = " History",
        group = "Number",
        action = "Telescope oldfiles",
        key = "o",
      },
    },
    packages = { enable = true },
    project = { enable = true, limit = 5, icon = "", label = "", action = "Telescope find_files cwd=" },
    mru = { limit = 2 },
    header = acii.wolves,
    footer = {
      "",
      "",
      "",
      "Life is short, Play More.",
    },
  }
})

