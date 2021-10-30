if exists('g:loaded_syntaxless')
  finish
endif


if !exists('g:syntaxless_whitelisted_syntax_groups')
  let g:syntaxless_whitelisted_syntax_groups = {}
  let g:syntaxless_whitelisted_syntax_groups.global = ['String', 'Comment', 'Todo']
endif

augroup syntaxless
  autocmd!
  autocmd ColorScheme,FileType,BufNewFile,BufRead * call syntaxless#RemoveSyntax()
augroup END


let g:loaded_syntaxless = 1
