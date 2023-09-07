local packer = require("packer")

packer.startup({
  function(use)
    -- Packer itself
    use("wbthomason/packer.nvim")

    -- Use nvim's plugins with `use(name/repo)`
    -- tokyonight theme
    use("folke/tokyonight.nvim")
    use("Mofiqul/dracula.nvim")

    -- Nvim-tree
    use({ "nvim-tree/nvim-tree.lua", requires = "nvim-tree/nvim-web-devicons" })

    -- Bufferline
    use({ "akinsho/bufferline.nvim", requires = { "kyazdani42/nvim-web-devicons", "moll/vim-bbye" }})

    -- Status bar
    use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons" } })
    use("arkav/lualine-lsp-progress")

    -- Telescope -- the fuzzy search
    -- need repgrep and fd
    -- brew install repgrep and npm install -g fd-find
    use({ "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" }})

    -- Dashboard-nvim -- the beautiful dashboard!
    use({ "glepnir/dashboard-nvim", requires = { "nvim-tree/nvim-web-devicons" }})

    -- Dashboard's extension -- projects
    use("ahmedkhalf/project.nvim")

    -- Treesitter
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

    
  end,
  config = {
    max_jobs = 16,
    git = {
      -- default_url_format = "https://hub.fastgit.xyz/%s",
      -- default_url_format = "https://mirror.ghproxy.com/https://github.com/%s",
      -- default_url_format = "https://gitcode.net/mirrors/%s",
      -- default_url_format = "https://gitclone.com/github.com/%s",
    },
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end
    }
  }
})

-- Automaticaly install plugins when this file is saved
pcall(
  vim.cmd,
  [[
    augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
  ]]
)
