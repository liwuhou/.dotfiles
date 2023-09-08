local mason_status, mason = pcall(require, "mason")
local msp_status, msp = pcall(require, "mason-lspconfig")
local lsp_status, lspconfig = pcall(require, "lspconfig")

if not mason_status and msp_status then
  vim.notify("Mason is not found!")
  return
end

if not lsp_status then
  vim.notify("Lsp Server is not found!")
  return
end

local servers = {
  lua_ls = require("lsp.config.lua")
}

mason.setup({
  ui = {
    icon = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- mason-lspconfig uses the `lspconfig` server names in the APIs it exposes - not `mason.nvim` package names
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
msp.setup({
  automatic_installtion = true,
  ensure_installed = { 
    "tsserver",
    "tailwindcss",
    "bashls",
    "cssls",
    "dockerls",
    "emmet_ls",
    "html",
    "jsonls",
    "pyright",
    "rust_analyzer",
    "taplo",
    "yamlls",
    "gopls",
    "lua_ls",
  },
})

local servers = {
  lua_ls = require("lsp.config.lua"),
}


for name, config in pairs(servers) do
  if config ~= nill and type(config) == "table" then
    config.on_setup(lspconfig[name])
  else 
    lspconfig[name].setup({})
  end
end
