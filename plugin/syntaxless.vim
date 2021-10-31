if exists('g:loaded_syntaxless')
  finish
endif


call syntaxless#Whitelist('global', ['String', 'Comment', 'Todo'])

augroup syntaxless
  autocmd!
  autocmd ColorScheme,FileType,BufNewFile,BufRead * call syntaxless#RemoveSyntax()
augroup END


let g:loaded_syntaxless = 1
