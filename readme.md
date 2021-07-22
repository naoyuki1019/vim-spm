# Simple Plugin Manager

## functions

|function|action|
|:--|:--|
|call spm#clone(url)|'git clone' {url} {uri}|
|call spm#pull(url)|'git pull' partially matched url|
|call spm#clone()|'git clone' all repositories|
|call spm#pull()|'git pull' all repositories|
|call spm#status()|show status|

### About delete function

This plugin does not have the function to delete repositories

## Setting

### add .vimrc

```vim
let g:spm_repodir = '~/.vim/repos'

let s:spm_dir = '~/.vim/spm'
if filereadable(fnamemodify(s:spm_dir,':p').'autoload/spm.vim') "{{{
  execute 'set runtimepath+='.s:spm_dir

  "---------------------------------------------------------
  " plugin 1
  call spm#clone('https://github.com/Shougo/unite.vim')
  " plugin 1 settings
  let g:unite_enable_start_insert = 0

  " plugin 2
  call spm#clone('https://github.com/Shougo/neomru.vim')
  " plugin 2 settings
  let g:unite_source_file_mru_limit = 1000

  " plugin 3
  call spm#clone('https://github.com/thinca/vim-qfreplace')
  " plugin 3 settings
  let ......

  " plugin 4
  call spm#clone('https://github.com/tacroe/unite-mark')
  " plugin 4 settings
  let ......


  ....
  ...
  ..
  .
  "---------------------------------------------------------

endif

....
...
..
.

filetype plugin indent on
syntax enable

```

