" #############################################################################
" File: autoload/unite/kinds/hg_status.vim
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

function! unite#kinds#hg_status#define()  " {{{
    return s:kind
endfunction  " }}}

let s:kind = {
    \ 'name': 'hg_status',
    \ 'default_action': 'open',
    \ 'action_table': {},
    \ 'parents': ['file'],
    \ }

let s:kind.action_table.revert = {
    \ 'is_selectable': 1,
    \ 'is_quit': 1
    \ }

function! s:kind.action_table.revert.func(candidates)  " {{{
    let reverted_files = 0
    for candidate in a:candidates
        if candidate.hg__status != '?' && candidate.hg__status != '!'
            call system('hg revert ' . candidate.action__path)
            let reverted_files += 1
        endif
    endfor
    echom string(reverted_files) . ' files reverted'
endfunction  " }}}

let s:kind.action_table.add = {
    \ 'is_selectable': 1,
    \ 'is_quit': 1
    \ }

function! s:kind.action_table.add.func(candidates)  " {{{
    let added_files = 0
    for candidate in a:candidates
        if candidate.hg__status == '?' || candidate.hg__status == '!'
            call system('hg add ' . candidate.action__path)
            let added_files += 1
        endif
    endfor
    echom string(added_files) . ' files added'
endfunction  " }}}

let s:kind.action_table.view_diff = {
    \ 'is_selectable': 1,
    \ 'is_quit': 1
    \ }

function! s:kind.action_table.view_diff.func(candidates)  " {{{
    let candidate_path = a:candidates[0].action__relpath
    let file_diff = system('hg diff ' . candidate_path)
    vsplit __Hg_Diff__
    normal! ggdG
    setlocal filetype=diff
    setlocal buftype=nofile
    call append(0, split(file_diff, '\v\n'))
endfunction  " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
