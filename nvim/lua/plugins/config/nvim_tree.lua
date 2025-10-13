local nvim_tree = require("nvim-tree")
nvim_tree.setup()

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })


