return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Cmd+P → find files (like VS Code)
      { "<D-p>", LazyVim.pick("files"), desc = "Find Files (Cmd+P)", mode = { "n", "i", "x" } },
      { "<D-S-f>", LazyVim.pick("live_grep"), desc = "Search Project (Cmd+Shift+F)", mode = { "n", "i", "x" } },
      -- VS Code terminal sends these for Cmd+P / Cmd+Shift+F (see keybindings.json)
      { "<C-M-S-F11>", LazyVim.pick("files"), desc = "Find Files (Cmd+P)", mode = { "n", "i", "x" } },
      { "<C-M-S-F12>", LazyVim.pick("live_grep"), desc = "Search Project (Cmd+Shift+F)", mode = { "n", "i", "x" } },
      { "<D-S-p>", "<cmd>Telescope commands<cr>", desc = "Command Palette", mode = { "n", "i", "x" } },
    },
    opts = {
      defaults = {
        -- fd respects .gitignore so node_modules is skipped automatically.
        -- These are a fallback for anything not in .gitignore.
        file_ignore_patterns = {
          "vendor/",
          "%.lock",
          "package%-lock%.json",
        },
      },
      pickers = {
        find_files = {
          -- Use fd: fast, respects .gitignore, never enters node_modules
          find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" },
        },
        live_grep = {
          additional_args = { "--hidden", "--glob=!.git", "--glob=!node_modules" },
        },
        grep_string = {
          additional_args = { "--hidden", "--glob=!.git", "--glob=!node_modules" },
        },
      },
    },
  },

  -- telescope-fzf-native for significantly faster fuzzy finding
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
}
