local status, db = pcall(require, "dashboard")

if not status then
  vim.notify("Dashboard is not found!")
  return 
end

db.setup({
  theme = "hyper",
  config = {
    week_header = {
      enable = true
    },
    shortcut = {
      { desc = '󰊳 init.lua', 
        group = '@property', 
        action = 'edit ~/.config/nvim/init.lua', 
        key = 'e' 
      },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      {
        desc = ' Projects',
        group = 'DiagnosticHint',
        action = 'Telescope projects',
        key = 'p',
      },
      {
        desc = ' Oldfiles',
        group = 'Number',
        action = 'Telescope oldfiles',
        key = 'o',
      },
    },
    custom_footer = {
      "",
      "",
      "https://github.com/liwuhou",
    },
    custom_center = {
      {
        icon = "  ",
        desc = "Projects                            ",
        action = "Telescope projects",
      },
      {
        icon = "  ",
        desc = "Recently files                      ",
        action = "Telescope oldfiles",
      },
      {
        icon = "  ",
        desc = "Edit keybindings                    ",
        action = "edit ~/.dotfiles/config/nvim/lua/keybindings.lua",
      },
      {
        icon = "  ",
        desc = "Edit Projects                       ",
        action = "edit ~/.local/share/nvim/project_nvim/project_history",
      },
      -- {
      --   icon = "  ",
      --   desc = "Edit .bashrc                        ",
      --   action = "edit ~/.bashrc",
      -- },
      -- {
      --   icon = "  ",
      --   desc = "Change colorscheme                  ",
      --   action = "ChangeColorScheme",
      -- },
      -- {
      --   icon = "  ",
      --   desc = "Edit init.lua                       ",
      --   action = "edit ~/.config/nvim/init.lua",
      -- },
      -- {
      --   icon = "  ",
      --   desc = "Find file                           ",
      --   action = "Telescope find_files",
      -- },
      -- {
      --   icon = "  ",
      --   desc = "Find text                           ",
      --   action = "Telescopecope live_grep",
      -- },
    },
    custom_header = {
      [[]],
      [[     ██╗██╗   ██╗███████╗     ██╗██╗███╗   ██╗]],
      [[     ██║██║   ██║██╔════╝     ██║██║████╗  ██║]],
      [[     ██║██║   ██║█████╗       ██║██║██╔██╗ ██║]],
      [[██   ██║██║   ██║██╔══╝  ██   ██║██║██║╚██╗██║]],
      [[╚█████╔╝╚██████╔╝███████╗╚█████╔╝██║██║ ╚████║]],
      [[ ╚════╝  ╚═════╝ ╚══════╝ ╚════╝ ╚═╝╚═╝  ╚═══╝]],
      [[                                              ]],
      [[             [ version : 1.0.0 ]              ]],
      [[]],
      [[]],
    }
  }
})

