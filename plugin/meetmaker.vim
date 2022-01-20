" meetmaker.vim - Determine build environment heuristically
" Maintainer: Frank Plowman <https://frankplowman.com>
" Version:    0.1

" @TODO: automatically set b:dispatch also

if exists("g:loaded_meetmaker")
  finish
endif
let g:loaded_meetmaker = 1

function! s:MakeMakeprg() abort
  return 'make'
endfunction

function! s:CMakeMakeprg() abort
  return 'cmake --build build'
endfunction

function! s:RakeMakeprg() abort
  return 'rake'
endfunction

function! s:GradleMakeprg() abort
  return './gradlew build'
endfunction

function! s:AntMakeprg() abort
  return 'ant compile jar'
endfunction

function! s:MavenMakeprg() abort
  return 'mvn package'
endfunction

" @TODO: can bazel set default targets?
function! s:BazelMakeprg() abort
  return 'bazel build'
endfunction

function! s:DetectMakeprg() abort
  if filereadable('Makefile')
    return s:MakeMakeprg()
  elseif filereadable('CMakeLists.txt')
    return s:CMakeMakeprg()
  elseif filereadable('rakefile') || filereadable('Rakefile')
    return s:RakeMakeprg()
  elseif filereadable('settings.gradle')
    return s:GradleMakeprg()
  elseif filereadable('build.xml')
    return s:AntMakeprg()
  elseif filereadable('pom.xml')
    return s:MavenMakeprg()
  elseif filereadable('WORKSPACE')
    return s:BazelMakeprg()
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
  autocmd DirChanged,VimEnter * nested
      \ if get(b:, 'meetmaker_automatic', get(g:, 'meetmaker_automatic', 1))
      \ | silent call s:Init() | endif
augroup END

command! MeetMaker exe s:Init()
