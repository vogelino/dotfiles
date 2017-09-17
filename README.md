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

### Vim utilsnips
To trigger a command press <kbd>→</kbd> (tab key)

#### [vim-es2015-snippets](https://github.com/epilande/vim-es2015-snippets)
| Trigger               	| Content                                    |
|---------------------------------:	|-------------------------------------------|
| <kbd>c=></kbd>                           	| Arrow function                  |
| <kbd>=>></kbd>                           	| Inline arrow function           |
| <kbd>c=></kbd>                           	| Arrow function in a constant    |
| <kbd>:</kbd>                             	| Key-value pair in object           |
| <kbd>c(onst)?</kbd>                      	| A const                            |
| <kbd>l(et)?</kbd>                        	| A let                              |
| <kbd>i(mport\|mp\|m)?</kbd>                	| import statement                   |
| <kbd>e(xport\|xp\|x)?</kbd>                	| export statement                   |
| <kbd>e(xport\|xp\|x)?</kbd>                	| import & export statements at once |
| <kbd>expf</kbd>                          	| non-arrow function export              |
| <kbd>fun*</kbd>                          	| generator function               |
| <kbd>class</kbd>                         	| class                            |
| <kbd>cl</kbd>                            	| console.log                    |
| <kbd>r</kbd>                             	| return statement                 |
| <kbd>:f</kbd>                            	| method in object                   |
| <kbd>.(map\|filter\|forEach\|reduce)</kbd>  	| FP method on an array              |
| <kbd>.(map\|filter\|forEach\|reduce)=</kbd> 	| Inline FP method on an array     |

#### [vim-react-snippets](https://github.com/epilande/vim-react-snippets)

##### Skeleton

| Trigger  | Content |
| -------: | ------- |
| <kbd>rrccd</kbd>  | React Redux Class Component |
| <kbd>rccd</kbd>   | React Class Component |
| <kbd>rfcd</kbd>   | React Functional Component |
| <kbd>rscd</kbd>   | React Styled Component |
| <kbd>rscid</kbd>   | React Styled Component Interpolation |


##### Lifecycle

| Trigger  | Content |
| -------: | ------- |
| <kbd>cwmd</kbd>   | `componentWillMount() {...}` |
| <kbd>cdmd</kbd>   | `componentDidMount() {...}` |
| <kbd>cwrpd</kbd>  | `componentWillReceiveProps(nextProps) {...}` |
| <kbd>scupd</kbd>  | `shouldComponentUpdate(nextProps, nextState) {...}` |
| <kbd>cwupd</kbd>  | `componentWillUpdate(nextProps, nextState) {...}` |
| <kbd>cdupd</kbd>  | `componentDidUpdate(prevProps, prevState) {...}` |
| <kbd>cwud</kbd>   | `componentWillUnmount() {...}` |
| <kbd>rend</kbd>   | `render() {...}` |


##### PropTypes

| Trigger    | Content |
| -------:   | ------- |
| <kbd>ptd</kbd>      | `propTypes {...}` |
| <kbd>pt.ad</kbd>    | `PropTypes.array` |
| <kbd>pt.bd</kbd>    | `PropTypes.bool` |
| <kbd>pt.fd</kbd>    | `PropTypes.func` |
| <kbd>pt.nd</kbd>    | `PropTypes.number` |
| <kbd>pt.od</kbd>    | `PropTypes.object` |
| <kbd>pt.sd</kbd>    | `PropTypes.string` |
| <kbd>pt.nod</kbd>   | `PropTypes.node` |
| <kbd>pt.ed</kbd>    | `PropTypes.element` |
| <kbd>pt.iod</kbd>   | `PropTypes.instanceOf` |
| <kbd>pt.oned</kbd>  | `PropTypes.oneOf` |
| <kbd>pt.onetd</kbd> | `PropTypes.oneOfType (Union)` |
| <kbd>pt.aod</kbd>   | `PropTypes.arrayOf (Instances)` |
| <kbd>pt.ood</kbd>   | `PropTypes.objectOf` |
| <kbd>pt.shd</kbd>   | `PropTypes.shape` |
| <kbd>ird</kbd>      | `isRequired` |

##### Others

| Trigger  | Content |
| -------: | ------- |
| <kbd>propsd</kbd> | `this.props` |
| <kbd>stated</kbd> | `this.state` |
| <kbd>setd</kbd>   | `this.setState(...)` |
| <kbd>dpd</kbd>    | `defaultProps {...}` |
| <kbd>cnd</kbd>    | `className` |
| <kbd>refd</kbd>   | `ref` |
| <kbd>ppd</kbd>    | `${props => props}` |

