.. default-role:: code

######################
 Working on jinja.vim 
######################

This document is intended for those who  want to work on jinja.vim, improve it,
fix bugs, or add new features.


Overview of the plugin design
#############################

Jinja.vim is  intentionally a very  minimal plugin.  It provides the  basics of
file type support of Jinja files:  syntax highlighting and file type detection.
This does not  mean that we cannot add  more features, but the goal  is to make
Jinja a first-class citizen to Vim, not to provide a Jinja IDE.


About Jinja
===========

Jinja is  a template engine:  you write  your files in  a format of  you choice
(e.g. HTML) with pieces of Jinja syntax added in. Then you invoke the Jinja API
from within  your Python program. Here  is what a  piece of Jinja code  in HTML
looks like:

.. code-block:: jinja

   {% extends "layout.html" %}
   {% block body %}
     <ul>
     {% for user in users %}
       <li><a href="{{ user.url }}">{{ user.username }}</a></li>
     {% endfor %}
     </ul>
   {% endblock %}

Despite HTML  being the  format most  often used,  Jinja can  be used  with any
language,  such  as XML  or  TeX.  Therefore it  is  important  to *not*  limit
jinja.vim to HTML only.


Components of jinja.vim
#######################

This is an overview of the problems  jinja.vim solves and the files relevant to
the task.

Syntax highlighting
   The code is entirely contained  in `syntax/jinja.vim`, it's exactly what you
   would expect.

File type detection
   Detection of pure Jinja files  is handled in `ftdetect/jinja.vim`. Detecting
   the presence of Jinja code in a file from different file type (e.g. HTML) is
   handled by `autoload/jinja.vim` and the function `jinja#DetectJinja`.

File type adjustment
   The  file  type  can  be  automatically adjusted  by  calling  the  function
   `jinja#AdjustFiletype` from the file `autoload/jinja.vim`. It will check the
   first few lines  for the presence of Jinja and  if necessary attach `.jinja`
   to the file type.

   We do not automatically adjust the file type. Instead the user should set up
   the automatic calling of the function if they want to.


Testing
#######

The testing framework  is vader.vim_; execute `:Vader test/*.vader`  to run all
tests. These are are test suites:

jinja-detect
   Test for the correct detection of Jinja code and file type adjustment.

ftdetect
   Test for the correct filetype setting when opening a `*.jinja` file

syntax
   Test the syntax elements of a sample Jinja file.


.. _vader.vim: https://github.com/junegunn/vader.vim
