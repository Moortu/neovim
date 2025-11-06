if vim.loader and vim.loader.enable then vim.loader.enable() end
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require('config.options')
require('config.keymaps')
require('config.lazy')
require('current-theme')
