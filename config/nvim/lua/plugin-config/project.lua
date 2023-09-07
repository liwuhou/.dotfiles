local status, project = pcall(require, "project_nvim")

if not status then
  vim.notify("ProjectNvim is not Found")
  return
end

vim.g.nvim_tree_respect_buf_cwd = 1

project.setup({
  detection_method = { "pattern" },
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".sln", "Cargo.toml" }
})

local status, telescope = pcall(require, "telescope")

if not status then
  vim.notify("Telescope is not Found!")
  return
end
pcall(telescope.load_extension, "projects")

