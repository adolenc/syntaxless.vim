if exists('g:loaded_syntaxless')
  finish
endif


call syntaxless#Whitelist('global', ['String', 'Comment', 'Todo'])

augroup syntaxless
  autocmd!
  autocmd ColorScheme,FileType,BufNewFile,BufRead * call syntaxless#RemoveSyntax()
augroup END

command! -nargs=0 SyntaxlessDisableForSession :call syntaxless#Toggle(0)
command! -nargs=0 SyntaxlessEnableForSession :call syntaxless#Toggle(1)

let g:loaded_syntaxless = 1
