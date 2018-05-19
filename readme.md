# simple plugin manager

your .vimrc


```vim

let s:spm_dir = '~/.vim/spm'

if isdirectory(fnamemodify(s:spm_dir, ':p')) "{{{

  execute 'set runtimepath^=' . s:spm_dir

  "plugins
  call spm#clone('https://github.com/xxxx/yyyyy')
  call spm#clone('https://github.com/xxxx/yyyyy')
  call spm#clone('https://github.com/xxxx/yyyyy')
  call spm#clone('https://github.com/xxxx/yyyyy')
  call spm#clone('https://github.com/xxxx/yyyyy')
  call spm#clone('https://github.com/xxxx/yyyyy')

endif

```
