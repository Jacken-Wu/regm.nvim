# regm.nvim

**我的代码写的很烂，可能有很多bug，请谨慎使用**

**此插件仅适用于 Neovim，在 Vim 中不起作用。因为我使用 nvim_win_open() 创建浮动窗口，而 Vim 不支持此功能。**

https://github.com/user-attachments/assets/4b20935a-e062-452f-85d3-872c8339495c

## 这个插件能做什么？

这个插件也许可以提升你在 Neovim 中使用寄存器时的体验。

当你通过这个插件复制或粘贴文本时，它会在屏幕上显示寄存器列表，并允许你选择要使用的寄存器。

## 安装

以 [vim-plug](https://github.com/junegunn/vim-plug) 为例：

```vim
call plug#begin()

" register enhancement
Plug 'Jacken-Wu/regm.nvim'

call plug#end()
```

## 使用

你可以通过下列映射来使用这个插件：

```vim
nnoremap <silent> <leader>yy :call regm#ShowClipboardRegisters('copy', 'yy')<CR>  " 复制行
nnoremap <silent> <leader>yw :call regm#ShowClipboardRegisters('copy', 'yw')<CR>  " 复制词
vnoremap <silent> <leader>y y:call regm#ShowClipboardRegisters('copy', 'y')<CR>  " 复制选择的内容
nnoremap <silent> <leader>p :call regm#ShowClipboardRegisters('paste', 'p')<CR>  " 粘贴到光标前
nnoremap <silent> <leader>P :call regm#ShowClipboardRegisters('paste', 'P')<CR>  " 粘贴到光标后
vnoremap <silent> <leader>p d:call regm#ShowClipboardRegisters('paste', 'P')<CR>  " 替换选择的内容
```

函数 `regm#ShowClipboardRegisters(mode, command)` 有两个参数：

- `mode`: 操作的模式，可以是 `'copy'` 或 `'paste'`
- `command`: 选择寄存器后执行的命令

当这个函数运行时，它会打开一个悬浮窗口，并显示所有非空的寄存器。你可以：

- 通过 `<C-j>/<C-k>/J/K` 来移动光标
- 通过 `<C-c>/<Esc>` 来关闭窗口
- 通过 `<CR>` 来选择当前寄存器
- 通过 `寄存器名` 来选择寄存器（比如通过按下 `a` 来选择 `a` 寄存器）

你可以通过更改 `g:regm_clipboard_registers` 的值来自定义要显示的寄存器。默认值是：

```vim
let g:regm_clipboard_registers = '"0123456789abcdefghijklmnopqrstuvwxyz-*+.:%#/='
```
