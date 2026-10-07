local search_options = {
  case_sensitive = false,
  whole_word = false,
}

local search_option_labels = {
  case_sensitive = "Match case",
  whole_word = "Whole word",
}

local function set_search_option(option, enabled)
  search_options[option] = enabled
  vim.notify(
    string.format("%s %s", search_option_labels[option], enabled and "enabled" or "disabled"),
    vim.log.levels.INFO,
    { title = "Search" }
  )
end

local function toggle_search_option(option)
  set_search_option(option, not search_options[option])
end

local function live_grep(cwd, query)
  local case_sensitive = search_options.case_sensitive
  local whole_word = search_options.whole_word
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  require("telescope.builtin").live_grep({
    cwd = cwd,
    default_text = query,
    prompt_title = string.format(
      "Live Grep [Match Case: %s] [Whole Word: %s]",
      case_sensitive and "On" or "Off",
      whole_word and "On" or "Off"
    ),
    additional_args = function()
      local args = { "--hidden", "--glob=!.git", "--glob=!node_modules" }
      table.insert(args, case_sensitive and "--case-sensitive" or "--ignore-case")
      if whole_word then
        table.insert(args, "--word-regexp")
      end
      return args
    end,
    attach_mappings = function(prompt_bufnr, map)
      local function toggle(option)
        local current_query = action_state.get_current_line()
        toggle_search_option(option)
        actions.close(prompt_bufnr)
        vim.schedule(function()
          live_grep(cwd, current_query)
        end)
      end

      for _, mode in ipairs({ "i", "n" }) do
        map(mode, "<M-c>", function()
          toggle("case_sensitive")
        end, { desc = "Toggle Match Case" })
        map(mode, "<M-w>", function()
          toggle("whole_word")
        end, { desc = "Toggle Whole Word" })
      end
      return true
    end,
  })
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>/", false },
      {
        "<leader>//",
        function()
          live_grep(LazyVim.root() or vim.uv.cwd(), "")
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>/c",
        function()
          toggle_search_option("case_sensitive")
        end,
        desc = "Toggle Search Match Case",
      },
      {
        "<leader>/w",
        function()
          toggle_search_option("whole_word")
        end,
        desc = "Toggle Search Whole Word",
      },
      {
        "<leader>sG",
        function()
          live_grep(vim.uv.cwd(), "")
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>b",
        function()
          require("telescope.builtin").buffers({ initial_mode = "normal" })
        end,
        desc = "Switch Open Buffers",
      },
      { "<leader>bf", false },
      -- Cmd+P → find files (like VS Code)
      { "<D-p>", LazyVim.pick("files"), desc = "Find Files (Cmd+P)", mode = { "n", "i", "x" } },
      { "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in Current File" },
      { "<leader>fg", LazyVim.pick("live_grep"), desc = "Search Project Text" },
      -- VS Code terminal sends this for Cmd+P (see keybindings.json)
      { "<C-M-S-F11>", LazyVim.pick("files"), desc = "Find Files (Cmd+P)", mode = { "n", "i", "x" } },
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
