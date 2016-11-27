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


" Try to detect Jinja code inside a buffer file, the function returns true if
" Jinja has been detected, false otherwise.
"
" parameter first:  First line to check for the presence of Jija code.
" parameter last:   Last line to check for the presence of Jija code.
"
" The parameters will get adjusted to account for files which are too small.
" This is because the function might get called by scripts that just assume a
" certain minimal length.
function! jinja#DetectJinja(first, last) abort
	" How many lines to count, range takes precedence over default values
	let l:first = min([a:first, line('$')])
	let l:last  = min([a:last, line('$')])

	" The pattern of a Jinja instruction: either an expression {{...}}, a
	" comment {#..#}, a statement {%...%}, or a line statement #..., or a line
	" comment
	let l:jinja_pattern = '\v\{\{.*\}\}|' . 
				\'\{\#.*\#\}|' .
				\'\{\%\-?\s*(end.+|extends|block|macro|set|if|for|include|trans)>|' .
				\'^\#\s*(extends|block|macro|set|if|for|include|trans)>|' .
				\'^\#\#.+'
	" Probe a number of lines for Jinja code, give up if none is found.
	for l:line in range(l:first, l:last)
		if getline(l:line) =~? l:jinja_pattern
			return l:line
		endif
	endfor
endfun


" Appends '.jinja' to the 'filetype' option if Jinja code has been detected in
" the buffer.
function! jinja#AdjustFiletype() abort
	if &filetype =~? 'jinja'
		return
	endif
	" I picked the first five lines as an arbitrary count, we can increase the
	" number if necessary.
	if jinja#DetectJinja(1,5)
		execute 'set filetype+=.jinja'
	endif
endfun


