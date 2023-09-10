-- Utils
local M = {}
function lvim:extend(opt)
  lvim = vim.tbl_deep_extend("force", self, opt)
end

-- 
function lvim:appearance_extend(opt)
  lvim.builtin.alpha.dashboard.config = vim.tbl_deep_extend("force", self, opt)
end

function M.extend(target, opt)
  vim.tbl_deep_extend("force", target, opt)
end

return M
