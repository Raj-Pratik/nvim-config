local chat_modes = {
  Ask = {
    tools = {},
    trusted_tools = {},
    description = "Chat only; no workspace tools",
  },
  Plan = {
    tools = { "file", "buffer", "glob", "grep", "gitdiff", "selection" },
    trusted_tools = { "file", "buffer", "glob", "grep", "gitdiff", "selection" },
    description = "Read-only planning; no write or shell tools",
    system_prompt = "Planning mode: inspect the relevant workspace context and return a clear, ordered implementation plan. Do not edit files or run commands.",
  },
  Agent = {
    tools = { "copilot" },
    trusted_tools = {},
    description = "Workspace tools; ask before each action",
  },
  Autopilot = {
    tools = { "copilot" },
    trusted_tools = { "buffer", "file", "glob", "grep", "gitdiff", "selection", "edit" },
    description = "Read and edit automatically; ask before shell commands",
  },
}

local original_system_prompt

local function copilot_chat_status()
  local ok, chat = pcall(require, "CopilotChat")
  if not ok then
    return " Copilot Chat"
  end
  return string.format(" Copilot | %s | %s ", vim.g.copilot_chat_mode or "Ask", chat.config.model or "auto")
end

_G.CopilotChatStatus = copilot_chat_status

local function update_chat_winbar(chat)
  if chat.chat and chat.chat.winnr and vim.api.nvim_win_is_valid(chat.chat.winnr) then
    vim.wo[chat.chat.winnr].winbar = "%!v:lua.CopilotChatStatus()"
  end
end

local function set_copilot_mode(mode)
  local chat = require("CopilotChat")
  local profile = chat_modes[mode]
  original_system_prompt = original_system_prompt or chat.config.system_prompt
  chat.config.tools = vim.deepcopy(profile.tools)
  chat.config.trusted_tools = vim.deepcopy(profile.trusted_tools)
  chat.config.system_prompt = original_system_prompt
  if profile.system_prompt then
    chat.config.system_prompt = original_system_prompt .. "\n\n" .. profile.system_prompt
  end
  if chat.chat then
    chat.chat.config.tools = vim.deepcopy(profile.tools)
    chat.chat.config.trusted_tools = vim.deepcopy(profile.trusted_tools)
    chat.chat.config.system_prompt = chat.config.system_prompt
  end
  vim.g.copilot_chat_mode = mode
  update_chat_winbar(chat)
  vim.notify("Copilot " .. mode .. " mode: " .. profile.description)
end

local function select_copilot_mode()
  local modes = { "Ask", "Plan", "Agent", "Autopilot" }
  vim.ui.select(modes, {
    prompt = "Copilot mode",
    format_item = function(mode)
      return mode .. " - " .. chat_modes[mode].description
    end,
  }, function(mode)
    if mode then
      set_copilot_mode(mode)
    end
  end)
end

local function accept_latest_diff()
  local chat = require("CopilotChat")
  local mapping = require("CopilotChat.config.mappings").accept_diff
  if chat.chat then
    mapping.callback(chat.chat:get_source())
  end
end

local function undo_copilot_change()
  local chat = require("CopilotChat")
  local source = chat.chat and chat.chat:get_source()
  local bufnr = source and source.bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    vim.notify("No valid source buffer to undo", vim.log.levels.WARN)
    return
  end
  local ok, err = pcall(vim.api.nvim_buf_call, bufnr, function() vim.cmd.undo() end)
  if not ok then
    vim.notify("Could not undo Copilot change: " .. err, vim.log.levels.WARN)
  end
end

