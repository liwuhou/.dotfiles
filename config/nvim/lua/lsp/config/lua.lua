local runtime_path = vim.split(package.path, ";")

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local common = require("lsp.common-config")

local opts = {
  -- Find this config in this site:https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua    
  -- capabilities = common.capabilities,
  flags = common.flags,
  on_attach = function(cilent, bufnr)
    common.disableFormat(cilent)
    common.keyAttach(bufnr)
  end,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

return {
  on_setup = function(server)
    require("neodev").setup()
    server:setup(opts)
  end,
}
