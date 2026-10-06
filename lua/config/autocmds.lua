-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local yank_group = vim.api.nvim_create_augroup("YankNotifications", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_group,
	callback = function()
		local event = vim.v.event
		if event.operator ~= "y" then
			return
		end

		local line_count = #event.regcontents
		local line_label = line_count == 1 and "line" or "lines"
		vim.notify("Yanked " .. line_count .. " " .. line_label, vim.log.levels.INFO, { title = "Yank" })
	end,
})

local terminal_group = vim.api.nvim_create_augroup("BuiltInTerminalMappings", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = terminal_group,
	callback = function(event)
		local buffer = event.buf
		if vim.b[buffer].toggle_number ~= nil or vim.b[buffer].snacks_terminal ~= nil then
			return
		end

		vim.keymap.set("t", "jj", [[<C-\><C-n>]], {
			buffer = buffer,
			desc = "Return to Normal Mode",
		})
	end,
})
