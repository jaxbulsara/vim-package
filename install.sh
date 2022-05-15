#!/bin/bash
# ~/.vim/pack/install.sh
# Updates and installs vim 8+ packages

source functions.sh

# Package configuration
# use (* & wait) & structure to execute each group in a subshell.

# User Interface
(
    group user-interface
    package https://github.com/preservim/nerdtree.git &
    wait
) &

wait

# Python
(
    group python
    package https://github.com/davidhalter/jedi-vim.git &
    wait
) &

wait

