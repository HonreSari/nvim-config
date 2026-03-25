-- Autocommand for printing the autosaved message
local group = vim.api.nvim_create_augroup("autosave", {})
vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSaveWritePost",
  group = group,
  callback = function(opts)
    if opts.data.saved_buffer ~= nil then
      print("AutoSaved")
    end
  end,
})

-- Visual mode event handling
local visual_event_group = vim.api.nvim_create_augroup("visual_event", { clear = true })
vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_event_group,
  pattern = { "*:[vV\x16]*" },
  callback = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "VisualEnter" })
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_event_group,
  pattern = { "[vV\x16]*:*" },
  callback = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "VisualLeave" })
  end,
})

-- Handling Snacks input buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "snacks_input", "snacks_picker_input" },
  group = group,
  callback = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "SnacksInputEnter" })
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  pattern = "*",
  callback = function(opts)
    local ft = vim.bo[opts.buf].filetype
    if ft == "snacks_input" or ft == "snacks_picker_input" then
      vim.api.nvim_exec_autocmds("User", { pattern = "SnacksInputLeave" })
    end
  end,
})

return {
  {
    "okuuva/auto-save.nvim",
    enabled = true,
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
        defer_save = {
          "InsertLeave",
          "TextChanged",
          { "User", pattern = "VisualLeave" },
          { "User", pattern = "FlashJumpEnd" },
          { "User", pattern = "SnacksInputLeave" },
        },
        cancel_deferred_save = {
          "InsertEnter",
          { "User", pattern = "VisualEnter" },
          { "User", pattern = "FlashJumpStart" },
          { "User", pattern = "SnacksInputEnter" },
        },
      },
      condition = function(buf)
        local mode = vim.fn.mode()
        if mode == "i" then
          return false
        end

        local filetype = vim.bo[buf].filetype
        if filetype == "harpoon" or filetype == "mysql" then
          return false
        end

        -- Safe check for LuaSnip
        local ok, luasnip = pcall(require, "luasnip")
        if ok and luasnip.in_snippet() then
          return false
        end

        return true
      end,
      write_all_buffers = false,
      noautocmd = false,
      debounce_delay = 2000,
      debug = false,
    },
    config = function(_, opts)
      -- 1. Setup the auto-save plugin first
      require("auto-save").setup(opts)

      -- 2. Safely override Flash jump only AFTER the plugin is ready
      local status_ok, flash = pcall(require, "flash")
      if status_ok then
        local original_jump = flash.jump
        flash.jump = function(jump_opts)
          vim.api.nvim_exec_autocmds("User", { pattern = "FlashJumpStart" })
          original_jump(jump_opts)
          vim.api.nvim_exec_autocmds("User", { pattern = "FlashJumpEnd" })
        end
      end
    end,
  },
}
