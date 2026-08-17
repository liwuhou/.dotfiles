local function apply_surface_highlights()
  if vim.g.colors_name ~= "onedark" then
    return
  end

  local ok, colors = pcall(require, "onedark.colors")
  if not ok then
    return
  end

  local hl = vim.api.nvim_set_hl
  hl(0, "NormalFloat", { fg = colors.fg, bg = colors.bg_d })
  hl(0, "FloatBorder", { fg = colors.bg3, bg = colors.bg_d })
  hl(0, "FloatTitle", { fg = colors.bg_d, bg = colors.blue, bold = true })
  hl(0, "Pmenu", { fg = colors.fg, bg = colors.bg0 })
  hl(0, "PmenuSbar", { bg = colors.bg1 })
  hl(0, "PmenuSel", { fg = colors.bg_d, bg = colors.bg_blue, bold = true })
  hl(0, "PmenuThumb", { bg = colors.bg3 })
  hl(0, "CmpItemAbbr", { fg = colors.fg })
  hl(0, "CmpItemAbbrMatch", { fg = colors.cyan, bold = true })
  hl(0, "CmpItemAbbrMatchFuzzy", { fg = colors.cyan, underline = true })
  hl(0, "CmpItemMenu", { fg = colors.light_grey })
  hl(0, "TelescopeNormal", { fg = colors.fg, bg = colors.bg_d })
  hl(0, "TelescopePromptNormal", { fg = colors.fg, bg = colors.bg0 })
  hl(0, "TelescopeResultsNormal", { fg = colors.fg, bg = colors.bg_d })
  hl(0, "TelescopePreviewNormal", { fg = colors.fg, bg = colors.bg_d })
  hl(0, "TelescopeBorder", { fg = colors.bg3, bg = colors.bg_d })
  hl(0, "TelescopePromptBorder", { fg = colors.blue, bg = colors.bg0 })
  hl(0, "TelescopeResultsBorder", { fg = colors.bg3, bg = colors.bg_d })
  hl(0, "TelescopePreviewBorder", { fg = colors.bg3, bg = colors.bg_d })
  hl(0, "TelescopePromptTitle", { fg = colors.bg_d, bg = colors.blue, bold = true })
  hl(0, "TelescopeResultsTitle", { fg = colors.bg_d, bg = colors.purple, bold = true })
  hl(0, "TelescopePreviewTitle", { fg = colors.bg_d, bg = colors.green, bold = true })
  hl(0, "TelescopePromptPrefix", { fg = colors.blue, bg = colors.bg0, bold = true })
  hl(0, "TelescopeSelection", { bg = colors.bg2 })
  hl(0, "TelescopeSelectionCaret", { fg = colors.yellow, bg = colors.bg2 })
  hl(0, "TelescopeMatching", { fg = colors.orange, bold = true })
  hl(0, "WhichKeyFloat", { fg = colors.fg, bg = colors.bg0 })
  hl(0, "WhichKeyBorder", { fg = colors.bg3, bg = colors.bg0 })
  hl(0, "WhichKeyDesc", { fg = colors.blue })
  hl(0, "WhichKeyGroup", { fg = colors.orange, bold = true })
  hl(0, "WhichKeySeparator", { fg = colors.grey })
  hl(0, "WhichKeyValue", { fg = colors.light_grey })
  hl(0, "LazyNormal", { bg = colors.bg_d })
  hl(0, "MasonNormal", { bg = colors.bg_d })
  hl(0, "MasonHighlight", { fg = colors.cyan })
  hl(0, "MasonHighlightSecondary", { fg = colors.yellow })
  hl(0, "MasonMuted", { fg = colors.light_grey })
  hl(0, "MasonHeader", { fg = colors.bg_d, bg = colors.yellow, bold = true })
  hl(0, "MasonHeaderSecondary", { fg = colors.bg_d, bg = colors.cyan, bold = true })
  hl(0, "WinSeparator", { fg = colors.bg2 })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("UserAppearanceSurfaceHighlights", { clear = true }),
  pattern = "onedark",
  callback = apply_surface_highlights,
})
