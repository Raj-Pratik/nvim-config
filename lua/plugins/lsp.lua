return {
  -- Auto-install LSP servers, formatters, and linters via Mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- HTML & CSS
        "html-lsp",
        "css-lsp",
        "emmet-ls",

        -- JSON & YAML (config files)
        "json-lsp",
        "yaml-language-server",

        -- TypeScript / JavaScript (installed by the typescript extra too)
        "eslint-lsp",
        "prettier",

        -- Go (installed by the go extra too)
        "gopls",
        "goimports",

        -- C# / .NET (installed by the omnisharp extra too)
        "omnisharp",

        -- Tailwind (installed by the tailwind extra too)
        "tailwindcss-language-server",
      },
    },
  },

  -- Configure LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<F12>", function() return vim.lsp.buf.definition() end, desc = "Go to Definition", has = "definition" },
            { "<S-F12>", LazyVim.pick("lsp_references"), desc = "Find References", has = "references" },
            { "<leader>cr", LazyVim.pick("lsp_references"), desc = "Find References", has = "references" },
          },
        },
        -- HTML — works with Emmet snippets
        html = {
          filetypes = { "html", "templ", "htmldjango" },
          init_options = {
            provideFormatter = true,
          },
        },

        -- CSS / SCSS / LESS
        cssls = {
          settings = {
            css = { validate = true, lint = { unknownAtRules = "ignore" } },
            scss = { validate = true, lint = { unknownAtRules = "ignore" } },
            less = { validate = true },
          },
        },

        -- Emmet — fast HTML/CSS abbreviation expansion (like VS Code Emmet)
        emmet_ls = {
          filetypes = {
            "html", "css", "scss", "javascript", "javascriptreact",
            "typescript", "typescriptreact", "vue", "svelte",
          },
        },

        -- vtsls (React/JS/TS): VS Code-style inlay hints and import handling
        vtsls = {
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              preferences = {
                importModuleSpecifier = "non-relative",
                includeCompletionsForModuleExports = true,
                includeCompletionsForImportStatements = true,
                includePackageJsonAutoImports = "auto",
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
                variableTypes = { enabled = true },
              },
            },
          },
        },

        -- YAML
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
              },
            },
          },
        },
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.completion = opts.completion or {}
      opts.completion.menu = vim.tbl_deep_extend("force", opts.completion.menu or {}, { auto_show = true })
      opts.completion.documentation = vim.tbl_deep_extend("force", opts.completion.documentation or {}, {
        auto_show = true,
        auto_show_delay_ms = 150,
      })
      opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
        enabled = true,
        window = { border = "rounded", show_documentation = true },
      })
      opts.keymap = opts.keymap or {}
      opts.keymap["<C-Space>"] = { "show", "show_documentation", "hide_documentation" }
      return opts
    end,
  },

  -- schemastore.nvim is already provided by LazyVim's yaml/json extras;
  -- declaring it here as optional avoids the duplicate-clone error.
  { "b0o/SchemaStore.nvim", lazy = true },
}
