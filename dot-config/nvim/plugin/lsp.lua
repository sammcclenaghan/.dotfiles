local function resolve_tsdk()
  local bufname = vim.api.nvim_buf_get_name(0)
  local start = bufname ~= '' and vim.fs.dirname(bufname) or vim.loop.cwd()

  local local_ts = vim.fs.find('node_modules/typescript/lib', {
    path = start,
    upward = true,
    type = 'directory',
    stop = vim.loop.os_homedir(),
  })[1]

  if local_ts then
    return local_ts
  end

  local npm_root = vim.fn.system({ 'npm', 'root', '-g' })
  if vim.v.shell_error == 0 then
    local global_ts = vim.fs.joinpath(vim.trim(npm_root), 'typescript', 'lib')
    if vim.fn.isdirectory(global_ts) == 1 then
      return global_ts
    end
  end
end

vim.g.tsdk = resolve_tsdk()

-- mason: install LSP servers via :Mason
vim.pack.add({ "https://github.com/mason-org/mason.nvim" })
vim.pack.add({ "https://github.com/mason-org/mason-lspconfig.nvim" })

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "ruby_lsp", "gopls" },
  automatic_enable = true,
})

-- servers not in mason (or you prefer manual install)
vim.lsp.enable({ "herb_ls" })

-- folding: LSP when available, treesitter fallback
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = "v:lua.vim.lsp.foldtext()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { buffer = ev.buf, desc = "Format" })
  end,
})

vim.o.completeopt = "menuone,popup,fuzzy,noselect"
