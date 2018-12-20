" for some reason it seems that the fortran end of line is set to 133 characters
" so i need to overwrite this.
set textwidth=80
set colorcolumn=+1 

" these are bizarre variables to specify fotran formatting
" allow free source not character based
let fortran_free_source=1
" indent between do & enddo
let fortran_do_enddo=1
