" Taken from vimtex on github
" https://github.com/lervag/vimtex/blob/master/after/syntax/tex.vim
" " vimtex - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"
" Distributed according to the MIT license

" }}}1
" {{{1 Add syntax highlighting for \todo

syntax match texStatement '\\todo\w*' contains=texTodo
syntax match texTodo '\\todo\w*'

" }}}1
" {{{1 Add support for biblatex and csquotes packages (cite commands)

if get(g:, 'tex_fast', 'r') =~# 'r'

  for s:pattern in [
        \ 'bibentry',
        \ 'cite[pt]?\*?',
        \ 'citeal[tp]\*?',
        \ 'cite(num|text|url)',
        \ '[Cc]ite%(title|author|year(par)?|date)\*?',
        \ '[Pp]arencite\*?',
        \ 'foot%(full)?cite%(text)?',
        \ 'fullcite',
        \ '[Tt]extcite',
        \ '[Ss]martcite',
        \ 'supercite',
        \ '[Aa]utocite\*?',
        \ '[Ppf]?[Nn]otecite',
        \ '%(text|block)cquote\*?',
        \]
    execute 'syntax match texStatement'
          \ '/\v\\' . s:pattern . '\ze\s*%(\[|\{)/'
          \ 'nextgroup=texRefOption,texCite'
  endfor

  for s:pattern in [
        \ '[Cc]ites',
        \ '[Pp]arencites',
        \ 'footcite%(s|texts)',
        \ '[Tt]extcites',
        \ '[Ss]martcites',
        \ 'supercites',
        \ '[Aa]utocites',
        \ '[pPfFsStTaA]?[Vv]olcites?',
        \ 'cite%(field|list|name)',
        \]
    execute 'syntax match texStatement'
          \ '/\v\\' . s:pattern . '\ze\s*%(\[|\{)/'
          \ 'nextgroup=texRefOptions,texCites'
  endfor

  for s:pattern in [
        \ '%(foreign|hyphen)textcquote\*?',
        \ '%(foreign|hyphen)blockcquote',
        \ 'hybridblockcquote',
        \]
    execute 'syntax match texStatement'
          \ '/\v\\' . s:pattern . '\ze\s*%(\[|\{)/'
          \ 'nextgroup=texQuoteLang'
  endfor

  syntax region texRefOptions contained matchgroup=Delimiter
        \ start='\[' end=']'
        \ contains=@texRefGroup,texRefZone
        \ nextgroup=texRefOptions,texCites

  syntax region texCites contained matchgroup=Delimiter
        \ start='{' end='}'
        \ contains=@texRefGroup,texRefZone,texCites
        \ nextgroup=texRefOptions,texCites

  syntax region texQuoteLang contained matchgroup=Delimiter
        \ start='{' end='}'
        \ transparent
        \ contains=@texMatchGroup
        \ nextgroup=texRefOption,texCite

  highlight def link texRefOptions texRefOption
  highlight def link texCites texCite
endif
