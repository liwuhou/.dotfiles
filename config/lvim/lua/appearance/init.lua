local M = {}

local theme = "nightfox"

function M.setup()
  -- theme
  lvim:extend({
    colorscheme = theme,
    transparent_window = true,
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

