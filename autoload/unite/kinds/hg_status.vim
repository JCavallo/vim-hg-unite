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
            call system('hg revert ' . candidate.action__path . ' -R ' . a:candidates[0].hg__root)
            let reverted_files += 1
        endif
    endfor
    echom string(reverted_files) . ' files reverted'
    call unite#start_script([['hg/status']],
        \ {'start_insert': 0, 'is_redraw': 1}
        \ )
endfunction  " }}}

let s:kind.action_table.add = {
    \ 'is_selectable': 1,
    \ 'is_quit': 1
    \ }

function! s:kind.action_table.add.func(candidates)  " {{{
    let added_files = 0
    for candidate in a:candidates
        if candidate.hg__status == '?' || candidate.hg__status == '!'
            call system('hg add ' . candidate.action__path . ' -R ' . a:candidates[0].hg__root)
            let added_files += 1
        endif
    endfor
    echom string(added_files) . ' files added'
    call unite#start_script([['hg/status']],
        \ {'start_insert': 0, 'is_redraw': 1}
        \ )
endfunction  " }}}

let s:kind.action_table.diff = {
    \ 'is_selectable': 1,
    \ 'is_quit': 1
    \ }

function! s:kind.action_table.diff.func(candidates)  " {{{
    let window_exist = hgunite#tools#get_named_window('__Hg_Diff__')
    if window_exist == ''
        vsplit __Hg_Diff__
        setlocal filetype=diff
        setlocal buftype=nofile
    else
        setlocal noreadonly
    endif
    normal! ggdG
    for candidate in a:candidates
        let file_diff = system('hg diff ' . candidate.action__path . ' -R ' . a:candidates[0].hg__root)
        call append(0, split(file_diff, '\v\n'))
    endfor
    setlocal readonly
    normal! gg
endfunction  " }}}

let s:kind.action_table.commit = {
    \ 'is_selectable': 1,
    \ 'is_quit': 1
    \ }

function! s:kind.action_table.commit.func(candidates)  " {{{
    let cmd = 'hg commit '
    for candidate in a:candidates
        if candidate.hg__status == '?' || candidate.hg__status == '!'
            let action = unite#util#input('File ' . candidate.action__relpath .
                \ 'is in status "' . candidate.hg__status . '", do you want ' .
                \ 'to add it ? (y/n) : ')
            if action == 'y'
                call system('hg add ' . candidate.action__path)
                let cmd = cmd . candidate.action__path . ' '
            endif
        else
            let cmd = cmd . candidate.action__path . ' '
        endif
    endfor
    let commit_message = unite#util#input('Commit message (empty to abort): ')
    if commit_message == ''
        return
    endif
    call system(cmd . '-m "' . commit_message . '"')
    echo ''
    echo 'Commit done !'
endfunction  " }}}

let s:kind.action_table.shelve = {
    \ 'is_selectable': 1,
    \ 'is_quit': 1
    \ }

function! s:kind.action_table.shelve.func(candidates)  " {{{
    let cmd = 'hg shelve '
    let nbr_of_files = 0
    for candidate in a:candidates
        if candidate.hg__status == '?' || candidate.hg__status == '!'
            let action = unite#util#input('File ' . candidate.action__relpath .
                \ 'is in status "' . candidate.hg__status . '", do you want ' .
                \ 'to add it ? (y/n) : ')
            if action == 'y'
                call system('hg add ' . candidate.action__path)
                let cmd = cmd . candidate.action__path . ' '
                let nbr_of_files = nbr_of_files + 1
            endif
        else
            let cmd = cmd . candidate.action__path . ' '
            let nbr_of_files = nbr_of_files + 1
        endif
    endfor
    call system(cmd)
    echo 'Shelved ' . nbr_of_files . ' file(s) !'
    call unite#start_script([['hg/shelves']],
        \ {'start_insert': 0, 'is_redraw': 1}
        \ )
endfunction  " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
