return {
  -- Disable oil.nvim so LazyVim's default neo-tree sidebar is used instead
  { "stevearc/oil.nvim", enabled = false },

  -- ─────────────────────────────────────────────────────────────────────────
  -- neo-tree — VS Code–style sidebar file explorer (LazyVim default)
  -- <leader>e  open explorer focused on current file
  -- <leader>E  open explorer at project root
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,       -- hide filtered items by default
          hide_dotfiles = false, -- show dotfiles (like .env)
          hide_gitignored = true,
          hide_by_name = { ".git", "node_modules", "vendor", ".next", "dist", "build" },
          never_show = { ".DS_Store" },
        },
        follow_current_file = {
          enabled = true,        -- auto-reveal current file in tree (like VS Code)
          leave_dirs_open = true,
        },
        use_libuv_file_watcher = true, -- live-update tree on disk changes
      },
      window = {
        width = 35,
        mappings = {
          ["<space>"] = "none", -- don't conflict with <leader>
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy path to clipboard",
          },
        },
      },
      default_component_configs = {
        indent = { with_expanders = true },
        icon = {
          provider = function(icon, node)
            if node.type == "file" then
              local glyph, highlight = require("mini.icons").get("file", node.name)
              icon.text = glyph
              icon.highlight = highlight
            end
            return icon
          end,
        },
        git_status = {
          symbols = {
            added     = "✚",
            modified  = "",
            deleted   = "✖",
            renamed   = "󰁕",
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },
    },
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- Harpoon 2 — pin up to 4 "hot" files and jump between them instantly
  -- Think: VS Code pinned tabs but with instant numbered access
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end,                          desc = "Harpoon: Add file" },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: Menu" },
      { "<leader>1",  function() require("harpoon"):list():select(1) end,                      desc = "Harpoon: File 1" },
      { "<leader>2",  function() require("harpoon"):list():select(2) end,                      desc = "Harpoon: File 2" },
      { "<leader>3",  function() require("harpoon"):list():select(3) end,                      desc = "Harpoon: File 3" },
      { "<leader>4",  function() require("harpoon"):list():select(4) end,                      desc = "Harpoon: File 4" },
      -- [h / ]h are reserved for git hunks
      { "<leader>hp", function() require("harpoon"):list():prev() end,                         desc = "Harpoon: Prev file" },
      { "<leader>hn", function() require("harpoon"):list():next() end,                         desc = "Harpoon: Next file" },
    },
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    },
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- nvim-surround — add/change/delete surrounding pairs
  -- cs"' → change " to ' | ds" → delete " | ysiw" → surround word with "
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {}, -- use defaults
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- persistence.nvim — auto-save and restore sessions per project directory
  -- Like VS Code's "reopen last workspace" — automatically picks up where
  -- you left off when you open Neovim from the same directory.
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- must be loaded before first buffer opens
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session (cwd)" },
      { "<leader>qS", function() require("persistence").select() end,              desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Session" },
    },
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    },
  },

  -- Auto-save changed file buffers with a toggle for quick opt-out.
  {
    "okuuva/auto-save.nvim",
    version = "^1.0.0",
    event = { "InsertLeave", "TextChanged" },
    cmd = "ASToggle",
    keys = {
      { "<leader>ua", "<cmd>ASToggle<cr>", desc = "Toggle Auto Save" },
    },
    opts = {
      enabled = true,
      debounce_delay = 1000,
      condition = function(bufnr)
        return vim.bo[bufnr].buftype == ""
      end,
    },
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- Neotest adapters — add test runners for your languages
  -- The core neotest UI is already enabled via lazyvim.json (test.core extra)
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "nvim-neotest/neotest",
    dependencies = {
      -- JavaScript / TypeScript (Jest, Vitest)
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
      -- Go
      "nvim-neotest/neotest-go",
      -- .NET / C#
      "Issafalcon/neotest-dotnet",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, {
        require("neotest-vitest"),
        require("neotest-jest")({
          jestCommand = "npx jest",
          jestConfigFile = "jest.config.ts",
          env = { CI = true },
          cwd = function() return vim.fn.getcwd() end,
        }),
        require("neotest-go")({ recursive_run = true }),
        require("neotest-dotnet")({
          dap = { justMyCode = false },
        }),
      })
      return opts
    end,
  },
}
