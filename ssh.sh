#!/bin/bash

function ssh_generate_key()
{
    # https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
    git_email=$(git config user.email)
    local email=""
    read -e -p "email: " -i $git_email email
    local passphrase=""
    local passphrase2="?"
    while true
    do
        while true
        do
            read -s -p "passphrase: " passphrase
            echo
            [[ -z "$passphrase" ]] && echo "  Passphrase cannot be empty." && continue
            break
        done
        read -s -p "passphrase again: " passphrase2
        echo
        [[ "$passphrase" != "$passphrase2" ]] && echo "  Passphrases does not match." && continue
        break
    done
    local file_path="$HOME/.ssh/key_"
    read -e -p "private key file path: " -i "$file_path" file_path
    [[ -f $file_path ]] && "ERROR: Key file '$file_path' already exists." && return -1
    ssh-keygen -t ed25519 -C "$email" -P $passphrase -f $file_path
    eval "$(ssh-agent -s)"
    ssh-add $file_path
    echo "Do no forget to add the public key to your Github account."
}

function ssh_generate_pass_key()
{
    # https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
    # Using sed to remove pass output colors: https://superuser.com/questions/380772/removing-ansi-color-codes-from-text-stream
    git_email=$(git config user.email)
    local email=""
    read -e -p "email: " -i $git_email email
    local file_path="$HOME/.ssh/pass_key_"
    read -e -p "private key file path: " -i "$file_path" file_path
    # [[ -f $file_path ]] && echo "ERROR: Key file '$file_path' already exists." && return -1
    local file_name="${file_path##*/}"
    local passphrase="$(pass generate -n $file_name 256 |sed -e 's/\x1b\[[0-9;]*m//g'|cut -d' ' -f7)"
    passphrase="`echo -n $passphrase`"
    #local passphrase="$(pass show $file_name)"
    #pass rm -f $file_name
    ssh-keygen -t ed25519 -C "$email" -P $passphrase -f $file_path
    echo "Do no forget to add the public key to your Github/Gitlab/... account."
}

function ssh_load_pass_key()
{
    eval "$(ssh-agent -s)"
    key_file=$1
    if [[ -f "$key_file" ]]
    then
        local key_file_name="${key_file##*/}"
        local passphrase="$(pass show $key_file_name)"
        expect << EOF
spawn ssh-add $key_file
expect "Enter passphrase"
send "$passphrase\r"
expect eof
EOF
    fi
}

function ssh_cclip_pass_key()
{
    key_file=$1
    if [[ -f "$key_file" ]]
    then
        local key_file_name="${key_file##*/}"
        pass show $key_file_name | cclip
    else
        echofmt "{red} ERROR: File does not exist: $key_file."
    fi
}

function ssh_load_pass_keys()
{
    eval "$(ssh-agent -s)"
    for key_file in $HOME/.ssh/key_* $HOME/.ssh/pass_key_*
    do
        if [[ ! -f "$key_file" ]]
        then
            continue
        fi
        str="`echo $key_file | grep '\.pub'`"
        if [[ -z "$str" ]]
        then
            local key_file_name="${key_file##*/}"
            local passphrase="$(pass show $key_file_name)"
            expect << EOF
spawn ssh-add $key_file
expect "Enter passphrase"
send "$passphrase\r"
expect eof
EOF
        fi
    done
}

function ssh_unload_keys()
{
    eval "$(ssh-agent -k)"
}

function ssh_delete_keys()
{
    for key in $*
    do
        pass rm -f $key
        rm $HOME/.ssh/${key}*
    done
}
