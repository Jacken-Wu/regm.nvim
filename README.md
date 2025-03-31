# regm.nvim

**My code is terrible and may have some bugs, please use it with caution.**

**This plugin is only for Neovim, and it doesn't work in Vim. Because I use nvim_open_win() to create the floating window, which is not supported in Vim.**

https://github.com/user-attachments/assets/4b20935a-e062-452f-85d3-872c8339495c

[中文请点我](./doc/zh_CN.md)

## What can this plugin do?

This plugin may enhance your experience of using registers in Neovim.

When you copy or paste something using this plugin, it will show a list of registers, and you can choose which register to use.

## Install

Take [vim-plug](https://github.com/junegunn/vim-plug) as an example:

```vim
call plug#begin()

" register enhancement
Plug 'Jacken-Wu/regm.nvim'

call plug#end()
```

## Usage

You can use the following mappings to use this plugin:

```vim
nnoremap <silent> <leader>yy :call regm#ShowClipboardRegisters('copy', 'yy')<CR>  " copy a line
nnoremap <silent> <leader>yw :call regm#ShowClipboardRegisters('copy', 'yw')<CR>  " copy a word
vnoremap <silent> <leader>y y:call regm#ShowClipboardRegisters('copy', 'y')<CR>  " copy the selection
nnoremap <silent> <leader>p :call regm#ShowClipboardRegisters('paste', 'p')<CR>  " paste after the cursor
nnoremap <silent> <leader>P :call regm#ShowClipboardRegisters('paste', 'P')<CR>  " paste before the cursor
vnoremap <silent> <leader>p d:call regm#ShowClipboardRegisters('paste', 'P')<CR>  " replace the selection
```

The function `regm#ShowClipboardRegisters(mode, command)` has two arguments:

- `mode`: the mode of the operation, can be `'copy'` or `'paste'`
- `command`: the command to execute after the register is selected

When this function runs, it will open a floating window that lists all non-empty registers. You can:

- use `<C-j>/<C-k>/J/K` to move the cursor
- use `<C-c>/<Esc>` to close the window
- use `<CR>` to select the current register
- use `register name` to select a register by name (for example, you can type `a` to select the `a` register)

You can change the value of `g:regm_clipboard_registers` to customize which registers to show. The default value is:

```vim
let g:regm_clipboard_registers = '"0123456789abcdefghijklmnopqrstuvwxyz-*+.:%#/='
```
