#! /bin/bash
# To run shell script: 1/ chmod +x config.sh 2/ ./config.sh

DOTFILES=(.bash_profile .gitconfig .gitignore .zshrc .p10k.zsh)

for dotfile in $(echo ${DOTFILES[*]});
do
    [[ -f ~/dotfiles/$dotfile ]] && cp ~/dotfiles/$dotfile ~/$dotfile
done