" meetmaker.vim - Determine build environment heuristically
" Maintainer: Frank Plowman <https://frankplowman.com>
" Version:    0.1

" @TODO: automatically set b:dispatch also

if exists("g:loaded_meetmaker")
  finish
endif
let g:loaded_meetmaker = 1

function! s:DetectMakeprg() abort
  if filereadable('Makefile')
    return 'make'
  elseif filereadable('CMakeLists.txt')
    " @TODO: also determine build dir
    return 'cmake --build build'
  elseif filereadable('rakefile') || filereadable('Rakefile')
    return 'rake'
  endif
  return ''
endfunction

function! s:Init() abort
  if &l:buftype =~# '^(help\|terminal\|prompt\|popup)$'
    return
  endif

  let detected_makeprg = s:DetectMakeprg()
  let &makeprg = detected_makeprg
endfunction

augroup MeetMaker
  autocmd BufNewFile,BufReadPost,BufFilePost * nested
      \ if get(b:, 'meetmaker_automatic', get(g:, 'sleuth_automatic', 1))
      \ | silent call s:Init() | endif
augroup END

command! MeetMaker exe s:Init()
