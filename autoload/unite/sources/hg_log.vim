" #############################################################################
" File: autoload/unite/sources/hg_log.vim
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

function! unite#sources#hg_log#define() "{{{
    return s:source
endfunction "}}}

let s:source = {
    \ 'name' : 'hg/log',
    \ 'description' : 'View current repo log',
    \ 'start_insert': 0,
    \ 'sorters': ['sorter_revert'],
    \ }

function! s:source.gather_candidates(args, context) "{{{
    if len(a:args)
        let source_file = a:args[0]
    else
        let source_file = ''
    endif
    let hg_root = hgunite#tools#get_repo_root(fnamemodify(source_file, ':h'))
    if hg_root == ''
        return []
    endif
    let candidates = []
    if len(source_file)
        let log_command = 'hg log -R ' . hg_root . ' --template "{rev}|{node|short}|{branches}|{date|isodate}|{desc|firstline}\n" ' . source_file
    else
        let log_command = 'hg log -R ' . hg_root . ' --template "{rev}|{node|short}|{branches}|{date|isodate}|{desc|firstline}\n"'
    endif
    for line in split(system(log_command), '\n')
        let line_data = split(line, '|')
        call add(candidates, {
                \ 'word' : substitute(line, '|', ' ', 'g'),
                \ 'kind' : 'hg_log',
                \ 'hg__node' : line_data[1],
                \ 'hg__root' : hg_root,
                \ 'hg__file' : source_file
                \ })
    endfor
    return candidates
endfunction  " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
