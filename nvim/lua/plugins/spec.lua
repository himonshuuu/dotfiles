local M = {}

M.spec = {
  { "nvim-tree/nvim-tree.lua", config = function()
      require("plugins.config.nvim_tree")
    end
  },
  {
    "goolord/alpha-nvim",
    config = function()
      require("plugins.config.alpha")
    end
  },
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
      require("plugins.config.treesitter")
    end
  },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig", config = function()
      require("plugins.config.lsp")
    end
  },
}

return M


