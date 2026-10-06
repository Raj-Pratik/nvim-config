return {
  -- toggleterm.nvim — persistent floating/split terminals (like VS Code's integrated terminal)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<D-h>", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle Terminal Panel", mode = { "n", "i", "t" } },
      -- <C-`> mirrors VS Code's terminal shortcut
      { "<C-`>",     "<cmd>ToggleTerm direction=float<cr>",      desc = "Toggle Float Terminal",      mode = { "n", "t" } },
      { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>",     desc = "Terminal (float)" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>",desc = "Terminal (horizontal split)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",  desc = "Terminal (vertical split)" },
      { "<leader>tf", "<cmd>ToggleTerm direction=tab<cr>",       desc = "Terminal (full tab)" },
      {
        "<leader>tn",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local term = Terminal:new({ direction = "float", dir = vim.fn.getcwd() })
          term.display_name = "Shell " .. term.id
          term:toggle()
        end,
        desc = "New Named Terminal",
      },
      { "<leader>tP", "<cmd>TermSelect<cr>", desc = "Pick Terminal Session" },
      { "<leader>tN", "<cmd>ToggleTermSetName<cr>", desc = "Rename Terminal Session" },
      { "<leader>tp", "<cmd>Telescope buffers<cr>",              desc = "Terminal and Buffer Picker" },
      -- Quickly send a line/selection to the terminal
      { "<leader>ts", "<cmd>ToggleTermSendCurrentLine<cr>",      desc = "Send line to terminal",       mode = "n" },
      { "<leader>ts", "<cmd>ToggleTermSendVisualSelection<cr>",  desc = "Send selection to terminal",  mode = "v" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping = [[<C-`>]],
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,   -- <C-`> works while inside the terminal too
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = "double",
        width = function() return math.floor(vim.o.columns * 0.85) end,
        height = function() return math.floor(vim.o.lines * 0.80) end,
        winblend = 5,
      },
      winbar = {
        enabled = true,
        name_formatter = function(term)
          return string.format("  %02d  %s  | Esc: normal  Ctrl-q: hide ", term.id, term.display_name or term.name)
        end,
      },
      on_open = function(term)
        local map_opts = { buffer = term.bufnr, silent = true }
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], vim.tbl_extend("force", map_opts, { desc = "Terminal: normal mode" }))
        vim.keymap.set("t", "<C-q>", function() term:close() end, vim.tbl_extend("force", map_opts, { desc = "Terminal: hide" }))
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], vim.tbl_extend("force", map_opts, { desc = "Terminal: left window" }))
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], vim.tbl_extend("force", map_opts, { desc = "Terminal: lower window" }))
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], vim.tbl_extend("force", map_opts, { desc = "Terminal: upper window" }))
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], vim.tbl_extend("force", map_opts, { desc = "Terminal: right window" }))
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], vim.tbl_extend("force", map_opts, { desc = "Terminal: window commands" }))
      end,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
