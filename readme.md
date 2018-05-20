# Simple Plugin Manager

### How to use

- :call spm#clone(url)

    'git clone {url} {uri}'

- :call spm#pull(url)

    'git pull' partially matched url

- :call spm#clone()

    'git clone' all repositories

- :call spm#pull()

    'git pull' all repositories

### About delete function

This plugin does not have the function to delete the repository

### .vimrc

```vim
let s:spm_dir = '~/.vim/spm'
if filereadable(fnamemodify(s:spm_dir,':p').'autoload/spm.vim') "{{{
  execute 'set runtimepath+='.s:spm_dir

  "---------------------------------------------------------
  " plugin 1
  call spm#clone('https://github.com/yegappan/mru')
  " plugin 1 settings
  let MRU_File = fnamemodify('~/.vim_mru', ':p')
  nnoremap zm :<C-u>MRU<CR>

  " plugin 2
  call spm#clone('https://github.com/hoge/plugin2')
  " plugin 2 settings
  let ......

  " plugin 3
  call spm#clone('https://github.com/hoge/plugin3')
  " plugin 3 settings
  let ......

  " plugin 4
  call spm#clone('https://sample:com:8080/hoge/plugin4')
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
