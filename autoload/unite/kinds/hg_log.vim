" #############################################################################
" File: autoload/unite/kinds/hg_log.vim
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

function! unite#kinds#hg_log#define()  " {{{
    return s:kind
endfunction  " }}}

let s:kind = {
    \ 'name': 'hg_log',
    \ 'default_action': 'diff',
    \ 'action_table': {},
    \ 'parents': ['word'],
    \ }

let s:kind.action_table.diff = {
    \ 'is_selectable': 1,
    \ 'is_quit': 1
    \ }

function! s:kind.action_table.diff.func(candidates)  " {{{
    let candidate_node = a:candidates[0].hg__node
    if a:candidates[0].hg__file
        let file_diff = system('hg diff -c ' . candidate_node . ' -R ' . a:candidates[0].hg__root . ' ' . a:candidates[0].hg__file)
    else
        let file_diff = system('hg export ' . candidate_node . ' -R ' . a:candidates[0].hg__root)
    endif
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

let s:kind.action_table.changelog = {
    \ 'is_selectable': 1,
    \ 'is_quit': 1
    \ }

function! s:kind.action_table.changelog.func(candidates)  " {{{
    let candidate_node = a:candidates[0].hg__node
    let file_diff = system('hg log -r ' . candidate_node . ' --style default' . ' -R ' . a:candidates[0].hg__root)
    let window_exist = hgunite#tools#get_named_window('__Hg_Log__')
    if window_exist == ''
        execute ':90vsplit __Hg_Log__'
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