return {
  -- GitHub Copilot — AI inline completions
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      server = { type = "binary" },
      suggestion = {
        enabled = true,
        auto_trigger = true,    -- show ghost text as you type (like VS Code)
        debounce = 75,
        keymap = {
          accept = "<Tab>",     -- Tab to accept (same as VS Code)
          accept_word = "<C-Right>",
          accept_line = "<C-Down>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false }, -- use CopilotChat instead
      filetypes = {
        yaml = true,
        markdown = true,
        text = false,
        gitcommit = false,
        ["*"] = true,
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      completion = { ghost_text = { enabled = false } },
    },
  },

  -- Disable nvim-cmp ghost text so it doesn't clash with Copilot suggestions
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.experimental = opts.experimental or {}
      opts.experimental.ghost_text = false
      return opts
    end,
  },

  -- CopilotChat — conversational AI chat panel (like VS Code Copilot Chat)
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    cmd = { "CopilotChat", "CopilotChatToggle" },
    keys = {
      {
        "<leader>ac",
        function()
          local chat = require("CopilotChat")
          chat.toggle()
          update_chat_winbar(chat)
        end,
        desc = "Toggle Copilot Chat",
      },
      { "<leader>am", function() require("CopilotChat").select_model() end, desc = "Choose Copilot Model" },
      {
        "<leader>aM",
        select_copilot_mode,
        desc = "Choose Copilot Mode",
      },
      {
        "<leader>aS",
        function()
          vim.notify(copilot_chat_status():gsub("^%s+", ""):gsub("%s+$", ""))
        end,
        desc = "Show Copilot Model and Mode",
      },
      {
        "<leader>aA",
        function()
          set_copilot_mode("Autopilot")
          local chat = require("CopilotChat")
          chat.open()
          update_chat_winbar(chat)
        end,
        desc = "Start Copilot Autopilot",
      },
      {
        "<leader>aP",
        function()
          set_copilot_mode("Plan")
          local chat = require("CopilotChat")
          chat.open()
          update_chat_winbar(chat)
        end,
        desc = "Start Copilot Plan Mode",
      },
      { "<leader>ak", accept_latest_diff, desc = "Keep Copilot Diff" },
      { "<leader>au", undo_copilot_change, desc = "Undo Copilot Source Change" },
      { "<leader>ax", function() require("CopilotChat").stop() end, desc = "Stop Copilot Response" },
      {
        "<leader>av",
        function()
          local chat = require("CopilotChat")
          chat.open()
          chat.chat:focus()
          vim.cmd.startinsert()
          vim.notify("Use macOS Dictation to speak your prompt, then press Ctrl-S to send")
        end,
        desc = "Voice Prompt (macOS Dictation)",
      },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>",   desc = "Explain Code",        mode = { "n", "v" } },
      { "<leader>af", "<cmd>CopilotChatFix<cr>",       desc = "Fix Code",            mode = { "n", "v" } },
      { "<leader>at", "<cmd>CopilotChatTests<cr>",     desc = "Generate Tests",      mode = { "n", "v" } },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>",    desc = "Review Code",         mode = { "n", "v" } },
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>",  desc = "Refactor Code",       mode = { "n", "v" } },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>",      desc = "Generate Docs",       mode = { "n", "v" } },
      {
        "<leader>ai",
        function()
          local input = vim.fn.input("Ask Copilot: ")
          if input ~= "" then
            vim.cmd("CopilotChat " .. input)
          end
        end,
        desc = "Inline Ask Copilot",
      },
    },
    opts = {
      model = "gpt-5-mini",
      instruction_files = { ".github/copilot-instructions.md", "copilot-instructions.md", "AGENTS.md" },
      tools = {},
      trusted_tools = {},
      window = {
        layout = "vertical",  -- side panel like VS Code
        width = 0.42,
        title = "Copilot Chat",
      },
      show_help = true,
      auto_follow_cursor = true,
      mappings = {
        close = { normal = "q", insert = "<C-c>" },
        submit_prompt = { normal = "<CR>", insert = "<C-s>" },
        accept_diff = { normal = "<C-y>", insert = "<C-y>" },
        reset = { normal = "<C-l>", insert = "<C-l>" },
      },
    },
  },
}
