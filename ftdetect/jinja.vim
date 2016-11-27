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




" This is flawed: if the file name is 'foo.jinja' it will work fine, but if
" the file name is 'foo.html.jinja' we would want the file type to be
" 'html.jinja' instead of just 'jinja'. However, we cannot simply take
" everything after the first dot as the file type because something like
" `main.macros.html.jinja` would get the wrong file type as well.
autocmd! BufRead,BufNewFile *.jinja  call <SID>DetectFileExtension(expand('<afile>'))

" Detect a normal or compound file extension (like 'foo.html.jinja')
function! s:DetectFileExtension(fname)
	" Clear the file because if the next command fails to set it the old file
	" type will persist.
	" Bug: The below well cause 'did_filetype()' to return true, which will
	" prevent the next command from setting the file type at all. there needs
	" to be a way of supressing the event.
	" noautocmd set filetype=

	" This will fail setting the file type of unknown file extension like
	" 'foo.nonsense.jinja', which is what we want.
	execute 'doautocmd BufReadPost '.fnamemodify(a:fname, ':r')

	if empty(&filetype)
		set filetype=jinja
		" execute 'setfiletype jinja'
	elseif &filetype =~? 'jinja'
		return
	else
		set filetype+=.jinja
	endif
endfunction