#### [vim-hyperstyle]()

##### Properties

| Trigger                                                    | Content                           |
| ---: | --- |
| <kbd>ai</kbd>tems <kbd>al</kbd>items <u>alignitems</u> <u>align-items</u> | align-items:                    |
| <kbd>an</kbd>imation                                         | animation:                      |
| <kbd>bg</kbd>round <kbd>ba</kbd>ckground                     | background:                     |
| <kbd>bgc</kbd>olor <kbd>backc</kbd>olor <kbd>bc</kbd>olor <u>backgroundc</u>olor <u>background-c</u>olor | background-color:               |
| <kbd>bgi</kbd>mage <kbd>backi</kbd>mage <kbd>bi</kbd>mage <u>backgroundi</u>mage <u>background-</u>image | background-image:               |
| <kbd>bgp</kbd>osition <kbd>backp</kbd>osition <kbd>bp</kbd>osition <u>backgroundp</u>osition <u>background-p</u>osition | background-position:            |
| <kbd>bgre</kbd>peat <kbd>backr</kbd>epeat <kbd>bre</kbd>peat <u>backgroundr</u>epeat <u>background-r</u>epeat | background-repeat:              |
| <kbd>bgs</kbd>ize <kbd>backs</kbd>ize <u>backgrounds</u>ize <u>background-s</u>ize | background-size:                |
| <kbd>bo</kbd>rder                                            | border:                         |
| <kbd>bb</kbd>ottom <kbd>borb</kbd>ottom <u>borderb</u>ottom <u>border-b</u>ottom | border-bottom:                  |
| <kbd>bbw</kbd>idth <u>borderbottomw</u>idth <u>border-bottom-</u>width | border-bottom-width:            |
| <kbd>bcoll</kbd>apse <u>borcoll</u>apse <kbd>coll</kbd>apse <u>bordercoll</u>apse <u>border-coll</u>apse | border-collapse:                |
| <u>bcolor</u> <kbd>boc</kbd>olor <kbd>borc</kbd>olor <u>borderc</u>olor <u>border-c</u>olor | border-color:                   |
| <kbd>bori</kbd>mage <u>borderi</u>mage <u>border-i</u>mage   | border-image:                   |
| <kbd>bl</kbd>eft <kbd>borl</kbd>eft <u>borderl</u>eft <u>border-l</u>eft | border-left:                    |
| <kbd>blw</kbd>idth <u>borderleftw</u>idth <u>border-left-</u>width | border-left-width:              |
| <kbd>bra</kbd>dius <kbd>bora</kbd>dius <u>borderra</u>dius <u>border-ra</u>dius | border-radius:                  |
| <kbd>bri</kbd>ght <kbd>borr</kbd>ight <u>borderr</u>ight <u>border-</u>right | border-right:                   |
| <kbd>brw</kbd>idth <u>borderrightw</u>idth <u>border-right-</u>width | border-right-width:             |
| <kbd>bt</kbd>op <kbd>bort</kbd>op <u>bordert</u>op <u>border-t</u>op | border-top:                     |
| <kbd>btw</kbd>idth <u>bordertopw</u>idth <u>border-top-</u>width | border-top-width:               |
| <kbd>bw</kbd>idth <u>borderw</u>idth <u>border-w</u>idth     | border-width:                   |
| <kbd>bot</kbd>tom                                            | bottom:                         |
| <kbd>bs</kbd>hadow <kbd>bos</kbd>hadow <kbd>box</kbd>shadow <u>box-shadow</u> | box-shadow:                     |
| <kbd>bsi</kbd>zing <kbd>bsize</kbd> <kbd>boxsi</kbd>ze <u>boxsizing</u> <u>box-si</u>zing | box-sizing:                     |
| <kbd>cl</kbd>ear                                             | clear:                          |
| <kbd>c</kbd>olor                                             | color:                          |
| <kbd>con</kbd>tent                                           | content:                        |
| <kbd>cu</kbd>rsor                                            | cursor:                         |
| <kbd>dir</kbd>ection                                         | direction:                      |
| <kbd>d</kbd>isplay                                           | display:                        |
| <kbd>fle</kbd>x                                              | flex:                           |
| <kbd>fd</kbd>irection <kbd>fld</kbd>irection <kbd>fled</kbd>irection <kbd>flexd</kbd>irection <u>flex-d</u>irection | flex-direction:                 |
| <kbd>fg</kbd>row <kbd>flg</kbd>row <kbd>fleg</kbd>row <kbd>flexg</kbd>row <kbd>flex-</kbd>grow | flex-grow:                      |
| <kbd>fsh</kbd>rink <kbd>fls</kbd>hrink <kbd>fles</kbd>hrink <kbd>flexs</kbd>hrink <u>flex-s</u>hrink | flex-shrink:                    |
| <kbd>fwr</kbd>ap <kbd>flw</kbd>rap <kbd>flew</kbd>rap <kbd>flexw</kbd>rap <u>flex-w</u>rap | flex-wrap:                      |
| <kbd>fl</kbd>oat                                             | float:                          |
| <kbd>f</kbd>ont                                              | font:                           |
| <kbd>ff</kbd>amily <kbd>fa</kbd>mily <kbd>fontf</kbd>amily <u>font-f</u>amily | font-family:                    |
| <kbd>fs</kbd>ize <kbd>fos</kbd>ize <kbd>fonts</kbd>ize <kbd>font-</kbd>size | font-size:                      |
| <kbd>fst</kbd>yle <kbd>fost</kbd>yle <u>fontst</u>yle <u>font-st</u>yle | font-style:                     |
| <kbd>fv</kbd>ariant <kbd>fov</kbd>ariant <kbd>fontv</kbd>ariant <u>font-v</u>ariant | font-variant:                   |
| <kbd>fw</kbd>eight <kbd>fow</kbd>eight <kbd>fontw</kbd>eight <u>font-w</u>eight | font-weight:                    |
| <kbd>h</kbd>eight                                            | height:                         |
| <kbd>j</kbd>content <u>jucontent</u> <u>juscontent</u> <u>justcontent</u> <u>justifycontent</u> <u>justify-content</u> | justify-content:                |
| <kbd>l</kbd>eft                                              | left:                           |
| <kbd>ls</kbd>pacing <kbd>les</kbd>pacing <kbd>let</kbd>terspacing <u>letter-spacing</u> | letter-spacing:                 |
| <kbd>lh</kbd>eight <kbd>lih</kbd>eight <kbd>lin</kbd>eheight <u>line-height</u> | line-height:                    |
| <kbd>m</kbd>argin                                            | margin:                         |
| <kbd>mb</kbd>ottom <kbd>marb</kbd>ottom <u>marginb</u>ottom <u>margin-b</u>ottom | margin-bottom:                  |
| <kbd>ml</kbd>eft <kbd>marl</kbd>eft <u>marginl</u>eft <u>margin-</u>left | margin-left:                    |
| <kbd>mr</kbd>ight <kbd>marr</kbd>ight <u>marginr</u>ight <u>margin-r</u>ight | margin-right:                   |
| <kbd>mt</kbd>op <kbd>mart</kbd>op <u>margint</u>op <u>margin-t</u>op | margin-top:                     |
| <kbd>x</kbd>height <kbd>mx</kbd>height <kbd>max</kbd>height <u>max-height</u> | max-height:                     |
| <kbd>xw</kbd>idth <kbd>m</kbd>xheight <kbd>maxw</kbd>idth <kbd>max-w</kbd>idth | max-width:                      |
| <kbd>mh</kbd>eight <kbd>mi</kbd>nheight <u>min-height</u>    | min-height:                     |
| <kbd>mw</kbd>idth <kbd>minw</kbd>idth <kbd>min-w</kbd>idth   | min-width:                      |
| <kbd>op</kbd>acity                                           | opacity:                        |
| <kbd>or</kbd>der                                             | order:                          |
| <kbd>o</kbd>utline                                           | outline:                        |
| <kbd>of</kbd>low <kbd>ov</kbd>erflow                         | overflow:                       |
| <kbd>ox</kbd> <u>overflowx</u> <u>overflow-</u>x             | overflow-x:                     |
| <kbd>oy</kbd> <u>overflowy</u> <u>overflow-y</u>             | overflow-y:                     |
| <kbd>pa</kbd>dding                                           | padding:                        |
| <kbd>pb</kbd>ottom <kbd>padb</kbd>ottom <u>paddingb</u>ottom <u>padding-b</u>ottom | padding-bottom:                 |
| <kbd>pl</kbd>eft <kbd>padl</kbd>eft <u>paddingl</u>eft <u>padding-</u>left | padding-left:                   |
| <kbd>pr</kbd>ight <kbd>padr</kbd>ight <u>paddingr</u>ight <u>padding-r</u>ight | padding-right:                  |
| <kbd>pt</kbd>op <kbd>padt</kbd>op <u>paddingt</u>op <u>padding-t</u>op | padding-top:                    |
| <kbd>pba</kbd>fter <kbd>pag</kbd>ebreakafter <u>page-break-after</u> | page-break-after:               |
| <kbd>pbb</kbd>efore <u>pagebreakb</u>efore <u>page-break-b</u>efore | page-break-before:              |
| <kbd>pe</kbd>rspective                                       | perspective:                    |
| <kbd>por</kbd>igin <u>perspectiveo</u>rigin <u>perspective-</u>origin | perspective-origin:             |
| <kbd>po</kbd>sition                                          | position:                       |
| <kbd>q</kbd>uotes                                            | quotes:                         |
| <kbd>r</kbd>ight                                             | right:                          |
| <kbd>tl</kbd>ayout <kbd>tala</kbd>yout <kbd>tab</kbd>lelayout <u>table-layout</u> | table-layout:                   |
| <kbd>ta</kbd>lign <kbd>te</kbd>xtalign <u>text-align</u>     | text-align:                     |
| <kbd>td</kbd>ecoration <kbd>textd</kbd>ecoration <u>text-d</u>ecoration | text-decoration:                |
| <kbd>tdl</kbd>ine <u>textdecorationl</u>ine <u>text-decoration-</u>line | text-decoration-line:           |
| <kbd>ti</kbd>ndent <kbd>texti</kbd>ndent <u>text-i</u>ndent  | text-indent:                    |
| <kbd>tsh</kbd>adow <kbd>tes</kbd>hadow <kbd>texts</kbd>hadow <u>text-s</u>hadow | text-shadow:                    |
| <kbd>tt</kbd>ransform <kbd>textt</kbd>ransform <u>text-t</u>ransform | text-transform:                 |
| <kbd>t</kbd>op                                               | top:                            |
| <kbd>tf</kbd>orm <kbd>xf</kbd>orm <u>transf</u>orm           | transform:                      |
| <kbd>tr</kbd>ans <kbd>tn</kbd> <kbd>ts</kbd>ition <u>transition</u> | transition:                     |
| <kbd>tdu</kbd>ration <u>transitiond</u>uration <u>transition-</u>duration | transition-duration:            |
| <kbd>v</kbd>align <u>verticalalign</u> <u>vertical-align</u> | vertical-align:                 |
| <kbd>vi</kbd>sibility                                        | visibility:                     |
| <kbd>ws</kbd>pace <kbd>wh</kbd>ispace <u>whspace</u> <kbd>wis</kbd>pace <u>whitespace</u> <u>white-space</u> | white-space:                    |
| <kbd>w</kbd>idth                                             | width:                          |
| <kbd>wb</kbd>reak <kbd>wo</kbd>rdbreak <u>word-break</u>     | word-break:                     |
| <kbd>z</kbd>index <u>z-index</u>                             | z-index:                        |
| <kbd>zo</kbd>om                                              | zoom:                           |

