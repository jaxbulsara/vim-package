#!/bin/bash
# ~/.vim/pack/install_funcs.sh
# Functions for the package install script.

# The path to the pack directory
package_path="$HOME/.vim/pack"

# Change into the given group's directory.
# Creates the directory if it does not exist.
#
# Arguments:
#   group_name, the directory name for the package group
#
# Examples:
#   Changes into ~/.vim/pack/syntax-highlighting, creating it if necessary.
#       group syntax-highlighting
function group() {
    group_name="$1"
    group_path="$package_path/$group_name"

    mkdir -p "$group_path"
    mkdir -p "$group_path/start"
    mkdir -p "$group_path/opt"

    cd "$group_path" 
    
    echo "Group: $group_name"
}

# Clones or updates a git repo in the current directory
#
# Arguments:
#   git_url, the url to the package's git repository (use https:// addresses)
#   optional, when set to a non-empty string, the package will be installed
#       into the opt/ directory and will need to be loaded manually. Otherwise,
#       the package will will be installed in the start/ directory and will
#       be loaded automatically.
#
# Examples:
#   Clones or pulls the jedi-vim package to ~/.vim/pack/*/jedi-vim, where * is
#   the current group.
#       package https://github.com/davidhalter/jedi-vim.git
function package() {
    git_url=$1
    optional=$2

    # Set the load directory
    if [ $optional ]; then
        load_dir="opt"
    else
        load_dir="start"
    fi

    # Get the package name without the extension
    package_name=$(basename "$git_url" .git)

    # Find where the package is currently installed
    if [ -d "start/$package_name" ]; then
        current_dir="start"
    elif [ -d "opt/$package_name" ]; then
        current_dir="opt"
    else
        current_dir=""
    fi

    # Move the package if necessary
    if [[ $current_dir && "$current_dir" != "$load_dir" ]]; then
        echo "Moving $package_name from $current_dir to $load_dir..."
        mv "$current_dir/$package_name" "$load_dir"
    fi

    # Change into the load directory
    cd "$load_dir"

    # Check if the package directory exists
    if [ -d "$package_name" ]; then
        # Update the repo
        cd "$package_name" || exit

        echo "Updating $package_name..."
        result=$(
            git pull --force &
            git submodule update --init --recursive
        )
        echo "$result"
    else
        # Clone the repo
        echo "Installing $package_name..."
        result=$(git clone --recursive "$git_url")
        echo "$result"
    fi
}

