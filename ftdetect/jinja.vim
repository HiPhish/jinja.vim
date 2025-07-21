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


" How it works: Jinja files may have a compound file name like
" 'foo.html.jinja' or 'foo.tex.jinja'.  We trim off the '.jinja' (or '.jinja2'
" or '.j2') part of the file name and try detecting the file type type.  If
" one is found we append '.jinja' to the file type.  Otherwise we use just
" `jinja` for the file type.
"
" There are separate implementations for Vim and Neovim because I could not
" make one solution work for both.


autocmd! BufRead,BufNewFile *.jinja,*.jinja2,*.j2 if has('nvim') | call <SID>ft_nvim(expand('<afile>')) | else | call <SID>ft_vim(expand('<afile>')) | endif

" Detect a normal or compound file extension (like 'foo.html.jinja')
function! s:ft_vim(fname)
	let l:previous_ft = &ft

	" Try to detect the file type without the Jinja extension first. This will
	" fail setting the file type of file extension like 'foo.xxxx.jinja',
	" which is what we want.
	silent execute 'file' fnamemodify(fnameescape(a:fname), ':r')
	filetype detect
	silent execute 'file' fnameescape(a:fname)
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

" Detect compound file type using Neovim's Lua API
function! s:ft_nvim(fname) abort
	let l:clipped_fname = fnamemodify(fnameescape(a:fname), ':r')
	execute 'file' l:clipped_fname
	let l:secondary_ft = luaeval('vim.filetype.match(_A)', {'buf': 0})
	if empty(l:secondary_ft)
		set filetype=jinja
	else
		let &filetype = printf('%s.jinja', l:secondary_ft)
	endif
	" Using ':file' has dissociated the buffer from its file, but executing
	" ':edit' fixes this
	execute 'file' a:fname
	noautocmd silent edit
endfunction
