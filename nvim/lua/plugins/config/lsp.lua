-- Mason setup (manages external LSP binaries)
require("mason").setup()

-- Ensure servers are installed via mason-lspconfig
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",      -- Go
    "tsserver",   -- TypeScript/JavaScript
    "pyright",    -- Python
    "clangd",     -- C/C++
  },
  automatic_installation = true,
})

local lspconfig = require("lspconfig")

-- Common on_attach for LSP keymaps
local function on_attach(_, bufnr)
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  bufmap("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  bufmap("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
  bufmap("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
  bufmap("n", "gr", vim.lsp.buf.references, "References")
  bufmap("n", "K", vim.lsp.buf.hover, "Hover")
  bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  bufmap("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, "Format")
  bufmap("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
  bufmap("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

lspconfig.gopls.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.tsserver.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.pyright.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.clangd.setup({ on_attach = on_attach, capabilities = capabilities })


