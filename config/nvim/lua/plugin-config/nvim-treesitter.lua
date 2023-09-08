local status, treesitter = pcall(require, "nvim-treesitter.configs")

if not status then
  vim.notify("NvimTreeSitter is not found!")
  return
end

treesitter.setup({
  ensure_installed = { "json", "html", "css", "javascript", "typescript", "rust", "vim", "lua" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      node_decremental = "<BS>", 
      scope_incremental = "<TAB>",
    }
  },
  indent = {
    enable = true
  }
})

-- "indent" | "manual" | "expr" | "syntax" | "diff" | "market"
vim.opt.foldmethod = "indent"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
