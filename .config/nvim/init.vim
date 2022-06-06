" dein.vimの設定ファイルを読み込む
runtime! plugins/dein.rc.vim
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Color scheme
colorscheme hybrid

" Leaderキー
let mapleader = "\<Space>"

" clipboard連携
set clipboard+=unnamed

" " コメントアウト(nerd-commenter) nmap <Leader>/ <Plug>NERDCommenterToggle
"   vmap <Leader>/ <Plug>NERDCommenterToggle
"   nmap <Leader>/a <Plug>NERDCommenterAppend

" コメントアウト後の改行時にコメントアウトを引き継がない
  autocmd FileType * setlocal formatoptions-=ro

" 非アクティブウインドウの背景を白っぽくする
augroup ChangeBackground
  autocmd!
  autocmd WinEnter * highlight Normal guibg=black
  autocmd WinEnter * highlight NormalNC guibg='#474444'
  autocmd FocusGained * highlight Normal guibg=black
  autocmd FocusLost * highlight Normal guibg='#474444'
augroup END

" 検索のハイライトを消す
nmap <silent><Esc><Esc> :nohl<CR>

" Yank to current file path
nmap <leader>y :let @* = expand('%')<CR>

" init.vimの設定ファイルを再読み込み
nmap <leader>r :source ~/.config/nvim/init.vim<CR>

" Emacsキーバインド
nnoremap <silent> <C-f> <Right>
nnoremap <silent> <C-b> <Left>
nnoremap <silent> <C-a> <Home>
nnoremap <silent> <C-e> <End>
nnoremap <silent> <C-k> :EmacsKillCommand<CR>
" nnoremap <silent> <C-y> p
inoremap <silent> <C-p> <Up>
inoremap <silent> <C-n> <Down>
inoremap <silent> <C-f> <Right>
inoremap <silent> <C-b> <Left>
inoremap <silent> <C-a> <Home>
inoremap <silent> <C-e> <End>
inoremap <silent> <C-d> <Del>
inoremap <silent> <C-h> <BS>
inoremap <silent> <C-k> <ESC>:EmacsKillCommand<CR>a
" inoremap <silent> <C-Y> <ESC>pA
inoremap <silent> <C-j> <Down>
vnoremap <silent> <C-a> <Home>
vnoremap <silent> <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-k> <Right><C-\>egetcmdline()[:getcmdpos()-2]<CR><BS>
command! -nargs=0 EmacsKillCommand call EmacsKillCommand()

function! EmacsKillCommand()
  let s:currentLine = getline('.')
  let s:nextLine = getline(line('.')+1)
  let s:currentCol = col('.')
  let s:endCol = col('$')-1

  if s:currentLine == ""        " 現在の行が空白か判定
    :normal dd
  else
    if s:currentCol == s:endCol " カーソルが最終位置かどうか判定
      if s:nextLine == ""       " 次の行が空白か判定
        :normal J
      else
        :normal Jh
      endif
    elseif s:currentCol == 1    " 行の頭か判定
      normal D
    else
      :normal lD
    endif
  endif
endfunction

" " Insertモードをjjで抜けて保存もする
" inoremap <silent> jj <ESC>:w<CR>

" jjでInsertモードを抜ける
inoremap <silent> jj <ESC>

" 行末の空白を削除
nmap <silent> <leader>a :%s/\s\+$//<CR>

" Visual Line modeにスペース2回で移行する
nmap <Leader><Leader> V

" 画面分割キーマップ
nnoremap sv :<C-u>vs<CR><C-w>l
nnoremap ss :<C-u>sp<CR><C-w>j

" 行ごと移動
nnoremap <silent><leader>j :m+<CR>==
nnoremap <silent><leader>k :m-2<CR>==

" 行の移動を方式をデフォルトと逆に
nmap j gj
nmap k gk

" " 行末の空白をハイライト
" augroup HighlightTrailingSpaces
"   autocmd!
"   autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
"   autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
" augroup END

" 行を動かしてない時だけカーソルハイライトを有効にする
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END

"ファイルまたはバッファ番号を指定して差分表示。#なら裏バッファと比較
command! -nargs=? -complete=file Diff if '<args>'=='' | browse vertical diffsplit|else| vertical diffsplit <args>|endif

