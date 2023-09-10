local M = {}

function M.setup()
  -- plugins
  lvim.plugins = {
    -- theme
    { "Mofiqul/dracula.nvim" },
    { "EdenEast/nightfox.nvim" },
    { "folke/tokyonight.nvim" },
    {
      'wfxr/minimap.vim',
      build = "cargo install --locked code-minimap",
      init = function()
        vim.cmd("let g:minimap_width = 10")
        vim.cmd("let g:minimap_auto_start = 1")
        vim.cmd("let g:minimap_auto_start_win_enter = 1")
        vim.cmd("let g:minimap_git_colors = 1")
      end,
    },
  }
end

return M
