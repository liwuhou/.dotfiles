local mason_status, mason = pcall(require, "mason")
local msp_status, msp = pcall(require, "mason-lspconfig")

if not mason_status and msp_status then
  vim.notify("Mason is not found!")
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

msp.setup({
  ensure_installed = { "lua_ls" },
  automatic_installtion = true,
  handlers = {
    function(server_name)
      local config = servers[server_name]
      if config == nil then
        return 
      end

      if config.on_setup then
        config.on_setup(require("lspconfig")[server_name])
      else
        require("lspconfig")[server_name].setup()
      end
    end
  }

})

