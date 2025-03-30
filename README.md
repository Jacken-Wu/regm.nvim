# regm.nvim

**My code is terrible and may have some bugs, please use it with caution.**

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
nnoremap <silent> <leader>p :call regm#ShowClipboardRegisters('paste', 'p')<CR>  " paste
nnoremap <silent> <leader>P :call regm#ShowClipboardRegisters('paste', 'P')<CR>  " Paste
nnoremap <silent> <leader>yy :call regm#ShowClipboardRegisters('copy', 'yy')<CR>  " copy a line
nnoremap <silent> <leader>yw :call regm#ShowClipboardRegisters('copy', 'yw')<CR>  " copy a word
vnoremap <silent> <leader>y y:call regm#ShowClipboardRegisters('copy', 'y')<CR>  " copy a visual selection
```

The function `regm#ShowClipboardRegisters(mode, command)` has two arguments:

- `mode`: the mode of the operation, can be `'copy'` or `'paste'`
- `command`: the command to execute after the register is selected

When this function runs, it will open a floating window that lists all non-empty registers. You can:

- use `<C-j>/<C-k>/J/K` to move the cursor
- use `<C-c>/<Esc>` to close the window
- use `<CR>` to select the current register
- use `register name` to select a register by name (for example, you can type `a` to select the `a` register)
