vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pp", "<CMD>:Neotree toggle<CR>")

vim.cmd([[
function! FocusEditorPane() abort
    let l:current_win = win_getid()
    for l:win in range(1, winnr('$'))
        if l:win != l:current_win && getwinvar(l:win, '&filetype') !=# 'neo-tree'
            execute l:win . 'wincmd w'
            return
        endif
    endfor
endfunction
]])

vim.api.nvim_set_keymap('n', '<leader>e', ':call FocusEditorPane()<CR>', { noremap = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
