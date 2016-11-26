.. default-role:: code

Jinja syntax and file type detection for Vim
############################################

This plugin adds support  for the Jinja_ template engine to  Vim the Right Way™
by making  use of Vim's dotted  filetype syntax. This makes  the plugin smaller
and simpler to maintain, while at the  same time being more flexible by letting
Vim combine support for any host language (such as HTML) rather than pulling it
in through some hacky means.

There are a number  of Jinja plugins out there, including  an official one, but
they all force the file type to `jinja`  and then pull in the HTML settings. By
making use of the dotted file type syntax  we are not limited to HTML alone, we
can support  any other host file  type as well at  no extra cost. To  quote the
Jinja documentation:

   A Jinja  template is simply a  text file. Jinja can  generate any text-based
   format (HTML, XML, CSV, LaTeX, etc.).  A Jinja template doesn’t need to have
   a specific extension: `.html`, `.xml`, or any other extension is just fine.

.. _Jinja: http://jinja.pocoo.org/

Jinja.vim even  goes the  extra mile  and recognises file  names with  two file
types like `foo.html.jinja`  correctly as `html.jinja`. At the same  time it is
clever  enough to  know that  `foo.deprecated.jinja` is  of type  `jinja` alone
since `deprecated` is not a file type Vim knows about (unless you have a plugin
that would support  such a type of  course). This works recursively,  so if the
first file type could be a compound as well Vim will take care of it.


Installation
============

Use your preferred  method of installing Vim plugins,  manually or  via package
manager. There is nothing out of the ordinary here.


Configuration
=============

Since this is just a  syntax and filetype-detection plugin  there is nothing to
configure,  once  a  file  has  been  identified  as a  Jinja file  it will  be
highlighted  appropriately.  Any  file  with  the  extension  `.jinja`  will be
recognised as a Jinja file.

On the other hand,  if you want to use  Jinja highlighting in  other file types
like HTML you will  have to set it up appropriately.  For HTML support  add the
following line  to your `ftdetect/html.vim` file  inside the `~/.vim/` (Vim) or
`$XDG_CONFIG_HOME/nvim/` (Neovim) directory:

.. code-block:: vim

   autocmd! BufRead,BufNewFile *.html  call jinja#AdjustFiletype()

The function `AdjustFiletype` is explained below.


The `AdjustFiletype` funtion
----------------------------

`AdjustFiletype` is  a function provided by  the plugin as a  convenient way of
detecting the presence of Jinja code in  a buffer and changing the file type if
necessary by appending `.jinja` to it.


Bugs and Caveats
================

Even though the dotted file type notation  is the Right Way not all Vim plugins
are respecting  it. If that is  the case please  bring the issue to  the plugin
authors' attention; fixing  the issue once in that plugin  will forever benefit
everyone while applying a  hack to my plugin is just  shoving the problem under
the rug for the time being.

Jinja.vim will recognise the file  `foo.html.jinja` as of `html.jinja` type and
`foo.deprecated.jinja`  or `foo.jinja`  as just  `jinja`, but  if you  were the
change the file  name from the former to  one of the latter the  plugin will be
unable to pick up  that change. This only happens when the  target file type is
plain `jinja`. Changing `foo.html.jinja` to  `foo.xml.jinja` will work fine. To
my knowledge there is no way of fixing this without changing Vim.


License
#######

Jinja.vim is licensed  under the MIT license, except for  files where otherwise
noted. The syntax file has been adapted from the official Jinja syntax file for
Vim, with all  the superfluous content stripped away. The  original was written
by Armin Ronacher.

https://github.com/pallets/jinja

The MIT License (MIT)
=====================

Copyright (c) 2016 Alejandro "HiPhish" Sanchez

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and  associated documentation files (the "Software"),  to deal in
the Software  without restriction,  including without  limitation the rights to
use, copy, modify,  merge, publish,  distribute, sublicense, and/or sell copies
of the Software,  and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and  this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE  IS PROVIDED  "AS IS",  WITHOUT WARRANTY  OF ANY KIND,  EXPRESS OR
IMPLIED,  INCLUDING  BUT  NOT  LIMITED  TO THE  WARRANTIES OF  MERCHANTABILITY,
FITNESS FOR  A PARTICULAR  PURPOSE AND NONINFRINGEMENT.  IN NO EVENT  SHALL THE
AUTHORS  OR  COPYRIGHT  HOLDERS  BE LIABLE  FOR ANY  CLAIM,  DAMAGES  OR  OTHER
LIABILITY,  WHETHER IN AN ACTION OF CONTRACT,  TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH  THE SOFTWARE OR THE USE  OR OTHER DEALINGS IN THE
SOFTWARE.
