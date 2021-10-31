# syntaxless.vim

A (Neo)vim plugin for removing all but some whitelisted syntax highlighting,
allowing you to use your favorite colorscheme. Think `:syntax less`, not
syntaxless.

## Installing

Install using your favorite plugin manager. E.g. using
[vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'adolenc/syntaxless.vim'
```

Simply installing and letting your plugin manager do the rest is enough for the
plugin to work. By default, strings, comments, and TODOs are whitelisted
globally, while all the other syntax groups are cleared up.

## Usage

#### `syntaxless#Whitelist(filetype{, syntax_groups})`

The main function to define syntax group whitelist globally and/or for a
specific filetype. `filetype` can either be a string `'global'` for global
whitelist, or `filetype` for whitelisting groups for specific filetype.
`syntax_groups` should be a list of strings (whitelisted syntax groups), but
can be ommited for whitelisting the entire filetype. Per-filetype whitelisted
groups override the global whitelisted groups for that specific filetype.

Default: `call syntaxless#Whitelist('global', ['String', 'Comment', 'Todo'])`

Example configuration:
```vim
" Globally whitelist strings and comments
call syntaxless#Whitelist('global', ['String', 'Comment'])

" For Python, whitelist pythonStatement, strings, and comments
call syntaxless#Whitelist('python', ['pythonStatement', 'String', 'Comment'])

" Whitelist all syntax groups for markdown and nerdtree buffers
call syntaxless#Whitelist('markdown')
call syntaxless#Whitelist('nerdtree')
```

To remove the default global whitelist, use `call
syntaxless#Whitelist('global', [])`.

To find a list of possible syntax groups for a specific file, run `:syntax
list` with that file open, or check `:h group-name` for a global list of vim's
syntax groups.

To figure out the filetype for a specific file, use `:set ft?` with that file
open.

#### `:SyntaxlessDisableForSession`

Command to disable the plugin until the end of the current session.

#### `:SyntaxlessEnableForSession`

Command to re-enable the plugin until the end of the current session.

#### `syntaxless#EchoSyntaxGroup()`

Utility function that prints the syntax group under cursor. Copied from
[this](https://stackoverflow.com/a/37040415) Stack Overflow answer.

## Why 

I first learned that there exist programmers that don't use syntax highlighting 
from a brilliant colleague that was in the same class at university. At first
it seemed like madness, but I decided to try it out, and have been using no
syntax highlighting for a very good number of years now. Afterwards, I have
learned that great engineers like Linus Torvalds[^1] and Rob Pike[^2] also
don't particularly fancy syntax highlighting too much, and I was able to find
multiple blog posts[^3][^4][^5] from other enlightened programmers as well.

No syntax highlighting, at least for me, makes the code more readable (as odd as
that might sound to someone that has never tried it) and allows me to use
colors for actually useful stuff.

One way to prevent syntax highlighting in vim is to use `:syntax off`. The
issue with this approach is that this removes _all_ the syntax highlighting
with no fine-grained control, whereas some syntax groups (e.g. comments or
strings) are extremely useful for readability of the code.

For this reason it is most often suggested to maintain your own colorscheme to
remove syntax groups you do not want. The problem with that suggestion is that
colorschemes define more than just the coloring of syntax elements, they are
used to change the look of the entire editor - popup menus, backgrounds, diff
highlighting, plugin-specific colors, ... Trying to maintain your own
colorscheme that covers all of this and is kept up to date, just to get rid of
most of the syntax elements, is extremely cumbersome.

syntaxless.vim solves both these problems: you can use your prefered
colorscheme that is maintained by other programmers (and switch to a different
colorscheme whenever you want), and allows for whitelisting of certain syntax
groups.

[^1]: https://www.tag1consulting.com/blog/interview-linus-torvalds-linux-and-git
[^2]: https://groups.google.com/g/golang-nuts/c/hJHCAaiL0so/m/kG3BHV6QFfIJ
[^3]: https://www.linusakesson.net/programming/syntaxhighlighting/
[^4]: https://web.archive.org/web/20170319161308/https://kyleisom.net/blog/2012/10/17/syntax-off/
[^5]: https://web.archive.org/web/20170319161234/https://www.robertmelton.com/2016/04/10/syntax-highlighting-off/

## License

Copyright (c) 2021 Andrej Dolenc

Licensed under the MIT License.