set number " 行を表示
" set termguicolors " True Color表示に対応
set incsearch  " インクリメンタルサーチを行う
set ignorecase " 大文字と小文字を区別しない
set smartcase  " 大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
set wrapscan   " 最後尾まで検索を終えたら次の検索で先頭に移る
set hlsearch   " 検索結果をハイライト
set tabstop=2     " 画面上でタブ文字が占める幅
set softtabstop=2 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set expandtab     " タブ入力を複数の空白入力に置き換える
set autoindent    " 改行時に前の行のインデントを継続する
set smartindent   " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent "C系の文法に従って自動インデント、{}とかに反応する
set shiftwidth=2  " 自動インデントでずれる幅
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ
set nobackup   " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない
set wildmenu " コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmode=full " TABキーによるファイル名補完リストをFullで出力
set history=10000 " 履歴を保存する件数
set showtabline=2 " 常にタブラインを表示
set diffopt+=vertical " :diffsplitを常に左右分割にする



"""""""""""""""""""""""""""""""""""Tabs"""""""""""""""""""""""""""""""""""
" " Anywhere SID.
" function! s:SID_PREFIX()
"   return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
" endfunction

" " Set tabline.
" function! s:my_tabline()  "{{{
"   let s = ''
"   for i in range(1, tabpagenr('$'))
"     let bufnrs = tabpagebuflist(i)
"     let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
"     let no = i  " display 0-origin tabpagenr.
"     let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
"     let title = fnamemodify(bufname(bufnr), ':t')
"     let title = '[' . title . ']'
"     let s .= '%'.i.'T'
"     let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
"     let s .= no . ':' . title
"     let s .= mod
"     let s .= '%#TabLineFill# '
"   endfor
"   let s .= '%#TabLineFill#%T%=%#TabLine#'
"   return s
" endfunction "}}}
" let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'

" Prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

" 新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" タブを閉じる
map <silent> [Tag]X :tabclose<CR>
" 次のタブ
map <silent> [Tag]l :tabnext<CR>
" 前のタブ
map <silent> [Tag]h :tabprevious<CR>
" 今開いてるタブ以外を閉じる
map <silent> [Tag]O :tabo<CR>


" FernでCtrl+nでファイルツリーを表示/非表示する
" nnoremap <Leader>e :Fern . -reveal=% -drawer -toggle -width=40<CR>
" FernでWindowにファイルエクスプローラーを表示する
nnoremap <Leader>e :Fern . -reveal=%<CR>

"" git操作
" g]で前の変更箇所へ移動する
nnoremap g[ :GitGutterPrevHunk<CR>
" g[で次の変更箇所へ移動する
nnoremap g] :GitGutterNextHunk<CR>
" ghでdiffをハイライトする
nnoremap gh :GitGutterLineHighlightsToggle<CR>
" gpでカーソル行のdiffを表示する
nnoremap gp :GitGutterPreviewHunk<CR>



"""""""""""""""""""""""""""""""""""fzf-preview"""""""""""""""""""""""""""""""""""
" Leaderキー
nmap <Leader>f <fzf-p>
xmap <Leader>f <fzf-p>

let g:fzf_preview_git_files_command   = 'git ls-files --exclude-standard | while read line; do if [[ ! -L $line ]] && [[ -f $line ]]; then echo $line; fi; done'
let g:fzf_preview_grep_cmd            = 'rg --line-number --no-heading --color=never --sort=path'
let g:fzf_preview_mru_limit           = 500
let g:fzf_preview_use_dev_icons       = 1
let g:fzf_preview_default_fzf_options = {
  \ '--reverse': v:true,
  \ '--preview-window': 'wrap',
  \ '--exact': v:true,
  \ '--no-sort': v:true,
  \ }
let $FZF_PREVIEW_PREVIEW_BAT_THEME  = 'gruvbox-dark'

