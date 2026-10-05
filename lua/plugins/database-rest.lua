return {
  -- ─────────────────────────────────────────────────────────────────────────
  -- vim-dadbod + dadbod-ui — full database client inside Neovim
  -- Supports: PostgreSQL, MySQL, SQLite, Redis, MongoDB, MSSQL, and more
  -- Like TablePlus or DBeaver, but inside your editor
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>D",  "<cmd>DBUIToggle<cr>",        desc = "Database UI" },
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "DB: Add Connection" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>",    desc = "DB: Find Buffer" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 35
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      -- Auto-completion in SQL buffers
      vim.g.db_ui_auto_execute_table_helpers = 1
    end,
  },

  -- dadbod-completion: SQL autocomplete in .sql and dadbod query buffers
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql" },
    config = function()
      -- Hook into nvim-cmp sources for SQL files
      local cmp = require("cmp")
      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = cmp.config.sources({
          { name = "vim-dadbod-completion" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- kulala.nvim — run HTTP requests from .http / .rest files
  -- No luarocks deps, works out of the box on macOS ARM
  -- Create a file like:
  --   GET https://api.example.com/todos/1
  --   ###
  --   POST https://api.example.com/users
  --   Content-Type: application/json
  --   { "name": "John" }
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    keys = {
      { "<leader>rr", function() require("kulala").run() end,            ft = { "http", "rest" }, desc = "REST: Run request" },
      { "<leader>rl", function() require("kulala").replay() end,         ft = { "http", "rest" }, desc = "REST: Replay last" },
      { "<leader>rn", function() require("kulala").jump_next() end,      ft = { "http", "rest" }, desc = "REST: Next request" },
      { "<leader>rp", function() require("kulala").jump_prev() end,      ft = { "http", "rest" }, desc = "REST: Prev request" },
      { "<leader>ri", function() require("kulala").inspect() end,        ft = { "http", "rest" }, desc = "REST: Inspect (curl)" },
      { "<leader>rc", function() require("kulala").copy() end,           ft = { "http", "rest" }, desc = "REST: Copy as curl" },
      { "<leader>re", function() require("kulala").set_selected_env() end, ft = { "http", "rest" }, desc = "REST: Select env" },
    },
    opts = {
      environment_scope = "b",    -- use buffer-local env vars
      ui = {
        default_view = "body",    -- show response body by default
        display_mode = "split",   -- open result in a split
        split_direction = "vertical",
        win_opts = { wo = { number = false } },
      },
      contenttypes = {
        ["application/json"] = {
          ft = "json",
          formatter = { "jq", "." }, -- pretty-print JSON (requires jq)
        },
        ["application/xml"] = { ft = "xml" },
        ["text/html"] = { ft = "html" },
      },
    },
  },
}
