return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- 1. Add jdtls here
      ensure_installed = {
        "vtsls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "jdtls",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "eslint",
        "angularls",
      },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "stylua",
        "isort",
        "black",
        "pylint",
        "eslint_d",
        "google-java-format", -- Optional: Add this if you want auto-formatting for Spring
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
