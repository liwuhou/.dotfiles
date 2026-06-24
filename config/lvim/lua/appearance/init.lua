local M = {}

local theme =
-- "dracula"
-- "nightfox"
"onedark"
-- "tokyonight-day"
-- "tokyonight-moon"
-- "tokyonight-storm"

function M.setup()
  -- theme
  lvim:extend({
    colorscheme = theme,
    transparent_window = false,
    builtin = {
      alpha = {
        dashboard = {
          section = reload("appearance.section")
        }
      },
      lualine = {
        options = {
          theme = theme,
        },
      },
    },
  })
end

return M
