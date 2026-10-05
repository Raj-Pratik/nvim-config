return {
  -- gitsigns: inline git blame + hunk navigation (like VS Code GitLens)
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- show blame annotation at end of line
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 400,
      },
      current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> · <summary>",
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation (like VS Code's prev/next change arrows)
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        -- Stage / reset hunks
        map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line (full)")
        map("n", "<leader>ghB", gs.toggle_current_line_blame, "Toggle Line Blame")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
      end,
    },
  },

  -- diffview: side-by-side diffs + full file history (like VS Code Timeline/Diff)
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diff View (all changes)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gX", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true },
      },
    },
  },

  -- fugitive: full git CLI inside Neovim (:Git, :Gdiffsplit, :Gread, :Gwrite, :GBrowse)
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
    dependencies = { "tpope/vim-rhubarb" },
    keys = {
      { "<leader>gF", "<cmd>Git<cr>", desc = "Fugitive Status" },
      { "<leader>gk", "<cmd>Git push<cr>", desc = "Git Push" },
      { "<leader>gj", "<cmd>Git pull --rebase<cr>", desc = "Git Pull (rebase)" },
      { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Stage File" },
      { "<leader>gv", "<cmd>Gvdiffsplit!<cr>", desc = "Diff File vs Index (split)" },
    },
  },

  -- git-conflict: VS Code-style "Accept Current / Incoming / Both" for merge conflicts
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPre",
    opts = {
      default_mappings = true, -- co: ours, ct: theirs, cb: both, c0: none, ]x/[x: next/prev conflict
      disable_diagnostics = true,
    },
    keys = {
      { "<leader>gx", "<cmd>GitConflictListQf<cr>", desc = "List Merge Conflicts" },
    },
  },

  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gM", "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<cr>", desc = "Diff Branch vs Default (PR review)" },
      { "<leader>gR", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
    },
  },
}
