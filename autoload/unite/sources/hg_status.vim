" #############################################################################
" File: autoload/unite/sources/hg_status.vim
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

function! unite#sources#hg_status#define() "{{{
    return s:source
endfunction "}}}

let s:source = {
    \ 'name' : 'hg/status',
    \ 'description' : 'Browse current repo status',
    \ 'start_insert': 0,
    \ }

let s:actions = {
    \ '!' : '(deleted) ',
    \ '?' : '(unknown) ',
    \ 'A' : '(added)   ',
    \ 'R' : '(removed) ',
    \ 'M' : '(modified)'
    \ }

function! s:source.gather_candidates(args, context) "{{{
    let hg_root = hgunite#tools#get_repo_root()
    let candidates = []
    for line in split(system('hg status'), '\n')
        let action = line[0]
        let fname = line[2:]
        let full_path = hg_root . '/' . fname
        call add(candidates, {
                \ 'word' : s:actions[action] . '   ' . fname,
                \ 'kind' : 'hg_status',
                \ 'action__path' : full_path,
                \ 'action__relpath': fname,
                \ 'hg__status': line[0]
                \ })
    endfor
    return candidates
endfunction  " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
