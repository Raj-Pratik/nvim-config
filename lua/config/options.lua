-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable mouse in all modes (required for Ctrl+Click)
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.showcmd = true
vim.opt.showcmdloc = "statusline"

vim.g.lazyvim_picker = "telescope"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.guicursor = "a:block"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
