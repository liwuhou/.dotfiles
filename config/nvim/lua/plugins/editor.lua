local function find_workspace_files(include_ignored)
  local opts = {
    cwd = LazyVim.root(),
    hidden = true,
  }
  if include_ignored then
    opts.no_ignore = true
  end
  require("telescope.builtin").find_files(opts)
end

return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark",
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
      transparent = true,
      lualine = { transparent = true },
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      require("onedark").load()
    end,
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = {
        preset = {
          header = [[
                             __
                           .d$$b
                          .' TO$;
                         /  : TP._;
                        / _.;  :Tb|
                       /   /   ;j$j
                   _.-"       d$$$$
                 .' ..       d$$$$;
                /  /P'      d$$$$P. |\
               /   "      .d$$$P' |\^"l
             .'           `T$P^"""""  :
         ._.'      _.'                ;
      `-.-".-'-' ._.       _.-.    .-"
    `.-" _____  ._              .-"
   -(.g$$$$$$$b.              .'
     ""^^T$$$P^)            .(:
       _/  -"  /.'         /:/;
    ._.'-'`-'  ")/         /;/;
 `-.-"..--"   " /         /  ;
.-" ..--""        -'          :
..--""--.-.         (\      .-(\
  ..--""              `-\(\/;`    Awu～]],
          keys = {
            { icon = " ", key = "p", desc = "Projects", action = ":Telescope project" },
            { icon = " ", key = "g", desc = "Live Grep", action = ":Telescope live_grep search_dirs={'~/Data/frontend'}" },
            { icon = " ", key = "d", desc = "Dotfiles", action = ":cd ~/.dotfiles | e ." },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { text = { { "Winter is coming...", hl = "SnacksDashboardFooter" } }, align = "center", padding = 1 },
          { section = "startup" },
        },
      }
      opts.terminal = vim.tbl_deep_extend("force", opts.terminal or {}, {
        win = { width = 0.8, height = 0.8 },
      })
      return opts
    end,
  },
  {
    "Isrothy/neominimap.nvim",
    init = function()
      vim.g.neominimap = {
        layout = "split",
        split = {
          direction = "rightbelow",
          minimap_width = 16,
          fix_width = true,
        },
      }
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    init = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevelstart = 99
      vim.o.foldlevel = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    keys = {
      { "<leader><space>", find_workspace_files, desc = "Find all files (Root Dir)" },
      { "<leader>ff", find_workspace_files, desc = "Find all files (Root Dir)" },
      {
        "<leader>fI",
        function() find_workspace_files(true) end,
        desc = "Find including ignored files (Root Dir)",
      },
    },
    opts = {
      extensions = {
        project = {
          base_dirs = { { path = "~/Data/frontend", max_depth = 3 } },
          ignore_missing_dirs = true,
          order_by = "recent",
          cd_scope = { "tab", "window" },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      opts.extensions = opts.extensions or {}
      opts.extensions["ui-select"] = require("telescope.themes").get_dropdown({})
      telescope.setup(opts)
      telescope.load_extension("project")
      telescope.load_extension("ui-select")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
      })
      return opts
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = "Spectre",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>P", group = "Plugins" },
        { "<leader>m", group = "Marks" },
        { "<leader>w", group = "Windows" },
        { "<leader>x", group = "Trouble" },
        { "<leader>y", group = "Yank", mode = { "n", "x" } },
      })
      return opts
    end,
  },
  {
    "chentoast/marks.nvim",
    event = "BufReadPost",
    cmd = { "Marks", "MarksToggleSigns", "MarksListBuf", "MarksListAll", "MarksListGlobal", "BookmarksList" },
    opts = {
      default_mappings = true,
      builtin_marks = {},
      cyclic = true,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = { "TelescopePrompt", "lazy", "mason", "Trouble", "spectre_panel", "neo-tree", "snacks" },
      excluded_buftypes = { "terminal", "nofile" },
    },
  },
}
