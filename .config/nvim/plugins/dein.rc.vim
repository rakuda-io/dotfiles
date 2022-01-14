" プラグインの設定ファイルPath
let s:plugin = '~/.config/nvim/plugins/config/dein.toml'

" Neovim起動時にdein.tomlファイルをチェックし、未インストールのプラグインがあった場合インストールする
if &compatible
  set nocompatible " Be iMproved
endif

set runtimepath+=/Users/yukikubota/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('/Users/yukikubota/.cache/dein')
  call dein#begin('/Users/yukikubota/.cache/dein')

  let s:toml_dir = $HOME . '/.config/nvim'
  let s:toml = s:toml_dir . '/plugins/config/dein.toml'

  call dein#load_toml(s:toml, {})
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

let g:dein#auto_recache = 1
