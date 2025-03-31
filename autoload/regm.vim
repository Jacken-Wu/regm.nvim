function! regm#ShowClipboardRegisters(copy_or_paste, yp_command) abort
    " 定义需要显示的寄存器列表（包括系统剪贴板）
    if !exists('g:regm_clipboard_registers') || g:regm_clipboard_registers == ''
        let g:regm_clipboard_registers = '"0123456789abcdefghijklmnopqrstuvwxyz-*+.:%#/='
    endif
    let l:reg_list = split(g:regm_clipboard_registers, '\zs')

    " 窗口大小
    let editor_width = nvim_get_option('columns')
    let editor_height = nvim_get_option('lines')
    let win_width = editor_width * 3 / 4
    let win_height = editor_height * 3 / 4
    let win_col = editor_width / 8
    let win_row = editor_height / 8

    " 收集非空寄存器内容
    let l:content = []
    let s:reg_list_non_empty = []
    for reg in l:reg_list
        let value = getreg(reg, 1)
        if !empty(value)
            " 格式化显示：截断长文本并处理换行
            let display_value = substitute(value, '\n', '↵', 'g')
            let display_value = len(display_value) > win_width - 11 ? display_value[:win_width - 14].'...' : display_value
            call add(l:content, printf('%-2s│ %s', reg, display_value))
            call add(s:reg_list_non_empty, reg)
        endif
    endfor

    if empty(l:content)
        echo 'No clipboard content available'
        return
    endif

    " 创建浮动窗口
    let buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_option(buf, 'modifiable', v:true)
    call nvim_buf_set_lines(buf, 0, -1, v:true, l:content)
    call nvim_buf_set_option(buf, 'modifiable', v:false)
    
    " 窗口配置参数
    let opts = {
        \ 'relative': 'editor',
        \ 'width': win_width,
        \ 'height': win_height,
        \ 'col': win_col,
        \ 'row': win_row,
        \ 'anchor': 'NW',
        \ 'style': 'minimal',
        \ 'border': 'single'
        \ }

    let s:win = nvim_open_win(buf, v:true, opts)
    
    " 设置窗口样式
    call nvim_win_set_option(s:win, 'number', v:false)
    call nvim_win_set_option(s:win, 'cursorline', v:true)
    
    " --------------------------设置快捷键映射--------------------------
    " 退出
    call nvim_buf_set_keymap(buf, 'n', '<C-c>', '<cmd>q!<CR>', {'nowait': v:true, 'silent': v:true})
    call nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>q!<CR>', {'nowait': v:true, 'silent': v:true})
    " 移动光标
    function! Move(direction, times)
        let index = nvim_win_get_cursor(s:win)[0]
        for i in range(a:times)
            if a:direction == 'up'
                let index = index > 1 ? index - 1 : index
            else
                let index = index < len(s:reg_list_non_empty) ? index + 1 : index
            endif
        endfor
        call nvim_win_set_cursor(s:win, [index, 0])
    endfunction
    call nvim_buf_set_keymap(buf, 'n', '<C-j>', '<cmd>call Move("down", 1)<CR>', {'nowait': v:true, 'silent': v:true})
    call nvim_buf_set_keymap(buf, 'n', '<C-k>', '<cmd>call Move("up", 1)<CR>', {'nowait': v:true, 'silent': v:true})
    call nvim_buf_set_keymap(buf, 'n', 'J', '<cmd>call Move("down", 5)<CR>', {'nowait': v:true, 'silent': v:true})
    call nvim_buf_set_keymap(buf, 'n', 'K', '<cmd>call Move("up", 5)<CR>', {'nowait': v:true, 'silent': v:true})
    call nvim_buf_set_keymap(buf, 'n', '<C-h>', '<Nop>', {'nowait': v:true, 'silent': v:true})
    call nvim_buf_set_keymap(buf, 'n', '<C-l>', '<Nop>', {'nowait': v:true, 'silent': v:true})
    call nvim_buf_set_keymap(buf, 'n', 'H', '<Nop>', {'nowait': v:true, 'silent': v:true})
    call nvim_buf_set_keymap(buf, 'n', 'L', '<Nop>', {'nowait': v:true, 'silent': v:true})
    " 复制/粘贴
    if a:copy_or_paste == 'copy'
        function! Copy(reg, y_command)
            call nvim_win_close(s:win, v:true)
            " 对y单独处理，因为y用于复制选中内容，是Visual模式下的操作
            if a:y_command == 'y'
                exec ':let @'.a:reg.' = @"'
            else
                exec 'normal! "'.a:reg.a:y_command
            endif
        endfunction
        function! CopySelected(y_command)
            let index = nvim_win_get_cursor(s:win)[0] - 1
            let reg = s:reg_list_non_empty[index]
            call Copy(reg, a:y_command)
        endfunction
        call nvim_buf_set_keymap(buf, 'n', '<CR>', '<cmd>call CopySelected("'.a:yp_command.'")<CR>', {'nowait': v:true, 'silent': v:true})
        for reg in l:reg_list
            call nvim_buf_set_keymap(buf, 'n', reg, '<cmd>call Copy("'.reg.'", "'.a:yp_command.'")<CR>', {'nowait': v:true, 'silent': v:true})
        endfor
    elseif a:copy_or_paste == 'paste'
        function! Paste(reg, p_command)
            call nvim_win_close(s:win, v:true)
            exec 'normal! "'.a:reg.a:p_command
        endfunction
        function! PasteSelected(p_command)
            let index = nvim_win_get_cursor(s:win)[0] - 1
            let reg = s:reg_list_non_empty[index]
            call Paste(reg, a:p_command)
        endfunction
        call nvim_buf_set_keymap(buf, 'n', '<CR>', '<cmd>call PasteSelected("'.a:yp_command.'")<CR>', {'nowait': v:true, 'silent': v:true})
        for reg in l:reg_list
            call nvim_buf_set_keymap(buf, 'n', reg, '<cmd>call Paste("'.reg.'", "'.a:yp_command.'")<CR>', {'nowait': v:true, 'silent': v:true})
        endfor
    endif
endfunction
