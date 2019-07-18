" turn on spell check for LaTeX files
syntax spell toplevel
setlocal spell spelllang=en_us
" don't wrap at 80 characters. trying to wrap at sentences.
setlocal textwidth=0
setlocal wrap

" spell check for extra long files.
" This is longer than the longest file in my Master's thesis.
syn sync maxlines=2000
syn sync minlines=1

" only one space after punctuation
set nojoinspaces
