local text = require("lvim.interface.text")
local acii = require("resource.acii-art")
local slogan = "Winter is coming..."

local section = {
  header = {
    val = acii.wolves,
    opts = {
      hl = "DashBoardHeader",
    },
  },
  buttons = {
    opts = {
      hl = "DashBoardCenter",
      hl_shortcut = "Keyword",
    },
  },
  footer = {
    val = text.align_center({ width = 0 }, {
      slogan,
    }, 0.5),
    opts = {
      hl = "DashBoardFooter",
    },
  },
}

return section
