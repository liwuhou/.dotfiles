local M = {}

local function get_mode(mode)
  if mode == "n" or mode == nil then
    mode = "normal_mode"
  elseif mode == "v" then
    mode = "visual_mode"
  elseif mode == "i" then
    mode = "insert_mode"
  elseif mode == "t" then
    mode = "term_mode"
  end
  return mode
end

M.keymap = function(key, mapping, mode)
  if type(mode) == "table" then
    for _, m in ipairs(mode) do
      lvim.keys[get_mode(m)][key] = mapping
    end
  else
    lvim.keys[get_mode(mode)][key] = mapping
  end
end

M.reset = function()
  local reset_key = {
    "<C-j>",
    "<C-k>",
    "<C-l>",
    "<C-h>",
    "<C-Up>",
    "<C-Down>",
    "<C-Left>",
    "<C-Right>",
    "<C-=>",
  }
  for _, key in ipairs(reset_key) do
    M.keymap(key, false, { "v", "n", "t" })
  end

  lvim.lsp.buffer_mappings.normal_mode["K"] = nil
end

return M
