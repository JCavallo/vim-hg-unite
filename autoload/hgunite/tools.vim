" #############################################################################
" File: autoload/hgunite/tools.vim
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

function! hgunite#tools#get_repo_root(...) "{{{
    if a:0
        let output = system('cd ' . a:1 . ';hg root')[:-2]
        call system('cd -')
    else
        let output = system('hg root')[:-2]
    endif
    if output !~ '^abort: no repository found'
        return output
    endif
    for buf_nr in range(1, bufnr('$'))
        let name = bufname(buf_nr)
        if name != ''
            let output = system('cd ' . fnamemodify(name, ':p:h') . ';hg root')[:-2]
            call system('cd -')
            if output !~ '^abort: no repository found'
                return output
            endif
        endif
    endfor
    echoerr 'No repository found'
    return ''
endfunction  " }}}

function! hgunite#tools#get_named_window(name) "{{{
    let winnr = bufwinnr('^' . a:name . '$')
    if (winnr >=  0)
        execute winnr . 'wincmd w'
        return 1
    else
        return ''
    endif
endfunction  " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
