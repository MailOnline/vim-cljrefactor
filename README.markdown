# cljrefactor.vim

Preliminary support, learning on the go.

## Installation

First, set up [cider-nrepl](https://github.com/clojure-emacs/cider-nrepl) and [vim-fireplace](https://github.com/tpope/vim-fireplace) following their respective
installation notes. As indicated in fireplace, cljrefactor.vim doesn't provide
indenting or syntax highlighting, so you'll want [a set of Clojure runtime
files](https://github.com/guns/vim-clojure-static) if you're on a version of
Vim earlier than 7.4.  You might also want [leiningen.vim](https://github.com/tpope/vim-leiningen) 
for assorted static project support.

If you don't have a preferred installation method, I recommend
installing [vundle.vim](https://github.com/gmarik/Vundle.vim)
then simply add:

Plugin 'reborg/vim-cljrefactor'

Once help tags have been generated, you can view the manual with `:help cljrefactor`.

## Features

## License

Copyright © Reborg (Renzo Borgatti). Distributed under the same terms as Vim itself.
See `:help license`.