nnoremap <silent> <fzf-p>p     :<C-u>CocCommand fzf-preview.ProjectFiles<CR>
" nnoremap <silent> <fzf-p>r     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> <fzf-p>r     :<C-u>CocCommand fzf-preview.MruFiles<CR>
nnoremap <silent> <fzf-p>R     :<C-u>CocCommand fzf-preview.ProjectMrwFiles<CR>
nnoremap <silent> <fzf-p>a     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> <fzf-p>g     :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> <fzf-p>s     :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> <fzf-p>b     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> <fzf-p>B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> <fzf-p>j     :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> <fzf-p>/     :<C-u>CocCommand fzf-preview.Lines --resume --add-fzf-arg=--no-sort<CR>
" nnoremap <silent> <fzf-p>*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="<C-r>=expand('<cword>')<CR>"<CR>
nnoremap <silent> <fzf-p>n     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="<C-r>=substitute(@/, '\(^\\v\)\\|\\\(<\\|>\)', '', 'g')<CR>"<CR>
nnoremap <silent> <fzf-p>?     :<C-u>CocCommand fzf-preview.BufferLines --resume --add-fzf-arg=--no-sort<CR>
nnoremap          <fzf-p>f     :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
nnoremap <silent> <fzf-p>q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> <fzf-p>l     :<C-u>CocCommand fzf-preview.LocationList<CR>
nnoremap <silent> <fzf-p>:     :<C-u>CocCommand fzf-preview.CommandPalette<CR>
" nnoremap <silent> <fzf-p>y     :<C-u>CocCommand fzf-preview.Yankround<CR>
nnoremap <silent> <fzf-p>m     :<C-u>CocCommand fzf-preview.Bookmarks --resume<CR>
nnoremap <silent> <fzf-p><C-]> :<C-u>CocCommand fzf-preview.VistaCtags --add-fzf-arg=--query="<C-r>=expand('<cword>')<CR>"<CR>
nnoremap <silent> <fzf-p>o     :<C-u>CocCommand fzf-preview.VistaBufferCtags<CR>

"nnoremap <silent> <dev>q  :<C-u>CocCommand fzf-preview.CocCurrentDiagnostics<CR>
"nnoremap <silent> <dev>Q  :<C-u>CocCommand fzf-preview.CocDiagnostics<CR>
"nnoremap <silent> <dev>rf :<C-u>CocCommand fzf-preview.CocReferences<CR>
"nnoremap <silent> <dev>t  :<C-u>CocCommand fzf-preview.CocTypeDefinitions<CR>

function! s:buffers_delete_from_lines(lines) abort
  for line in a:lines
    let matches = matchlist(line, '\[\(\d\+\)\]')
    if len(matches) >= 1
      execute 'Bdelete! ' . matches[1]
    endif
  endfor
endfunction

function! s:fzf_preview_settings() abort
  let g:fzf_preview_grep_preview_cmd = 'COLORTERM=truecolor ' . g:fzf_preview_grep_preview_cmd
  let g:fzf_preview_command = 'COLORTERM=truecolor ' . g:fzf_preview_command

  let g:fzf_preview_custom_processes['open-file'] = fzf_preview#remote#process#get_default_processes('open-file', 'coc')
  let g:fzf_preview_custom_processes['open-file']['ctrl-s'] = g:fzf_preview_custom_processes['open-file']['ctrl-x']
  call remove(g:fzf_preview_custom_processes['open-file'], 'ctrl-x')

  let g:fzf_preview_custom_processes['open-buffer'] = fzf_preview#remote#process#get_default_processes('open-buffer', 'coc')
  let g:fzf_preview_custom_processes['open-buffer']['ctrl-s'] = g:fzf_preview_custom_processes['open-buffer']['ctrl-x']
  call remove(g:fzf_preview_custom_processes['open-buffer'], 'ctrl-q')
  let g:fzf_preview_custom_processes['open-buffer']['ctrl-x'] = get(function('s:buffers_delete_from_lines'), 'name')

  let g:fzf_preview_custom_processes['open-bufnr'] = fzf_preview#remote#process#get_default_processes('open-bufnr', 'coc')
  let g:fzf_preview_custom_processes['open-bufnr']['ctrl-s'] = g:fzf_preview_custom_processes['open-bufnr']['ctrl-x']
  call remove(g:fzf_preview_custom_processes['open-bufnr'], 'ctrl-q')
  let g:fzf_preview_custom_processes['open-bufnr']['ctrl-x'] = get(function('s:buffers_delete_from_lines'), 'name')

  let g:fzf_preview_custom_processes['git-status'] = fzf_preview#remote#process#get_default_processes('git-status', 'coc')
  let g:fzf_preview_custom_processes['git-status']['ctrl-s'] = g:fzf_preview_custom_processes['git-status']['ctrl-x']
  call remove(g:fzf_preview_custom_processes['git-status'], 'ctrl-x')
endfunction

" カーソル位置の単語を全ファイル検索
nnoremap <leader>f* vawy:Rg <C-R>"<CR>
" 選択した単語を全ファイル検索
xnoremap f* y:Rg <C-R>"<CR>
" " PC全体の閲覧履歴検索
" nnoremap fR :History<CR>
" " プロジェクト全体のGit管理下のファイル検索（.gitが複数あっても一番親ディレクトリで検索）
" nnoremap fP :GFiles<CR>
