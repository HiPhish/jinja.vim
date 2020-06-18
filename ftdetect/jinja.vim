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

augroup filetypedetect
autocmd! BufRead,BufNewFile *.jinja,*jinja2,*.j2 call <SID>extension(expand('<afile>'))
augroup END

" Detect a normal or compound file extension (like 'foo.html.jinja')
function! s:extension(fname)
	" This will fail setting the file type of unknown file extension like
	" 'foo.nonsense.jinja', which is what we want.
	noautocmd exe 'file ' .. fnamemodify(a:fname, ':r')
	filetype detect

	" Now that we have detected the parent file type we can append Jinja to it
	if empty(&filetype)
		set filetype=jinja
	elseif &filetype !~? 'jinja'
		set filetype+=.jinja
	endif

	exe 'noautocmd file ' .. a:fname
endfunction
