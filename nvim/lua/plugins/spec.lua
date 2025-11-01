local M = {}

M.spec = {
  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup {
        style = "darker",
        transparent = true,
      }
      require("onedark").load()
    end
  },
  {
    "goolord/alpha-nvim",
    config = function()
      require("plugins.config.alpha")
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", config = function()
      require("plugins.config.treesitter")
    end
  },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("plugins.config.lsp")
    end
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("plugins.config.comment")
    end
  },

  {
    dir = "~/Projects/discord.nvim",
    config = function()
      require("discord").setup(
        {
          log_level = "info",
          idle_timeout_ms = 600000,
        }
      )
    end,
  }
}

return M


