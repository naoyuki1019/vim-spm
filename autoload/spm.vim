scriptencoding utf-8
"/**
" * @file spm.vim
" * @author naoyuki onishi <naoyuki1019 at gmail.com>
" * @version 0.1
" */

if exists("g:loaded_spm")
  finish
endif
let g:loaded_spm = 1

let s:save_cpo = &cpo
set cpo&vim


if !exists('g:spm_repodir')
  let g:spm_repodir = expand('<sfile>:p:h').'/../repos'
endif

let g:spm_dict = {}

function! s:uri(url)
  let l:n = match(a:url, '://')
  let l:dir = a:url[l:n+3:]
  return substitute(l:dir, ':', '-', "g")
endfunction

function! s:fix_ds(path)
  let l:path = a:path
  let l:path = substitute(l:path, '\v\/{2,}', '/', 'g')
  if has("win32") || has("win95") || has("win64") || has("win16")
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
    if has("win32") || has("win95") || has("win64") || has("win16")
      let l:dir = l:dir . '\'
    else
      let l:dir = l:dir . '/'
    endif
  endif
  return l:dir
endfunction

function! spm#clone(url)

  let l:dir = g:spm_repodir.'/'.s:uri(a:url)
  let l:dir = s:fix_ds(l:dir)
  let l:dir = fnamemodify(l:dir, ':p')
  let l:dir = s:rm_tail_ds(l:dir)
  " call confirm('l:dir='.l:dir)
  let g:spm_dict[a:url] = {
        \'dir': l:dir,
        \'sts': 0,
        \'msg': ''
        \}

  ".gitディレクトリが存在しなければGitClone
  if !isdirectory(s:add_tail_ds(g:spm_dict[a:url]['dir']).'.git')
    let l:git_clone = s:git_clone(a:url, g:spm_dict[a:url]['dir'])
    if 0 != l:git_clone
      return
    endif
  endif

  "ランタイムパスに追加
  exec 'set runtimepath+='.g:spm_dict[a:url]['dir']
  let g:spm_dict[a:url]['sts'] = 0
  let g:spm_dict[a:url]['msg'] = 'completion'

endfunction

function! s:git_clone(url, dir)

  let l:escaped_url = shellescape(a:url)
  let l:escaped_dir = shellescape(s:rm_tail_ds(a:dir))
  let l:execute = '!git clone '.l:escaped_url.' '.l:escaped_dir

  " let l:conf = confirm('execute? ['.l:execute.']', "Yyes\nNno")
  " if 1 != l:conf
  "   let g:spm_dict[a:url]['sts'] = 2
  "   let g:spm_dict[a:url]['msg'] = 'canceled git-clone'
  "   return 2
  " endif

  try
    silent execute l:execute
  endtry

  if !isdirectory(s:add_tail_ds(a:dir).'.git')
    let g:spm_dict[a:url]['sts'] = 1
    let g:spm_dict[a:url]['msg'] = 'an error occurred git-clone'
    call confirm('an error occurred git-clone. plz check the url')
    return 1
  endif

  return 0

endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

