#!/bin/bash
SCRIPT_PATH="$( cd "$( dirname "$0"  )" && pwd  )"
if [ "$(uname)" == "Darwin" ]; then
    export OS="mac"
elif grep -q Microsoft /proc/version; then
    export OS="wsl1"
elif grep -q microsoft /proc/version; then
    export OS="wsl2"
else
    export OS="linux"
fi
mkdir -p $HOME/.local/bin
cd ~
if [[ $1 = "zsh" ]] ; then
    echo "Install zsh"
    # 安装zsh
    if [ "$OS" = "mac" ]; then
        brew install zsh tmux
    else
        apt install zsh git tmux
        usermod -s /usr/bin/zsh $(whoami)
    fi
    chsh -s /bin/zsh
    # 安装zinit
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
else
    echo "Only install config"
    cp $SCRIPT_PATH/z.sh $HOME/.local/z
fi

# sh
ln -f -s $SCRIPT_PATH/profile $HOME/.profile
# bash
ln -f -s $SCRIPT_PATH/bashrc $HOME/.bashrc
ln -f -s $SCRIPT_PATH/bash_profile $HOME/.bash_profile
ln -f -s $SCRIPT_PATH/bash-prompt.sh $HOME/.bash-prompt.sh
ln -f -s $SCRIPT_PATH/git-prompt.sh $HOME/.git-prompt.sh
# zsh
ln -f -s $SCRIPT_PATH/zshrc $HOME/.zshrc
ln -f -s $SCRIPT_PATH/p10k.zsh $HOME/.p10k.zsh

ln -f -s $SCRIPT_PATH/shconfig.sh $HOME/.shconfig.sh
ln -f -s $SCRIPT_PATH/_display.sh $HOME/.display.sh
ln -f -s $SCRIPT_PATH/gitconfig $HOME/.gitconfig
ln -f -s $SCRIPT_PATH/gitignore_global $HOME/.gitignore_global
# ideavimrc
ln -f -s $SCRIPT_PATH/_ideavimrc $HOME/.ideavimrc

# tmux
ln -f -s $SCRIPT_PATH/tmux.conf $HOME/.tmux.conf

cp $SCRIPT_PATH/localconfig.sh $HOME/.localconfig.sh

ln -f -s $SCRIPT_PATH/_config $HOME/.config
