" cljrefactor.vim - Clojure Refactoring Support
" Maintainer:  Frazer Irving () 
" Version:      0.1
" GetLatestVimScripts: 9999 1 :AutoInstall: cljrefactor.vim

function <SID>FindUsages()
    lgetex []
    let word = expand('<cword>')
    let symbol = fireplace#info(word)
    let usages = fireplace#message({"op": "find-symbol", "ns": symbol.ns, "name": symbol.name, "dir": ".", "line": symbol.line, "serialize-format": "bencode"})
    for usage in usages
        if !has_key(usage, 'occurrence')
            "echo "Not long enough: "
            "echo usage
            continue
        else
            let occ = usage.occurrence
            let i = 0
            let mymap = {}
            for kv in occ
                if i % 2
                    let mymap[occ[i - 1]] = occ[i]
                endif
                let i = i + 1
            endfor
            let msg = printf('%s:%d:%s', mymap['file'], mymap['line-beg'], mymap['col-beg'])
            laddex msg
        endif
    endfor
endfunction

function <SID>ArtifactList()
    let artifacts = fireplace#message({"op": "artifact-list"})
    echo artifacts
endfunction

function <SID>CleanNs()
    let filename = expand("%:p")
    echo 'the file:' . filename
    let cleaned = fireplace#message({"op": "clean-ns", "path": filename})
    echo cleaned
endfunction



nmap <silent> cru :call <SID>FindUsages()<CR>
nmap <silent> cral :call <SID>ArtifactList()<CR>
nmap <silent> crc :call <SID>CleanNs()<CR>

