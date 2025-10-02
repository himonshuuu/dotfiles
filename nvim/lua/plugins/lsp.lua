require('mason').setup()
-- require('mason-lspconfig').setup {
--     ensure_installed = {
--         'ts_ls', 'eslint', 'tailwindcss', 'pyright', 'clangd',
--         'cssls', 'html', 'jsonls', 'lua_ls'
--     },
-- }

local lspconfig = require('lspconfig')
local servers = {
  ts_ls = {
    settings = {
      javascript = {
        tsx = {
          experimental = {
            useSeparateSyntaxServer = true,
          },
        },
      },
    },
  },
  eslint = {},
  tailwindcss = {},
  pyright = {},
  clangd = {},
  cssls = {},
  html = {},
  jsonls = {},
  gopls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      }
    }
  },
}

-- nvim-navic setup for breadcrumbs in winbar
local navic = require('nvim-navic')

for server, config in pairs(servers) do
  local on_attach = config.on_attach
  config.on_attach = function(client, bufnr)
    if on_attach then on_attach(client, bufnr) end
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end
  config.capabilities = require('cmp_nvim_lsp').default_capabilities()
  lspconfig[server].setup(config)
end

-- Set winbar to show breadcrumbs using navic
vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

require('which-key').setup {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
  },
}

vim.o.updatetime = 500

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    if filetype == '' then return end

    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    if diagnostics and #diagnostics > 0 then
      vim.diagnostic.open_float(nil, { focus = false, border = 'rounded' })
    else
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      if #clients > 0 then
        -- only show hover if there is content
        local params = vim.lsp.util.make_position_params(nil, clients[1] and clients[1].offset_encoding or "utf-16")
        vim.lsp.buf_request(bufnr, 'textDocument/hover', params, function(err, result, ctx, config)
          if err or not result or not result.contents or vim.tbl_isempty(result.contents) then
            return
          end
          vim.lsp.util.open_floating_preview(
            vim.lsp.util.convert_input_to_markdown_lines(result.contents),
            'markdown',
            { border = 'rounded' }
          )
        end)
      end
    end
  end,
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.opt_local.winbar = " "
  end,
})
