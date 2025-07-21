" HTML is a special case because Vim tries to be clever and attempts to detect
" Django.
autocmd! BufRead,BufNewFile *.html  set ft=html | call jinja#AdjustFiletype()
