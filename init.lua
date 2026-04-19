vim.cmd('source ~/.vimrc')
vim.lsp.config['nixd'] = {
  cmd = {'nixd'},
  filetypes = { 'nix' },
  root_markers = { '.git' }
}
vim.lsp.enable('nixd')
