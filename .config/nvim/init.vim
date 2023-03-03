"================================================================
" Basic settings
"================================================================
source ~/.config/nvim/vimrc.set

let mapleader = "\<Space>"
" コメントアウト後の改行時にコメントアウトを引き継がない
autocmd FileType * setlocal formatoptions-=r
autocmd FileType * setlocal formatoptions-=o


"================================================================
" Basic keymaps
"================================================================
source ~/.config/nvim/vimrc.keymap

"================================================================
" nvim keymaps
"================================================================
" init.vimの設定ファイルを再読み込み
nmap <leader>R :source ~/.config/nvim/init.vim<CR>

" 現在開いているファイルのフルパスをクリップボードにコピー
nmap <leader>y :let @* = expand('%')<CR>

" 行末の空白文字を削除して保存
nnoremap <silent> W :w<CR>:%s/\s\s*$<CR>

" 直前の検索ワードのヒット数
nmap <C-s> :%s///gn<CR>

" Emacsキーバインド(vim/nvimでしか動かないやつ)
inoremap <silent> <C-k> <ESC>:EmacsKillCommand<CR>a
cnoremap <C-k> <Right><C-\>egetcmdline()[:getcmdpos()-2]<CR><BS>
command! -nargs=0 EmacsKillCommand call EmacsKillCommand()
" vimでもC-kで後ろの文字一括消去できるようにする自作コマンド
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

"================================================================
" Color theme
"================================================================
colorscheme hybrid
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE
highlight Visual ctermbg=grey guibg=grey
highlight CursorLine guibg=#555555

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

" *****Alacritty移行のタイミングで透過させたかったので一旦OFF(2023/01/25)*****
" 非アクティブウインドウの背景を白っぽくする
" augroup ChangeBackground
"   autocmd!
"   autocmd WinEnter * highlight Normal guibg= dark
"   autocmd WinEnter * highlight NormalNC guibg= '#333333'
"   autocmd FocusGained * highlight Normal guibg= dark
"   autocmd FocusLost * highlight Normal guibg= '#333333'
" augroup END


"================================================================
" Tab 操作
"================================================================
" Prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump (t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ)
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" 新しいタブを隣に作る
map <silent> [Tag]c :tabnew<CR>
" 新しいタブを一番右に作る
" map <silent> [Tag]c :tablast <bar> tabnew<CR>
" タブを閉じる
map <silent> [Tag]x :tabclose<CR>
" 直前のタブを再度開く
map <silent> [Tag]X :tabe#<CR>
" 次のタブ
map <silent> [Tag]l :tabnext<CR>
" 前のタブ
map <silent> [Tag]h :tabprevious<CR>
" 今開いてるタブ以外を閉じる
map <silent> [Tag]O :tabo<CR>


"================================================================
" Plugins
"================================================================
" ========== dein.vim ==========
runtime! plugins/dein.rc.vim
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction


" ========== coc.nvim ==========
" extensionsのグローバル設定
let g:coc_global_extensions = [
      \'coc-diagnostic',
      \'coc-dictionary',
      \'coc-docker',
      \'coc-emmet',
      \'coc-explorer',
      \'coc-git',
      \'coc-highlight',
      \'coc-html',
      \'coc-java',
      \'coc-json',
      \'coc-lists',
      \'coc-markdownlint',
      \'coc-metals',
      \'coc-pairs',
      \'coc-snippets',
      \'coc-tsserver',
      \'coc-vetur',
      \'coc-yaml'
\]

" coc.nvimの補完候補をTABで選択可能に
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 定義元ジャンプ(coc)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" ========== ale ==========
nmap <silent> ]w <Plug>(ale_next_wrap)
nmap <silent> [w <Plug>(ale_previous_wrap)


" ========== fern.vim ==========
" a.) ファイルツリーを表示/非表示する
" nnoremap <Leader>e :Fern . -reveal=% -drawer -toggle -width=40<CR>

" b.) Windowにファイルエクスプローラーを表示する
nnoremap <Leader>e :Fern . -reveal=%<CR>


" ========== vim.gitgutter ==========
" g]で前の変更箇所へ移動する
nnoremap g[ :GitGutterPrevHunk<CR>
" g[で次の変更箇所へ移動する
nnoremap g] :GitGutterNextHunk<CR>
" ghでdiffをハイライトする
nnoremap gh :GitGutterLineHighlightsToggle<CR>
" gpでカーソル行のdiffを表示する
nnoremap gp :GitGutterPreviewHunk<CR>


" ========== fzf-preview ==========
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
nnoremap <silent> <fzf-p>r     :<C-u>CocCommand fzf-preview.ProjectMrwFiles<CR>
nnoremap <silent> <fzf-p>R     :<C-u>CocCommand fzf-preview.MruFiles<CR>
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

nnoremap <silent> <fzf-p>d  :<C-u>CocCommand fzf-preview.CocCurrentDiagnostics<CR>
nnoremap <silent> <fzf-p>D  :<C-u>CocCommand fzf-preview.CocDiagnostics<CR>
" nnoremap <silent> <fzf-p>R :<C-u>CocCommand fzf-preview.CocReferences<CR>
" nnoremap <silent> <fzf-p>T  :<C-u>CocCommand fzf-preview.CocTypeDefinitions<CR>

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


" ========== lightline.vim ==========
set laststatus=2
set noshowmode
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [
        \     ['mode', 'paste'],
        \     ['fugitive', 'gitgutter', 'filename'],
        \   ],
        \   'right': [
				\     ['percent'],
        \     ['fileformat', 'fileencoding', 'filetype'],
        \   ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode',
        \   'syntastic': 'SyntasticStatuslineFlag',
        \   'charcode': 'MyCharCode',
        \   'gitgutter': 'MyGitGutter',
        \ },
        \ 'separator': {'right': ''},
        \ 'subseparator': {'left': '|', 'right': '|'}
        \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '⭤' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? '⭠ '._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth('.') > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth('.') > 60 ? lightline#mode() : ''
endfunction

function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

" https://github.com/Lokaltog/vim-powerline/blob/develop/autoload/Powerline/Functions.vim
function! MyCharCode()
  if winwidth('.') <= 70
    return ''
  endif

  " Get the output of :ascii
  redir => ascii
  silent! ascii
  redir END

  if match(ascii, 'NUL') != -1
    return 'NUL'
  endif

  " Zero pad hex values
  let nrformat = '0x%02x'

  let encoding = (&fenc == '' ? &enc : &fenc)

  if encoding == 'utf-8'
    " Zero pad with 4 zeroes in unicode files
    let nrformat = '0x%04x'
  endif

  " Get the character and the numeric value from the return value of :ascii
  " This matches the two first pieces of the return value, e.g.
  " "<F>  70" => char: 'F', nr: '70'
  let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

  " Format the numeric value
  let nr = printf(nrformat, nr)

  return "'". char ."' ". nr
endfunction