local M = {}

function M.setup()
  -- plugins
  lvim.plugins = {
    -- theme
    { "Mofiqul/dracula.nvim" },
    { "EdenEast/nightfox.nvim" },
    -- { "folke/tokyonight.nvim" },
    {
      "navarasu/onedark.nvim",
      config = function()
        require("onedark").setup({
          style = "dark",
          toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
        })
        require("onedark").load()
      end,
    },
    -- minimap
    { "Isrothy/neominimap.nvim" },
    -- Code folding with a nicer look (colored fold bar + signature preview),
    -- layered on top of Neovim's native folding. Uses treesitter as the
    -- primary provider, indent as fallback for langs without a parser.
    {
      "kevinhwang91/nvim-ufo",
      dependencies = "kevinhwang91/promise-async",
      event = "BufReadPost",
      init = function()
        -- ufo manages foldmethod/foldexpr on attach; these are the window
        -- options its README asks for. foldcolumn='1' gives the left-side
        -- colored fold bar; foldlevel(start)=99 keeps everything open by
        -- default so folds don't snap shut on file open.
        vim.o.foldcolumn = "1"
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
    -- nvim-treesitter stays on the legacy `master` branch (also pinned by
    -- LunarVim's snapshot). LunarVim's core treesitter config uses the old
    -- `nvim-treesitter.configs` API, which `main` removed — on master it runs
    -- natively, so no compat hacks are needed in basic.lua. (The old
    -- `ft_to_lang` previewer crash is no longer reproducible: telescope is on
    -- master and nvim-treesitter master doesn't call the removed API.)
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      build = ":TSUpdate",
    },
    -- Project switcher: scan git repos under given base_dirs.
    -- Complements `:Telescope projects` (history) with directory-tree
    -- discovery of repos under ~/Data/frontend (xiaoe/, github/, ...).
    -- Config is fed through `lvim.builtin.telescope.extensions.project` so
    -- LunarVim's telescope.setup() picks it up; load_extension runs in
    -- on_config_done (after setup, the safe moment to load extensions).
    {
      "nvim-telescope/telescope-project.nvim",
      config = function()
        lvim.builtin.telescope = vim.tbl_deep_extend("force", lvim.builtin.telescope or {}, {
          extensions = {
            project = {
              base_dirs = {
                { path = "~/Data/frontend", max_depth = 3 },
              },
              -- "recent" orders recently-opened repos first; use "asc"/"desc"
              -- if you prefer a stable alphabetical sort.
              order_by = "recent",
              -- cd into the project on the current window+tab when picked.
              cd_scope = { "tab", "window" },
            },
          },
        })
        lvim.builtin.telescope.on_config_done = function(telescope)
          pcall(telescope.load_extension, "project")
        end
      end,
    },
  }
end

return M
