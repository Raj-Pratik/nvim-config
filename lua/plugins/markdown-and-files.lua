return {
  -- ─────────────────────────────────────────────────────────────────────────
  -- render-markdown.nvim — renders Markdown IN the buffer with concealed
  -- syntax and styled headings (no external browser needed)
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "md", "mdx" },
    keys = {
      { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Toggle Markdown render" },
    },
    opts = {
      enabled = false,
      render_modes = { "n", "c" },    -- render in normal mode and command mode
      heading = {
        enabled = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "full",
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",               -- full block background for code fences
        border = "thin",
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
      },
      link = {
        enabled = true,
        image = "󰥶 ",
        hyperlink = "󰌹 ",
      },
      pipe_table = {
        enabled = true,
        style = "full",
        cell = "padded",
      },
    },
  },

  -- markdown-preview.nvim — opens rendered Markdown in a real browser tab
  -- Useful when you need to share or proofread final output
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<leader>mb", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview (browser)" },
    },
    init = function()
      vim.g.mkdp_auto_close = 1        -- close browser tab when buffer is closed
      vim.g.mkdp_combine_preview = 1   -- reuse tab instead of opening new ones
      vim.g.mkdp_theme = "dark"
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- Makefile support — syntax, targets completion, and run via toggleterm
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Bash LSP helps with embedded shell in Makefiles
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
        },
      },
    },
  },

  -- mason: ensure bash-language-server is installed for shell/Makefile help
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "dockerfile-language-server",  -- already covered by docker extra, but explicit
      })
      return opts
    end,
  },
}
