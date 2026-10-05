return {
  -- ─────────────────────────────────────────────────────────────────────────
  -- nvim-ts-autotag — auto-close AND auto-rename HTML/JSX/TSX tags
  -- Type <div and closing </div> appears. Rename opening → closing updates too.
  -- Like VS Code's "Auto Rename Tag" extension.
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
      per_filetype = {
        ["html"] = { enable_close = true },
        ["javascriptreact"] = { enable_close = true },
        ["typescriptreact"] = { enable_close = true },
        ["svelte"] = { enable_close = true },
        ["vue"] = { enable_close = true },
      },
    },
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- vim-visual-multi — multi-cursor editing
  -- <C-n> selects next match (like VS Code Ctrl+D)
  -- <C-Down>/<C-Up> adds cursor below/above (like VS Code Ctrl+Alt+Down)
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.VM_leader = "\\"
      vim.g.VM_maps = {
        ["Find Under"]         = "<C-n>",   -- select word under cursor / next match
        ["Find Subword Under"] = "<C-n>",
        ["Select All"]         = "\\A",     -- select all matches
        ["Add Cursor Down"]    = "<C-Down>",
        ["Add Cursor Up"]      = "<C-Up>",
        ["Start Regex Search"] = "\\/",
        ["Visual Regex"]       = "\\/",
        ["Undo"]               = "u",
        ["Redo"]               = "<C-r>",
      }
      vim.g.VM_theme = "ocean"
      vim.g.VM_highlight_matches = "underline"
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- inc-rename.nvim — live-preview rename as you type (VS Code F2 rename)
  -- noice.nvim is already configured with inc_rename = true preset above
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>cr",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename (live preview)",
      },
    },
    opts = {
      input_buffer_type = "dressing", -- use vim.ui.input (noice styles it)
    },
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- nvim-ufo — LSP-aware code folding with peek preview
  -- `za` toggle fold | `zR` open all | `zM` close all | `zp` peek fold
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,  desc = "Open All Folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close All Folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open Folds Except Kinds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close Folds With" },
      {
        "zp",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek Fold",
      },
    },
    opts = {
      -- Use LSP first, fall back to treesitter, then indent
      provider_selector = function(_, filetype, buftype)
        local ftMap = {
          vim = "indent",
          python = { "indent" },
          git = "",
        }
        if buftype == "nofile" then return "" end
        return ftMap[filetype] or { "lsp", "indent" }
      end,

      -- Show number of folded lines in the fold indicator
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d lines"):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
    config = function(_, opts)
      -- Required: tell Neovim to use ufo's fold capabilities
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99  -- start with all folds open
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup(opts)
    end,
  },
}
