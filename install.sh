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
        mkdir $HOME/Library/KeyBindings
        ln -f -s $SCRIPT_PATH/DefaultKeyBinding.dict $HOME/Library/KeyBindings/DefaultKeyBinding.dict
    else
        sudo apt install zsh git tmux
        usermod -s /usr/bin/zsh $(whoami)
    fi
    chsh -s /bin/zsh
    # 安装zinit
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
else
    echo "Install fish"
    apt install fish git
    echo /usr/local/bin/fish | sudo tee -a /etc/shells
    chsh -s /usr/local/bin/fish
    git clone --depth=1 https://github.com/Anemone95/myvim.git
    cd myvim && bash ./install.sh
fi

# sh
ln -f -s $SCRIPT_PATH/profile $HOME/.profile
# bash
# ln -f -s $SCRIPT_PATH/bashrc $HOME/.bashrc
# ln -f -s $SCRIPT_PATH/bash_profile $HOME/.bash_profile
# ln -f -s $SCRIPT_PATH/bash-prompt.sh $HOME/.bash-prompt.sh
# ln -f -s $SCRIPT_PATH/git-prompt.sh $HOME/.git-prompt.sh
# zsh
ln -f -s $SCRIPT_PATH/zshrc $HOME/.zshrc
ln -f -s $SCRIPT_PATH/zshrc $HOME/.zprofile
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

rm -rf $HOME/.config
ln -f -s $SCRIPT_PATH/_config $HOME/.config
