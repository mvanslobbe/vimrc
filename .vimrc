set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Bundle 'Valloric/YouCompleteMe'
Plugin 'zxqfl/tabnine-vim'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'flazz/vim-colorschemes'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'libclang-vim/libclang-vim'
Bundle 'mhinz/vim-signify'
Bundle 'kopischke/vim-fetch'
Bundle '907th/vim-auto-save'
Bundle 'ryanoasis/vim-devicons'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'phleet/vim-mercenary'
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'


call vundle#end()            " required
filetype plugin indent on    " required

let g:clang_complete_copen=0
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_max_diagnostics_to_display = 0

autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set autoindent
set expandtab
"set tags=~/sandbox/project/mainline/tags
set mouse=a
set number
set noswapfile

function AutoFormat()
        setl autoread
        silent !/usr/local/bin/format.sh <afile>
endfunction

function ClangFormat()
    setl autoread
    silent !clang-format-6.0 -i <afile>
        silent !/usr/local/bin/format.sh <afile>
endfunction

autocmd BufWritePost *.c call AutoFormat()
autocmd BufWritePost *.cc call AutoFormat()
autocmd BufWritePost *.h call AutoFormat()
autocmd BufWritePost *.hxx call AutoFormat()
autocmd BufWritePost *.lua call AutoFormat()
"autocmd BufWritePost *.py call AutoFormat()
autocmd BufWritePost sconscript call AutoFormat()

autocmd BufWritePost **/fpred/*.cc call ClangFormat()
autocmd BufWritePost **/fpred/*.h call ClangFormat()
autocmd BufWritePost **/fpred/*.hxx call ClangFormat()

autocmd BufWritePost **/fpred_team/*.cc call ClangFormat()
autocmd BufWritePost **/fpred_team/*.h call ClangFormat()
autocmd BufWritePost **/fpred_team/*.hxx call ClangFormat()

autocmd BufWritePost **/quant/*.cc call ClangFormat()
autocmd BufWritePost **/quant/*.h call ClangFormat()
autocmd BufWritePost **/quant/*.hxx call ClangFormat()

autocmd BufWritePost **/ftd/*.cc call ClangFormat()
autocmd BufWritePost **/ftd/*.h call ClangFormat()
autocmd BufWritePost **/ftd/*.hxx call ClangFormat()

colorscheme desert
syntax match ExtraWhitespace "/\s\+$/"
syntax match Tabs "/\t\+/"
highlight ExtraWhitespace ctermbg=red guibg=red
highlight Tabs ctermbg=red guibg=red

highlight Tabs ctermbg=red guibg=red
match Tabs /\t\+/

highlight Templates ctermbg=green guibg=green
match Templates /<\s\*.*\s\+>|<\s\+.*\s\*>/

syntax match CommentedOutTests /\/\*\_.*CPPUNIT_TEST\_.*\*\//
highlight CommentedOutTests ctermbg=blue guibg=blue

autocmd VimEnter * match Templates /<\s\+.*\s+>/
autocmd VimEnter * match Tabs /\t\+/
autocmd VimEnter * match ExtraWhitespace /\s\+$/
autocmd VimEnter * highlight Tabs ctermbg=red guibg=red
autocmd VimEnter * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd VimEnter * highlight Templates ctermbg=green guibg=green
autocmd VimEnter * highlight CommentedOutTests ctermbg=blue guibg=blue

map <F3> :'<,'>s/^/    /g<CR>
map <F4> :AutoSaveToggle<CR>
map <F5> :%s/\s\+$//g<CR>
map <F6> :CtrlP<CR>
map <F7> :YcmCompleter GoTo<CR>
map <F8> :call CurtineIncSw()<CR>
map <F9> :YcmCompleter FixIt<CR>
map <F10> :exec Blame()<CR>
map <F2> :redraw!<CR>

set encoding=utf8
set guifont=Code\ New\ Roman\ 11

let NERDTreeIgnore = ['.*SCons\.Node\.*', '.*\.orig$', '.*\~$', 'signalgen\..*', '.*ordertracker.*' ]

command! -nargs=? -range Align <line1>,<line2>call AlignSection('<args>')
vnoremap <silent> <Leader>a :Align<CR>
function! AlignSection(regex) range
  let extra = 1
  let sep = empty(a:regex) ? '=' : a:regex
  let maxpos = 0
  let section = getline(a:firstline, a:lastline)
  for line in section
    let pos = match(line, ' *'.sep)
    if maxpos < pos
      let maxpos = pos
    endif
  endfor
  call map(section, 'AlignLine(v:val, sep, maxpos, extra)')
  call setline(a:firstline, section)
endfunction

function! AlignLine(line, sep, maxpos, extra)
  let m = matchlist(a:line, '\(.\{-}\) \{-}\('.a:sep.'.*\)')
  if empty(m)
    return a:line
  endif
  let spaces = repeat(' ', a:maxpos - strlen(m[1]) + a:extra)
  return m[1] . spaces . m[2]
endfunction

