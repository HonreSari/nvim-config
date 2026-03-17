return {
  -- "jackMort/ChatGPT.nvim",
  -- event = "VeryLazy",
  -- dependencies = {
  --   "MunifTanjim/nui.nvim",
  --   "nvim-lua/plenary.nvim",
  --   "folke/trouble.nvim",
  --   "nvim-telescope/telescope.nvim",
  -- },
  -- config = function()
  --   require("chatgpt").setup({
  --     api_key_cmd = "op read op://Personal/open-ai-key/credential",
  --   })
  -- end,
  -- keys = {
  --   { "<leader>ai", "<cmd>ChatGPT<cr>", desc = "Open chatgpt" },
  -- },

  "Exafunction/codeium.vim",
  event = "BufRead",
  config = function()
    -- Change <Tab> to something else if it conflicts with your autocomplete
    vim.keymap.set("i", "<C-g>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<c-;>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<c-,>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<c-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true })
  end,
}
