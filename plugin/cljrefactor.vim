" cljrefactor.vim - Clojure Refactoring Support
" Maintainer:   Renzo Borgatti <http://reborg.net/>
" Version:      0.1
" GetLatestVimScripts: 9999 1 :AutoInstall: cljrefactor.vim

if exists("g:loaded_cljrefactor") || v:version < 700 || &cp
  finish
endif
let g:loaded_cljrefactor = 1

" Section: File type

augroup cljrefactor_file_type
  autocmd!
  autocmd BufNewFile,BufReadPost *.clj setfiletype clojure
augroup END

" Section: refactoring

function! s:RefactorRename(bang, ...) abort
  "echo "my funky fun: " . a:1 ." args."
  let expr = fireplace#message({"op": "refactor", "refactor-fn": "find-symbol", "ns": "clojure.core", "name": "juxt"})
  echo expr
endfunction

function! s:set_up_refactoring() abort
  command! -buffer -bang -nargs=* RefactorRename
        \ call s:RefactorRename(<bang>0, <f-args>)
endfunction

augroup cljrefactor_refactoring
  autocmd!
  autocmd FileType clojure call s:set_up_refactoring()
augroup END
