#!/bin/bash

function git_config_global_info()
{
    # https://git-scm.com/book/fr/v2/D%C3%A9marrage-rapide-Param%C3%A9trage-%C3%A0-la-premi%C3%A8re-utilisation-de-Git
    [[ -f ~/.gitconfig ]] && "ERROR: A gitconfig file already exists (cf. ~/.gitconfig)." && return -1
    local username=""
    local email=""
    read -e -p "user name: " -i $USER username
    read -p "user email: " email
    git config --global user.name "$username"
    git config --global user.email "$email"
    git config --global core.editor micro
    git config --global init.defaultBranch main
    echo -e "\ngitconfig file:"
    git config --list
}

function git_config_global_aliases()
{
    git config --global alias.logt "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
    git config --global alias.sclean "submodule foreach --recursive git clean -dffx" # https://gist.github.com/nicktoumpelis/11214362
    git config --global alias.supdate "submodule update --init --recursive --remote"
    git config --global alias.toplevel-dir "rev-parse --show-toplevel"
    echo -e "\ngitconfig file:"
    git config --list
}
