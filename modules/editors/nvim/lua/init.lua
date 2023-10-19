local o = vim.o
local g = vim.g

o.number = true
o.mouse = 'a'
o.ignorecase = true
o.smartcase = true
o.hlsearch = false
o.wrap = true
o.breakindent = true
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = false
o.termguicolors = true

g.mapleader = ' ';

vim.keymap.set({'n', 'x'}, 'cp', '"+y')
vim.keymap.set({'n', 'x'}, 'cv', '"+p')
vim.keymap.set({'n', 'x'}, 'x', '"_x')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')
vim.keymap.set('n', '<leader>op', ':NERDTree')

vim.cmd.colorscheme('onedark')
