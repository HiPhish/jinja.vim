" Author: Alejandro "HiPhish" Sanchez
" License: The MIT License {{{
"   Copyright (c) 2016 Alejandro "HiPhish" Sanchez
"   
"   Permission is hereby granted, free of charge, to any person obtaining
"   a copy of this software and associated documentation files (the "Software"),
"   to deal in the Software without restriction, including without limitation
"   the rights to use, copy, modify, merge, publish, distribute, sublicense,
"   and/or sell copies of the Software, and to permit persons to whom the
"   Software is furnished to do so, subject to the following conditions:
"   
"   The above copyright notice and this permission notice shall be included
"   in all copies or substantial portions of the Software.
"   
"   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
"   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
"   OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
"   DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
"   OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

autocmd! BufRead,BufNewFile *.jinja,*jinja2,*.j2 call <SID>extension(expand('<afile>'))

" Detect a normal or compound file extension (like 'foo.html.jinja')
function! s:extension(fname)
	let l:previous_ft = &ft

	" Try to detect the file type without the Jinja extension first. This will
	" fail setting the file type of file extension like 'foo.xxxx.jinja',
	" which is what we want.
	call nvim_buf_set_name(0, fnamemodify(a:fname, ':r'))
	filetype detect
	call nvim_buf_set_name(0, a:fname)
	" Using ':file' has dissociated the buffer from its file, but executing
	" ':edit' fixes this
	noautocmd silent edit

	" If file type detection fails and there already was a file type it will
	" be unchanged; this can happen if we change the file name from something
	" like 'foo.html.jinja' to 'foo.xxxx.jinja'.  In that case we have to
	" manually reset the file type to the empty string.
	if !empty(l:previous_ft) && l:previous_ft == &filetype
		set filetype=
	endif

	" Now that we have detected the parent file type we can append Jinja to it
	if empty(&filetype)
		set filetype=jinja
	elseif &filetype !~? 'jinja'
		set filetype+=.jinja
	endif
endfunction
