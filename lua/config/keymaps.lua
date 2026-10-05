-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "i", "x" }, "jj", "<Esc>", { desc = "Return to Normal Mode" })
vim.keymap.set({ "n", "i", "x" }, "<D-j>", "<Esc><C-o>", { desc = "Navigate Back" })
vim.keymap.set({ "n", "i", "x" }, "<D-k>", "<Esc><C-i>", { desc = "Navigate Forward" })
-- VS Code terminal sends these for Cmd+J / Cmd+K; they also survive tmux
vim.keymap.set({ "n", "i", "x" }, "<C-M-S-F9>", "<Esc><C-o>", { desc = "Navigate Back (Cmd+J)" })
vim.keymap.set({ "n", "i", "x" }, "<C-M-S-F10>", "<Esc><C-i>", { desc = "Navigate Forward (Cmd+K)" })
local cmd_backspace = "\27[27;8~"
vim.keymap.set("i", cmd_backspace, "<C-u>", { desc = "Delete to line start" })
vim.keymap.set("n", cmd_backspace, "d0", { desc = "Delete to line start" })
vim.keymap.set("x", cmd_backspace, "d", { desc = "Delete selection" })
vim.keymap.set("n", "<leader>zh", "10zh", { desc = "Scroll Left 10 Columns" })
vim.keymap.set("n", "<leader>zl", "10zl", { desc = "Scroll Right 10 Columns" })
vim.keymap.set("n", "<leader>nb", "<C-o>", { desc = "Navigate Back" })
vim.keymap.set("n", "<leader>nf", "<C-i>", { desc = "Navigate Forward" })

-- Buffer and window controls for a multi-file workflow.
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>wt", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>wc", "<cmd>close<cr>", { desc = "Close Window" })
vim.keymap.set("n", "<leader>wo", "<cmd>only<cr>", { desc = "Keep Only Window" })
vim.keymap.set("n", "<leader>wd", "<C-w>d", { desc = "Focus Diagnostics" })
vim.keymap.set("n", "<leader>bb", "<cmd>BufferLinePick<cr>", { desc = "Pick Open Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>BufferLinePickClose<cr>", { desc = "Pick Buffer to Close" })
vim.keymap.set("n", "<leader>bD", function()
  Snacks.bufdelete(0)
end, { desc = "Close Current Buffer" })

-- Ctrl+Click → go to definition (like VS Code)
-- <C-LeftMouse> moves the cursor to the clicked position, then jumps to definition.
vim.keymap.set("n", "<C-LeftMouse>", function()
  vim.api.nvim_input("<LeftMouse>")       -- move cursor to click position first
  vim.schedule(vim.lsp.buf.definition)    -- then jump to definition
end, { desc = "Ctrl+Click: Go to Definition" })

-- Ctrl+Click in insert mode: same behaviour
vim.keymap.set("i", "<C-LeftMouse>", function()
  vim.api.nvim_input("<LeftMouse><Esc>")
  vim.schedule(vim.lsp.buf.definition)
end, { desc = "Ctrl+Click: Go to Definition" })
