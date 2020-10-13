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
    if [ "$OS" = "linux" ]; then
        apt install zsh git tmux
        usermod -s /usr/bin/zsh $(whoami)
    else
        brew install zsh tmux
    fi
    chsh -s /bin/zsh
    # 安装zinit
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
else
    echo "Only install config"
    git clone https://github.com/rupa/z.git $HOME/.local/z
fi

# sh
ln -f -s $SCRIPT_PATH/profile $HOME/.profile
# bash
ln -f -s $SCRIPT_PATH/bashrc $HOME/.bashrc
ln -f -s $SCRIPT_PATH/bash_profile $HOME/.bash_profile
ln -f -s $SCRIPT_PATH/bash-prompt.sh $HOME/.bash-prompt.sh
# zsh
ln -f -s $SCRIPT_PATH/zshrc $HOME/.zshrc
ln -f -s $SCRIPT_PATH/p10k.zsh $HOME/.p10k.zsh

ln -f -s $SCRIPT_PATH/shconfig.sh $HOME/.shconfig.sh
ln -f -s $SCRIPT_PATH/gitconfig $HOME/.gitconfig
ln -f -s $SCRIPT_PATH/gitignore_global $HOME/.gitignore_global

# tmux
ln -f -s $SCRIPT_PATH/tmux.conf $HOME/.tmux.conf

cp $SCRIPT_PATH/localconfig.sh $HOME/.localconfig.sh

if [ $OS = "mac" ]; then
    ln -f -s $SCRIPT_PATH/mac_config $HOME/.config
fi

if [ ! -e $HOME/.ssh ];then
    cp $SCRIPT_PATH/ssh $HOME/.ssh
    echo "Use 'ssh-keygen -t rsa -C \"anemone@xxxx\"' to generate a pair"
    chmod 600 ~/.ssh/*
fi

