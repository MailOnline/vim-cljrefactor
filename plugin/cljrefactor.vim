" cljrefactor.vim - Clojure Refactoring Support
" Maintainer:  Frazer Irving ()
" Version:      0.1
" GetLatestVimScripts: 9999 1 :AutoInstall: cljrefactor.vim

function <SID>FindUsages()
  cgetex []
  let word = expand('<cword>')
  let symbol = fireplace#info(word)
  let usages = fireplace#message({"op": "find-symbol", "ns": symbol.ns, "name": symbol.name, "dir": ".", "line": symbol.line, "serialization-format": "bencode", "file": expand('%:p'), "column": col('.')}, v:t_list)
  echo usages
  for usage in usages
    if has_key(usage, 'err')
      echoerr usage.err
      continue
    elseif !has_key(usage, 'occurrence')
      "echo "Not long enough: "
      "echo usage
      continue
    else
      let occ = usage.occurrence
      let msg = printf('%s:%d:%s', occ['file'], occ['line-beg'], occ['col-beg'])
      caddex msg
    endif
  endfor
  copen
endfunction

function <SID>ExtractFunction()
  lgetex []
  let word = expand('<cword>')
  let symbol = fireplace#info(word)
  let unbound = fireplace#message({"op": "find-unbound", "file": @%, "line": line('.'), "column": virtcol('.'), "serialization-format": "bencode"})
  echo unbound

  let foo = <SID>GetCompleteContext()
  echo foo
endfunction

function <SID>ArtifactList()
  let artifacts = fireplace#message({"op": "artifact-list"})
  echo artifacts
endfunction

function! s:paste(text) abort
  " Does charwise paste to current '[ and '] marks
  let @@ = a:text
  let reg_type = getregtype('@@')
  call setreg('@@', getreg('@@'), 'v')
  silent exe "normal! `[v`]p"
  call setreg('@@', getreg('@@'), reg_type)"
endfunction


function! <SID>CleanNs()

  let p = expand('%:p')
  normal! ggw

  let [line1, col1] = searchpairpos('(', '', ')', 'bc')
  let [line2, col2] = searchpairpos('(', '', ')', 'n')

  while col1 > 1 && getline(line1)[col1-2] =~# '[#''`~@]'
    let col1 -= 1
  endwhile
  call setpos("'[", [0, line1, col1, 0])
  call setpos("']", [0, line2, col2, 0])

  if expand('<cword>') ==? 'ns'
    let res = fireplace#message({ 'op': 'clean-ns', 'path': p, 'prefix-rewriting': 'false', 'ignore-paths':  '[#"lifecycle", #"dev"]' }, v:t_list)
    let new_ns = get(res[0], 'ns')
    if type(new_ns) == type("")
      call s:paste(substitute(new_ns, '\n$', '', ''))
      silent exe "normal! `[v`]=="
    endif
  endif
endfunction

let fireplace#skip = 'synIDattr(synID(line("."),col("."),1),"name") =~? "comment\\|string\\|char\\|regexp"'

function! <SID>GetCompleteContext() abort
  " Find toplevel form
  " If cursor is on start parenthesis we don't want to find the form
  " If cursor is on end parenthesis we want to find the form
  let [line1, col1] = searchpairpos('(', '', ')', 'Wrnb', g:fireplace#skip)
  let [line2, col2] = searchpairpos('(', '', ')', 'Wrnc', g:fireplace#skip)

  echo line1
  echo col1
  echo line2
  echo col2

  if (line1 == 0 && col1 == 0) || (line2 == 0 && col2 == 0)
    return ""
  endif

  if line1 == line2
    let expr = getline(line1)[col1-1 : col2-1]
  else
    let expr = getline(line1)[col1-1 : -1] . ' '
          \ . join(getline(line1+1, line2-1), ' ')
          \ . getline(line2)[0 : col2-1]
  endif

  " Calculate the position of cursor inside the expr
  if line1 == line('.')
    let p = col('.') - col1
  else
    let p = strlen(getline(line1)[col1-1 : -1])
          \ + strlen(join(getline(line1 + 1, line('.') - 1), ' '))
          \ + col('.')
  endif
  echo p

  return strpart(expr, 0, p) . '__prefix__' . strpart(expr, p)
endfunction


command! -nargs=0 ExtractFunction call <SID>ExtractFunction()
nmap <silent> cru :call <SID>FindUsages()<CR>
nmap <silent> cral :call <SID>ArtifactList()<CR>
nmap <silent> crc :call <SID>CleanNs()<CR>


