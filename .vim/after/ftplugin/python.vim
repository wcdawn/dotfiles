setlocal expandtab
setlocal shiftwidth=4 tabstop=4 softtabstop=4
set textwidth=90
set colorcolumn=+1

" use the built-in formatter gq to apply the black formatter
" gq applies over a motion
" to apply over the whole document, gggqG
set formatprg=black\ -q\ 2>/dev/null\ --stdin-filename\ %\ -

" use autocmd to apply black formatting on each write
function! PythonFormat()
    let w:v = winsaveview()
    silent normal gggqG
    call winrestview(w:v)
endfunction
augroup Python
    autocmd!
    autocmd BufWritePre <buffer> call PythonFormat()
augroup END

" use ctrl+k to apply formatting to whole file
map <C-K> :call PythonFormat()<CR>
imap <C-K> :call PythonFormat()<CR>
