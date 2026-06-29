local text = require("lvim.interface.text")
local acii = require("resource.acii-art")
local icons = lvim.icons.ui
local slogan = "Winter is coming..."

-- Build alpha button elements directly and stash them in `buttons.val`.
-- `resolve_buttons` in lvim core prefers `val` over `entries`, so this fully
-- replaces LunarVim's default 7-button list — no deep-merge residue.
local db = require("alpha.themes.dashboard")
local function button(sc, txt, cmd)
  return db.button(sc, txt, cmd)
end

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
    val = {
      button("p", icons.Project .. "  Projects  ", "<CMD>Telescope project<CR>"),
      button("g", icons.Search .. "  Live grep ", "<CMD>lua require('telescope.builtin').live_grep({search_dirs={'~/Data/frontend'}})<CR>"),
      button("d", icons.Folder .. "  Dotfiles  ", "<CMD>cd ~/.dotfiles | e .<CR>"),
      button("q", icons.Close .. "  Quit      ", "<CMD>quit<CR>"),
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