##### Statements

| Trigger                                                    | Content                           |
| ---: | --- |
| <kbd>aic</kbd>enter                                          | align-items: center             |
| <kbd>aie</kbd>nd                                             | align-items: flex-end           |
| <kbd>ai</kbd>start                                           | align-items: flex-start         |
| <kbd>aistr</kbd>etch                                         | align-items: stretch            |
| <kbd>brn</kbd>orepeat <kbd>n</kbd>orepeat                    | background-repeat: no-repeat    |
| <kbd>brx</kbd> <kbd>rx</kbd> <kbd>bg</kbd>rx <kbd>re</kbd>peatx | background-repeat: repeat-x     |
| <kbd>bry</kbd> <kbd>ry</kbd> <kbd>bgry</kbd> <u>repeaty</u>  | background-repeat: repeat-y     |
| <kbd>con</kbd>tain                                           | background-size: contain        |
| <kbd>co</kbd>ver                                             | background-size: cover          |
| <kbd>bc</kbd>collapse                                        | border-collapse: collapse       |
| <kbd>bcs</kbd>eparate                                        | border-collapse: separate       |
| <kbd>b0</kbd>                                                | border: 0                       |
| <kbd>bs</kbd>box                                             | box-sizing: border-box          |
| <kbd>bsc</kbd>ontent                                         | box-sizing: content-box         |
| <kbd>bsp</kbd>adding                                         | box-sizing: padding-box         |
| <kbd>cb</kbd>oth                                             | clear: both                     |
| <kbd>cl</kbd>eft                                             | clear: left                     |
| <kbd>cr</kbd>ight                                            | clear: right                    |
| <kbd>conte</kbd>nt                                           | content: ''                     |
| <kbd>cub</kbd>usy <kbd>curb</kbd>usy                         | cursor: busy                    |
| <kbd>cu</kbd>pointer <u>curpointer</u>                       | cursor: pointer                 |
| <kbd>cut</kbd>ext <kbd>curt</kbd>ext                         | cursor: text                    |
| <kbd>cuw</kbd>ait <kbd>curw</kbd>ait                         | cursor: wait                    |
| <kbd>l</kbd>tr <kbd>dir</kbd>ltr                             | direction: ltr                  |
| <kbd>rt</kbd>l <kbd>dirr</kbd>tl                             | direction: rtl                  |
| <kbd>d</kbd>block                                            | display: block                  |
| <kbd>df</kbd>lex <kbd>flex</kbd>                             | display: flex                   |
| <kbd>di</kbd>nline                                           | display: inline                 |
| <kbd>dib</kbd>lock                                           | display: inline-block           |
| <kbd>dif</kbd>lex                                            | display: inline-flex            |
| <kbd>dn</kbd>one                                             | display: none                   |
| <kbd>dt</kbd>able <kbd>t</kbd>able                           | display: table                  |
| <kbd>dtc</kbd>ell <kbd>c</kbd>ell <u>tablec</u>ell <u>table-</u>cell | display: table-cell             |
| <kbd>dtr</kbd>ow <kbd>r</kbd>ow <u>tabler</u>ow <u>table-r</u>ow | display: table-row              |
| <kbd>fdc</kbd>olumn                                          | flex-direction: column          |
| <kbd>fdcr</kbd>everse                                        | flex-direction: column-reverse  |
| <kbd>fd</kbd>row                                             | flex-direction: row             |
| <kbd>fdrr</kbd>everse                                        | flex-direction: row-reverse     |
| <kbd>fnow</kbd>rap                                           | flex-wrap: nowrap               |
| <kbd>fwr</kbd>ap <kbd>flexw</kbd>rap                         | flex-wrap: wrap                 |
| <kbd>fla</kbd>uto                                            | flex: auto                      |
| <kbd>f</kbd>left <u>flleft</u> <u>floleft</u>                | float: left                     |
| <kbd>fn</kbd>one <kbd>fln</kbd>one <kbd>flon</kbd>one        | float: none                     |
| <kbd>fr</kbd>ight <kbd>flr</kbd>ight <kbd>flor</kbd>ight     | float: right                    |
| <kbd>fs</kbd>italic <kbd>it</kbd>alic                        | font-style: italic              |
| <kbd>fnor</kbd>mal                                           | font-style: normal              |
| <kbd>f1</kbd>00 <kbd>fw1</kbd>00                             | font-weight: 100                |
| <kbd>f2</kbd>00 <kbd>fw2</kbd>00                             | font-weight: 200                |
| <kbd>f3</kbd>00 <kbd>fw3</kbd>00                             | font-weight: 300                |
| <kbd>f4</kbd>00 <kbd>fw4</kbd>00                             | font-weight: 400                |
| <kbd>f5</kbd>00 <kbd>fw5</kbd>00                             | font-weight: 500                |
| <kbd>f6</kbd>00 <kbd>fw6</kbd>00                             | font-weight: 600                |
| <kbd>f7</kbd>00 <kbd>fw7</kbd>00                             | font-weight: 700                |
| <kbd>f8</kbd>00 <kbd>fw8</kbd>00                             | font-weight: 800                |
| <kbd>f9</kbd>00 <kbd>fw9</kbd>00                             | font-weight: 900                |
| <kbd>fwb</kbd>old <kbd>bo</kbd>ld                            | font-weight: bold               |
| <kbd>fw</kbd>normal                                          | font-weight: normal             |
| <kbd>ha</kbd>uto                                             | height: auto                    |
| <kbd>jc</kbd>center                                          | justify-content: center         |
| <kbd>jce</kbd>nd                                             | justify-content: flex-end       |
| <kbd>jcs</kbd>tart                                           | justify-content: flex-start     |
| <kbd>ml</kbd>auto                                            | margin-left: auto               |
| <kbd>mr</kbd>auto                                            | margin-right: auto              |
| <kbd>m</kbd>0 <kbd>mo</kbd>                                  | margin: 0                       |
| <kbd>m0a</kbd> <kbd>moa</kbd>                                | margin: 0 auto                  |
| <kbd>ma</kbd>uto                                             | margin: auto                    |
| <kbd>oxa</kbd>uto                                            | overflow-x: auto                |
| <kbd>ox</kbd>hidden                                          | overflow-x: hidden              |
| <kbd>oxs</kbd>croll                                          | overflow-x: scroll              |
| <kbd>oxv</kbd>isible                                         | overflow-x: visible             |
| <kbd>oya</kbd>uto                                            | overflow-y: auto                |
| <kbd>oy</kbd>hidden                                          | overflow-y: hidden              |
| <kbd>oys</kbd>croll                                          | overflow-y: scroll              |
| <kbd>oyv</kbd>isible                                         | overflow-y: visible             |
| <kbd>oa</kbd>uto                                             | overflow: auto                  |
| <kbd>o</kbd>hidden                                           | overflow: hidden                |
| <kbd>os</kbd>croll                                           | overflow: scroll                |
| <kbd>ov</kbd>isible                                          | overflow: visible               |
| <kbd>p0</kbd> <kbd>po</kbd>                                  | padding: 0                      |
| <kbd>poa</kbd>bsolute <kbd>pa</kbd>bsolute <kbd>ab</kbd>solute | position: absolute              |
| <kbd>pof</kbd>ixed <kbd>pf</kbd>ixed <kbd>fi</kbd>xed        | position: fixed                 |
| <kbd>por</kbd>elative <kbd>pr</kbd>elative <kbd>rel</kbd>ative | position: relative              |
| <kbd>pos</kbd>tatic <kbd>ps</kbd>tatic <kbd>s</kbd>tatic     | position: static                |
| <kbd>tla</kbd>uto                                            | table-layout: auto              |
| <kbd>tl</kbd>fixed                                           | table-layout: fixed             |
| <kbd>tac</kbd>enter <kbd>cen</kbd>ter                        | text-align: center              |
| <kbd>taj</kbd>ustify <kbd>j</kbd>ustify                      | text-align: justify             |
| <kbd>tal</kbd>eft                                            | text-align: left                |
| <kbd>tar</kbd>ight                                           | text-align: right               |
| <kbd>tdn</kbd>one                                            | text-decoration: none           |
| <kbd>td</kbd>underline <kbd>un</kbd>derline                  | text-decoration: underline      |
| <kbd>e</kbd>lip <u>ellipsis</u> <kbd>to</kbd>ellipsis        | text-overflow: ellipsis         |
| <kbd>ts</kbd>none <kbd>te</kbd>shnone                        | text-shadow: none               |
| <kbd>ttc</kbd>ap                                             | text-transform: capitalize      |
| <kbd>ttf</kbd>ull                                            | text-transform: full-width      |
| <kbd>ttl</kbd>ower                                           | text-transform: lowercase       |
| <kbd>ttn</kbd>one                                            | text-transform: none            |
| <kbd>tt</kbd>upper <kbd>u</kbd>ppercase                      | text-transform: uppercase       |
| <kbd>vabl</kbd>ine <kbd>vaba</kbd>seline <kbd>ba</kbd>seline | vertical-align: baseline        |
| <kbd>vab</kbd>ottom                                          | vertical-align: bottom          |
| <kbd>v</kbd>amiddle                                          | vertical-align: middle          |
| <kbd>vas</kbd>ub                                             | vertical-align: sub             |
| <kbd>vasup</kbd>er                                           | vertical-align: super           |
| <kbd>vattb</kbd>ottom                                        | vertical-align: text-bottom     |
| <kbd>vatt</kbd>op                                            | vertical-align: text-top        |
| <kbd>vat</kbd>op                                             | vertical-align: top             |
| <kbd>vc</kbd>ollapse <kbd>visc</kbd>ollapse <kbd>vic</kbd>ollapse | visibility: collapse            |
| <kbd>vh</kbd>idden <kbd>vish</kbd>idden <kbd>vih</kbd>idden <kbd>h</kbd>idden <kbd>hide</kbd> | visibility: hidden              |
| <kbd>vv</kbd>isible <kbd>vi</kbd>sible                       | visibility: visible             |
| <kbd>now</kbd>rap                                            | white-space: nowrap             |
| <kbd>w</kbd>auto                                             | width: auto                     |
