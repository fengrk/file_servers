#!/bin/bash

clearGithub(){
    read -p "input file name you want to delete:  " dst
    git_cmd="git rm --cached --ignore-unmatch ${dst}"

    while true; do
        read -p "Do you wish to clear ${dst} in github?  " yn
        case $yn in
            [Yy]* ) cd ./playground && git filter-branch --force --index-filter "${git_cmd}" --prune-empty --tag-name-filter cat -- --all && git push origin --force --all;break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

while true; do
    echo "1) clear file in github.com"
    echo "x) exit"

    read -p "input your choice>>  " choice
    case $choice in
        [1]* ) clearGithub;break;;
        [xX]* ) exit;;
        * ) echo "Please input your choice number.";;
    esac
done
