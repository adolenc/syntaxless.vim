if exists('g:loaded_syntaxless')
  finish
endif


call syntaxless#Whitelist('global', ['String', 'Comment', 'Todo'])

augroup syntaxless
  autocmd!
  autocmd FileType,BufNewFile,BufRead * call syntaxless#RemoveSyntax(0)
  autocmd ColorScheme * call syntaxless#RemoveSyntax(1)
augroup END

command! -nargs=0 SyntaxlessDisableForSession :call syntaxless#SetEnabled(0)
command! -nargs=0 SyntaxlessEnableForSession :call syntaxless#SetEnabled(1)

let g:loaded_syntaxless = 1
