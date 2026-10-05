return {
  -- ─────────────────────────────────────────────────────────────────────────
  -- Go debugger (uses Delve under the hood, same as VS Code Go extension)
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "go",
    keys = {
      { "<leader>dgt", function() require("dap-go").debug_test() end,           desc = "DAP: Debug Go Test" },
      { "<leader>dgl", function() require("dap-go").debug_last_test() end,      desc = "DAP: Debug Last Go Test" },
    },
    opts = {
      dap_configurations = {
        {
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
      },
      delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        port = "${port}",
        args = {},
        build_flags = "",
        detached = true,
      },
    },
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- JS/TS debugger — uses VS Code's js-debug adapter (same one VS Code ships)
  -- Works with Node.js, Chrome, Jest, Next.js, etc.
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "microsoft/vscode-js-debug",
        version = "1.*",
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
      },
    },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      local dap = require("dap")
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = {
          "pwa-node",       -- Node.js
          "pwa-chrome",     -- Chrome/Chromium
          "pwa-msedge",     -- Edge
          "node-terminal",
          "pwa-extensionHost",
        },
      })

      -- Configure launch configs for each JS/TS filetype
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          -- Run current file with Node
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (Node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          -- Attach to a running Node process
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process (Node)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          -- Debug Jest tests
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            runtimeExecutable = "node",
            runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest", "--runInBand" },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            sourceMaps = true,
          },
          -- Debug Vitest tests
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Vitest Tests",
            cwd = "${workspaceFolder}",
            program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
            args = { "--reporter=verbose" },
            smartStep = true,
            console = "integratedTerminal",
            sourceMaps = true,
          },
          -- Attach Chrome (for React/Next.js in browser)
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome (localhost:3000)",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
            sourceMaps = true,
          },
        }
      end
    end,
  },

  -- Mason: install the debuggers automatically
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "js-debug-adapter",   -- VS Code JS debug adapter
        "delve",              -- Go debugger
        "netcoredbg",         -- .NET Core debugger
      })
      return opts
    end,
  },

  -- .NET / C# debugger
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")
      if not dap.adapters["netcoredbg"] then
        dap.adapters["netcoredbg"] = {
          type = "executable",
          command = vim.fn.exepath("netcoredbg"),
          args = { "--interpreter=vscode" },
        }
      end
      for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = "netcoredbg",
              name = "Launch .NET app",
              request = "launch",
              program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
              end,
            },
            {
              type = "netcoredbg",
              name = "Attach .NET process",
              request = "attach",
              processId = require("dap.utils").pick_process,
            },
          }
        end
      end
    end,
  },
}
