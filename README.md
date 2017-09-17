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

#### [vim-es2015-snippets](https://github.com/epilande/vim-es2015-snippets)
| Action                                    	| command + `<Tab>`               	|
|-------------------------------------------	|---------------------------------	|
| Create an arrow function                  	| `c=>`                           	|
| Create an inline arrow function           	| `=>>`                           	|
| Create an arrow function in a constant    	| `c=>`                           	|
| Create key-value pair in object           	| `:`                             	|
| Create a const                            	| `c(onst)?`                      	|
| Create a let                              	| `l(et)?`                        	|
| Create import statement                   	| `i(mport|mp|m)?`                	|
| Create export statement                   	| `e(xport|xp|x)?`                	|
| Create import & export statements at once 	| `e(xport|xp|x)?`                	|
| Export an non-arrow function              	| `expf`                          	|
| Create a generator function               	| `fun*`                          	|
| Create a class                            	| `class`                         	|
| Create a log statement                    	| `cl`                            	|
| Create a return statement                 	| `r`                             	|
| Create method in object                   	| `:f`                            	|
| Call a FP method on an array              	| `.(map|filter|forEach|reduce)`  	|
| Same as above with an inline function     	| `.(map|filter|forEach|reduce)=` 	|
