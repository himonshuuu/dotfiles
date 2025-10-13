vim.g.mapleader = " "

vim.opt.number = true          
vim.opt.relativenumber = true  
vim.opt.tabstop = 2    
vim.opt.shiftwidth = 4         
vim.opt.expandtab = true       
vim.opt.smartindent = true     
vim.opt.wrap = false           
vim.opt.ignorecase = true      
vim.opt.smartcase = true       
vim.opt.cursorline = true      
vim.opt.termguicolors = true   
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 8

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
vim.opt.fillchars:append({ vert = " " })


