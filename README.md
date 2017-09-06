# vogelino's dotfiles
Vim, Zsh and other terminal tools, configs and sugar.

## Tips

### Vim

#### Vim built in

**Bring next line up**: `shift` + `J`

#### [vim-surround](https://github.com/tpope/vim-surround)
**Replace surrounding characters**: `cs<toReplace><replaceWith>`
Move cursor inside quotes or brackets, type cs + the existing surround character + the character you which to replace with.

Tipp: _For brackets, use closing brackets as a replacement character if you want to avoid surrounding spaces._

**Wrap selection with surrounding characters**: In visual mode > `S<surroundWith>`
Move cursor inside quotes or brackets, type cs + the existing surround character + the character you which to replace with.

Tipp: _in both cases it is possible to use xml-like syntaxes such as HTML or JSX_
