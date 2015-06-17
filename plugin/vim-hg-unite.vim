" #############################################################################
" File: plugin/vim-hg-unite.vim
" Author: Jean Cavallo <jean.cavallo@hotmail.fr>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" #############################################################################
let s:save_cpo = &cpo
set cpo&vim

if !exists("g:hg_unite_default_mappings") || g:hg_unite_default_mappings
    nnoremap <silent><leader>hf
        \ :execute "normal \<Plug>(hg-unite-log-file)"<CR>
    nnoremap <silent><leader>hd
        \ :execute "normal \<Plug>(hg-unite-diff)"<CR>
endif

nnoremap <silent><Plug>(hg-unite-log-file)
    \ :<C-U>call HgLogCurrentFile()<CR>
nnoremap <silent><Plug>(hg-unite-diff)
    \ :<C-U>call HgDiff()<CR>

function! HgLogCurrentFile() " {{{
    call unite#start_script([['hg/log', expand('%')]],
        \ {'start_insert': 0, 'is_redraw': 1}
        \ )
endfunction  " }}}

function! HgDiff() " {{{
    let hg_root = hgunite#tools#get_repo_root(expand('%:p:h'))
    let file_diff = system('hg diff -R ' . hg_root)
    let window_exist = hgunite#tools#get_named_window('__Hg_Diff__')
    if window_exist == ''
        execute ':90vsplit __Hg_Diff__'
        setlocal filetype=diff
        setlocal buftype=nofile
    else
        setlocal noreadonly
    endif
    normal! ggdG
    call append(0, split(file_diff, '\v\n'))
    setlocal readonly
    normal! gg
endfunction  " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
