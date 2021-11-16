let s:syntaxless_enabled = 1
let s:already_cleaned_up_filetypes = {}


function! s:AllSyntaxGroups()
  " Return a dictionary of all the active syntax groups in current buffer
  " {group-name -> linked-group|NONE}

  redir => syntax_list
  silent execute "syntax list"
  redir END

  let syntax_list = split(syntax_list, "\n")
  if len(syntax_list) <= 1
    return {}
  endif

  let active_group = ''
  let active_group_link = 'NONE'
  let groups = {}
  for line in syntax_list[1:]
    if line[0] !=# ' '
      " new syntax group
      if active_group != ''
        let groups[active_group] = active_group_link
      endif
      let active_group = split(line, ' ')[0]
      let active_group_link = 'NONE'
    else
      " potential link
      let l = split(line, ' ')
      if len(l) >= 3 && l[0] ==# 'links' && l[1] ==# 'to'
        let active_group_link = l[2]
      endif
    endif
  endfor

  return groups
endfunction

function! s:ApplyWhitelist(all_groups)
  " Return a subset of all_groups that do not fit the whitelist
  " {group-name -> linked-group|NONE}

  let ft_whitelist = get(s:whitelisted_syntax_groups, &filetype, [])
  if type(ft_whitelist) ==# type('') && ft_whitelist ==? 'all'
    return {}
  endif

  if len(ft_whitelist) > 0 
    let whitelist = ft_whitelist
  else
    let whitelist = get(s:whitelisted_syntax_groups, 'global', [])
  endif

  let groups = {}
  for [group, linked_group] in items(a:all_groups)
    if !(index(whitelist, group) > -1 || index(whitelist, linked_group) > -1)
      let groups[group] = linked_group
    endif
  endfor

  return groups
endfunction

function! s:RemoveSyntaxGroups(groups)
  " Remove the actual highlights from the selected groups

  let gui_reset = 'guifg=none guibg=none guisp=none gui=none'
  let tui_reset = 'ctermfg=none ctermbg=none cterm=none'
  for group in keys(a:groups)
    exe "hi! " . group . ' ' . gui_reset . ' ' . tui_reset
  endfor
endfunction

function! syntaxless#RemoveSyntax(force)
  if !s:syntaxless_enabled || (!a:force && get(s:already_cleaned_up_filetypes, &filetype, 0))
    return
  endif

  let all_groups = s:AllSyntaxGroups()
  let groups_to_remove = s:ApplyWhitelist(all_groups)
  call s:RemoveSyntaxGroups(groups_to_remove)
  let s:already_cleaned_up_filetypes[&filetype] = 1
endfunction

function! syntaxless#SetEnabled(enabled)
  let s:syntaxless_enabled = a:enabled
  if s:syntaxless_enabled
    call syntaxless#RemoveSyntax()
  else
    " We need to restore colorscheme and syntax highlighting, so we refresh
    " the current colorscheme.
    redir => active_colorscheme
    silent execute "colorscheme"
    redir END

    let active_colorscheme = split(active_colorscheme, '\n')[0]
    exe "colorscheme " . active_colorscheme
    let s:already_cleaned_up_filetypes = {}
  endif
endfunction

function! syntaxless#Whitelist(filetype, ...)
  if a:0 == 0
    let syntax_groups = 'all'
  elseif a:0 == 1
    let syntax_groups = a:1
  endif

  if !exists('s:whitelisted_syntax_groups')
    let s:whitelisted_syntax_groups = {}
  endif
  let s:whitelisted_syntax_groups[a:filetype] = syntax_groups
endfunction

function! syntaxless#EchoSyntaxGroup()
  " Utility function for echoing syntax group under cursor.
  " Copied from https://stackoverflow.com/a/37040415

  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
