setlocal shiftwidth=4 tabstop=4 softtabstop=4

" turn on spell check
syntax spell toplevel
setlocal spell spelllang=en_us

" don't wrap text at 80 characters
setlocal textwidth=0
setlocal wrap

" spell check for extra long files.
syn sync maxlines=2000
syn sync minlines=1

" only one space after punctuation
set nojoinspaces

" automatically run "marked" on :w action
autocmd BufWritePost * silent! !marked % > %:r.html
