# Simple Plugin Manager

### How to use

- :call spm#clone(url)

    'git clone {url} {uri}'

- :call spm#pull()

    'git pull' all repositories

- :call spm#pull(url)

    'git pull' partially matched url

### About delete function

This plugin does not have the function to delete the repository

### .vimrc

```vim

let s:spm_dir = '~/.vim/spm'

if filereadable(fnamemodify(s:spm_dir,':p').'autoload/spm.vim') "{{{

  execute 'set runtimepath+='.s:spm_dir

  "
  " plugin 1
  "
  call spm#clone('https://github.com/hoge/plugin1')

  "
  " plugin 2
  "
  call spm#clone('https://github.com/naoyuki1019/vim-quickfilesearch2')
  let g:qsf_lsfile = '.lsfile'
  noremap <Leader>fs :<C-u>QFSFileSearch2<CR>

  "
  " plugin 3
  "
  call spm#clone('https://github.com/hoge/plugin3')

  ....
  ...
  ..
  .

endif

....
...
..
.

filetype plugin indent on
syntax enable

```
