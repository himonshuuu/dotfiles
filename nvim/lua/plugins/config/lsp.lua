require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "ts_ls",
    "pyright",
    "clangd",
    "lua_ls",
    "rust_analyzer",
  },
  automatic_installation = true,
})

local function on_attach(_, bufnr)
   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
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

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local servers = { "gopls", "ts_ls", "pyright", "clangd", "lua_ls", "rust_analyzer" }

for _, name in ipairs(servers) do
    vim.lsp.config[name] = {
      on_attach = on_attach,
      capabilities = capabilities,
    }
end
vim.lsp.enable(servers)
