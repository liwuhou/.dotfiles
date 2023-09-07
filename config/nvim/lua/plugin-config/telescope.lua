local status, telescope = pcall(require, "telescope")

if not status then
  vim.notify("Telescope is not found!")
  return
end

telescope.setup({
  defaults = {
    initial_mode = "insert",
    mappings = require("keybindings").telescopeList,
  },
  pickers = {
    find_files = {
      -- find_files window's theme, "ivy" | "cursor" | "dropdown"
      theme = "dropdown"
    }
  },
  extensions = {
    -- Telescope's extensions config...
  }
})
