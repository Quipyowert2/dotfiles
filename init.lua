-- vim.cmd('source ~/.vimrc')
vim.o.compatible = false
vim.o.modeline = false -- disabled for now due to a serious modeline bypass bug
vim.o.number = true
vim.o.encoding = "utf8"
vim.o.laststatus = 2
vim.o.backspace="indent,eol,start"
-- Show function name in status line using chelper.vim
-- set statusline=%<%f\ %h%m%r\ %1*%{CTagInStatusLine()}%*%=%-14.(%l,%c%V%)\ %P

-- Show function name in status line using taghelper.vim
vim.o.statusline = "%<%f %h%m%r %1*%{taghelper#curtag()}%*%=%-15.(%l,%c%V%) %P"

-- Add parent directory to search dirs when looking up functions/variables
vim.o.tags = "./tags,../tags,../../tags"

-- Recognize Globulation 2 SCons files as Python scripts
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"SConstruct", "SConscript"},
  command = "set filetype=python",
})

-- Vim plug setup
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Commented out because taghelper is better
-- Plug 'mgedmin/chelper.vim'

-- Show current function in statusbar
Plug('mgedmin/taghelper.vim')

-- Open File quickly like Ctrl-P in VSCode
Plug('ctrlpvim/ctrlp.vim')

-- File Outline :TagbarToggle
Plug('preservim/tagbar')

-- Show the chain of #ifdefs leading to this line.
Plug('wateret/ifdef-heaven.vim')

-- Code completion for NeoVim
-- https://www.barbarianmeetscoding.com/notes/neovim-plugins/
Plug('hrsh7th/nvim-cmp')

vim.call('plug#end')

vim.lsp.config['nixd'] = {
  cmd = {'nixd'},
  filetypes = { 'nix' },
  root_markers = { '.git' }
}
vim.lsp.enable('nixd')
vim.cmd('colo koehler')
