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
  " Return a subset of all_groups that fit the whitelist
  " {group-name -> linked-group|NONE}

  let ft_whitelist = get(g:syntaxless_whitelisted_syntax_groups, &filetype, [])
  if type(ft_whitelist) ==# type('') && ft_whitelist ==? 'all'
    return a:all_groups
  endif

  let whitelist = get(g:syntaxless_whitelisted_syntax_groups, 'global', [])
              \ + ft_whitelist
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

  for g in keys(a:groups)
    exe "hi " . g . " guifg=none guibg=none guisp=none gui=none"
  endfor
endfunction

function! syntaxless#RemoveSyntax()
  let all_groups = s:AllSyntaxGroups()
  let groups_to_remove = s:ApplyWhitelist(all_groups)
  call s:RemoveSyntaxGroups(groups_to_remove)
endfunction

function! syntaxless#EchoSyntaxGroup()
  " Utility function for echoing syntax group under cursor.
  " Copied from https://stackoverflow.com/a/37040415

  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
