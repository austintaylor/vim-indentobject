" File: indentobject.vim
" Author: Austin Taylor
" Version: 0.1
" License: Distributable under the same terms as Vim itself (see :help license)
" Description: 
"   This text object supports manipulating blocks based on their level of
"   indentation.
"
"   It is based on scripts found on vim.wikia.com
"   (http://vim.wikia.com/wiki/Indent_text_object)


onoremap <silent>ai :<C-u>call IndentTextObject(0)<CR>
onoremap <silent>ii :<C-u>call IndentTextObject(1)<CR>
vnoremap <silent>ai :<C-u>call IndentTextObject(0)<CR><Esc>gv
vnoremap <silent>ii :<C-u>call IndentTextObject(1)<CR><Esc>gv

function! IndentTextObject(inner)
  if &filetype == 'haml' || &filetype == 'sass' || &filetype == 'python'
    let meaningful_indentation = 1
  else
    let meaningful_indentation = 0
  endif
  let curline = line(".")
  let lastline = line("$")
  let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline(".") =~ "^\\s*$"
    return
  endif
  let p = line(".") - 1
  let nextblank = getline(p) =~ "^\\s*$"
  while p > 0 && (nextblank || indent(p) >= i )
    -
    let p = line(".") - 1
    let nextblank = getline(p) =~ "^\\s*$"
  endwhile
  if (!a:inner)
    -
  endif
  normal! 0V
  call cursor(curline, 0)
  let p = line(".") + 1
  let nextblank = getline(p) =~ "^\\s*$"
  while p <= lastline && (nextblank || indent(p) >= i )
    +
    let p = line(".") + 1
    let nextblank = getline(p) =~ "^\\s*$"
  endwhile
  if (!a:inner && !meaningful_indentation)
    +
  endif
  normal! $
endfunction
