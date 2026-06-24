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
  }
end

return M
