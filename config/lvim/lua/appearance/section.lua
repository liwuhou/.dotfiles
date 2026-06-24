local text = require("lvim.interface.text")
local acii = require("resource.acii-art")
local slogan = "Winter is coming..."

local section = {
  header = {
    type = "text",
    val = acii.wolves,
    opts = {
      position = "center",
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
    type = "text",
    val = text.align_center({ width = 0 }, {
      slogan,
    }, 0.5),
    opts = {
      position = "center",
      hl = "DashBoardFooter",
    },
  },
}

return section
