set nocompatible

" netrw
let g:netrw_liststyle="tree"

" easytags
" let g:easytags_suppress_ctags_warning = 1
let g:easytags_resolve_links = 1
let g:easytags_cmd = '/usr/local/bin/ctags'
let g:easytags_dynamic_files = 1

" UltiSnips
let g:UltiSnipsEditSplit = "horizontal"
let g:UltiSnipsExpandTrigger = "<c-tab>"
let g:UltiSnipsListSnippets = "<c-s-tab>"

" Notes
if isdirectory($HOME . '/Dropbox/Notes')
  let g:notes_directory = '~/Dropbox/Notes'
elseif isdirectory($HOME . '/Documents/Notes')
  let g:notes_directory = '~/Documents/Notes'
endif

" NERDCommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1

" Powerline
let g:Powerline_symbols = "unicode"

" CtrlP
let g:ctrlp_jump_to_buffer = 2 " Jump to active buffer, even if in another tab
let g:ctrlp_root_markers = ['Rakefile', 'Gemfile', '.rvmrc']
let g:ctrlp_cache_dir = $HOME.'/.vim/tmp/ctrlp'
let g:ctrlp_prompt_mappings = {
  \ 'ToggleRegex()':        [],
  \ 'PrtClearCache()':      ['<F5>', '<c-r>']
  \ }

source ~/.vim/bundles.vim

syntax on
filetype plugin indent on

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

