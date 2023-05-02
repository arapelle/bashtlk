#!/bin/bash

function pass_init
{
    # https://gist.github.com/woods/8970150#file-gen-key-script
    # https://www.gnupg.org/documentation/manuals/gnupg-devel/Unattended-GPG-key-generation.html
    
    gpg_pass_password_present=$(gpg -k pass_password 2> /dev/null)
    if [[ -z $gpg_pass_password_present ]]
    then
    gpg --batch --gen-key << EOF
Key-Type: RSA
Key-Length: 4096
Name-Comment: pass_password
Expire-Date: 0
EOF
    fi
    pass init "pass_password"
}

function pass_export
{
    local export_dir="pass_files"
    mkdir -p $export_dir/gpg
    mkdir -p $export_dir/pass
    gpg --export-secret-keys pass_password > $export_dir/gpg/pass_password.skey
    gpg --export pass_password > $export_dir/gpg/pass_password.key
    cp $HOME/.password-store/.gpg-id $HOME/.password-store/*.gpg $export_dir/pass/
    tar cvzf pass_files.tgz $export_dir
    rm -r $export_dir
}

function pass_import 
{
# https://access.redhat.com/solutions/2115511
    local import_dir="pass_files"
    tar xzvf $1
    gpg --import $import_dir/gpg/pass_password.skey $import_dir/gpg/pass_password.key
    cp $import_dir/pass/.gpg-id $import_dir/pass/*.gpg $HOME/.password-store/
    rm -r $import_dir
}
