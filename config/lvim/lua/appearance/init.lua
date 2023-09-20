local M = {}

local theme =
"dracula"
-- "nightfox"
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
      }
    }
  })
end

return M
