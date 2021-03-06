" #############################################################################
" File: autoload/unite/sources/hg_shelve.vim
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

function! unite#sources#hg_shelve#define() "{{{
    return s:source
endfunction "}}}

let s:source = {
    \ 'name' : 'hg/shelves',
    \ 'description' : 'View current shelves',
    \ 'start_insert': 0,
    \ 'sorters': ['sorter_revert'],
    \ }

function! s:source.gather_candidates(args, context) "{{{
    let hg_root = hgunite#tools#get_repo_root()
    if hg_root == ''
        return []
    endif
    let candidates = []
    for line in split(system('hg shelve -l -R ' . hg_root), '\n')
        let shelve_name = split(line, ' ')[0]
        call add(candidates, {
                \ 'word' : line,
                \ 'kind' : 'hg_shelve',
                \ 'hg__shelve_name' : shelve_name,
                \ 'hg__root' : hg_root
                \ })
    endfor
    return candidates
endfunction  " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
