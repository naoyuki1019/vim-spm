scriptencoding utf-8
"/**
" * @file spm.vim
" * @author naoyuki onishi <naoyuki1019 at gmail.com>
" * @version 1.0
" */

if exists("g:loaded_spm")
  finish
endif
let g:loaded_spm = 1

let s:save_cpo = &cpo
set cpo&vim

if has("win32") || has("win95") || has("win64") || has("win16")
  let s:is_win = 1
  let s:ds = '\'
else
  let s:is_win = 0
  let s:ds = '/'
endif

if !exists('g:spm_repodir')
  let g:spm_repodir = fnamemodify(expand('<sfile>:p:h').'/../repos', ':p')
endif

let g:spm_dict = {}
let s:clone_onload_list = []
let s:clone_list = []

augroup augroup#SPM
  autocmd!
  autocmd VimEnter * call s:show_clone_info(s:clone_onload_list)
augroup END

function s:show_clone_info(list)
  if 0 < len(a:list)
    let l:msg = []
    call add(l:msg, '"--------------------------------------------------')
    call add(l:msg, '" Simple Plugin Manager')
    call add(l:msg, '" local: '.g:spm_repodir )
    call add(l:msg, '"--------------------------------------------------')
    for l:url in a:list
      call add(l:msg, '       |')
      call add(l:msg, 'remote | '.l:url)
      call add(l:msg, 'message| '.g:spm_dict[l:url]['msg'])
    endfor
    echo join(l:msg, "\n")
  endif
endfunction

function! s:uri(url)
  let l:n = match(a:url, '://')
  let l:dir = a:url[l:n+3:]
  return substitute(l:dir, ':', '-', "g")
endfunction

function! s:fix_ds(path)
  let l:path = a:path
  let l:path = substitute(l:path, '\v\/{2,}', '/', 'g')
  if 1 == s:is_win
    let l:path = substitute(l:path, '\/', '\\', 'g')
  endif
  return l:path
endfunction

function! s:rm_tail_ds(dir)
  let l:dir = a:dir
  let l:len = strlen(a:dir)
  let l:tail = l:dir[l:len-1]
  if '/' == l:tail || '\' == l:tail
    let l:dir = l:dir[0:l:len-2]
  endif
  return l:dir
endfunction

function! s:add_tail_ds(dir)
  let l:dir = a:dir
  let l:len = strlen(a:dir)
  let l:tail = l:dir[l:len-1]
  if '/' != l:tail && '\' != l:tail
    let l:dir .= s:ds
  endif
  return l:dir
endfunction

function! spm#pull(...)

  if 1 > a:0
    let l:s = '.*'
  else
    let l:s = join(a:000, ' ')
    let l:s = substitute(l:s, '\v([^\.])\*', '\1.\*', 'g')
    let l:s = substitute(l:s, '\v([^\\])\.([^\*])', '\\.', 'g')
    let l:s = substitute(l:s, '\v\s{1,}', '.*', 'g')
  endif

  let l:unmatchall = 1

  for [l:url, l:dict] in items(g:spm_dict)

    let l:n = match(l:url, l:s)
    if -1 < l:n
      let l:unmatchall = 0

      let l:dir = fnamemodify(l:dict['dir'], ':p')
      if 1 == s:is_win
        let l:drive = l:dir[:stridx(l:dir, ':')]
        let l:execute = '!'.l:drive.' & cd '.shellescape(l:dir).' & git pull'
      else
        let l:execute = '!cd '.shellescape(l:dir).'; git pull'
      endif

      let l:conf = confirm('execute? ['.l:execute.']', "Yyes\nNno")
      if 1 != l:conf
        continue
      endif

      execute l:execute

    endif
  endfor

  if 1 == l:unmatchall
    call confirm('there was no match url')
  endif

endfunction

function! spm#clone(...)

  if 1 > a:0
    let s:clone_list = []
    for [l:url, l:dict] in items(g:spm_dict)
      call spm#clone(l:url)
    endfor
    call s:show_clone_info(s:clone_list)
    return
  endif

  let l:url = a:000[0]
  " call s:confirm(l:url)

  let l:dir = g:spm_repodir.'/'.s:uri(l:url)
  let l:dir = s:fix_ds(l:dir)
  let l:dir = fnamemodify(l:dir, ':p')
  let l:dir = s:rm_tail_ds(l:dir)
  let g:spm_dict[l:url] = {
        \'dir': l:dir,
        \'sts': 0,
        \'msg': ''
        \}

  call add(s:clone_list, l:url)

  if !isdirectory(s:add_tail_ds(g:spm_dict[l:url]['dir']).'.git')
    call add(s:clone_onload_list, l:url)
    let l:git_clone = s:git_clone(l:url, g:spm_dict[l:url]['dir'])
    if 0 != l:git_clone
      return
    endif
  else
    let g:spm_dict[l:url]['sts'] = 0
    let g:spm_dict[l:url]['msg'] = 'installed'
  endif

  exec 'set runtimepath+='.g:spm_dict[l:url]['dir']

endfunction

function! s:git_clone(url, dir)

  let l:escaped_url = shellescape(a:url)
  let l:escaped_dir = shellescape(s:rm_tail_ds(a:dir))
  let l:execute = '!git clone '.l:escaped_url.' '.l:escaped_dir

  if ! (has('gui_running'))
    let l:conf = confirm('execute? ['.l:execute.']', "Yyes\nNno")
    if 1 != l:conf
      let g:spm_dict[a:url]['sts'] = 2
      let g:spm_dict[a:url]['msg'] = 'clone: canceled'
      return 2
    endif
  endif

  execute l:execute

  if !isdirectory(s:add_tail_ds(a:dir).'.git')
    let g:spm_dict[a:url]['sts'] = 1
    let g:spm_dict[a:url]['msg'] = 'clone: an error occurred. plz check url'
    call s:confirm('an error occurred. plz check url')
    return 1
  endif

  let g:spm_dict[a:url]['sts'] = 0
  let g:spm_dict[a:url]['msg'] = 'clone: success'

  return 0

endfunction

function! s:confirm(msg)
  if has('osx') && has('gui_running')
    echo (a:msg)
  else
    call confirm(a:msg)
  endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

