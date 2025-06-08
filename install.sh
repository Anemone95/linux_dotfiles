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
for file in "$SCRIPT_PATH/sbin"/*; do
    # 检查是否是文件
    if [[ -f "$file" ]]; then
        # 获取文件名
        filename=$(basename -- "$file")
        # 创建到目录B的软链接
        ln -sf $file ~/.local/bin/$filename
    fi
done

cd ~
if [[ $1 = "zsh" ]] ; then
    echo "Install zsh"
    # 安装zsh
    if [ "$OS" = "mac" ]; then
        brew install zsh tmux
        mkdir $HOME/Library/KeyBindings
        ln -f -s $SCRIPT_PATH/DefaultKeyBinding.dict $HOME/Library/KeyBindings/DefaultKeyBinding.dict
    else
        sudo apt install -y zsh git tmux
        
        current_user=$(whoami)

        echo "Changing default to zsh"
        usermod -s /usr/bin/zsh $current_user 2>/dev/null

        if [[ $? -ne 0 ]]; then
            echo "Failed, Attempting to run command with sudo..."
            sudo usermod -s /usr/bin/zsh $current_user
        fi

        if [[ $? -eq 0 ]]; then
            echo "Successfully changed the shell for $current_user to /usr/bin/zsh."
        else
            echo "Failed to change the shell. Please check your permissions or contact your system administrator."
        fi
    fi
    chsh -s /bin/zsh
    # 安装zinit
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    compaudit | xargs chmod g-w
    ln -f -s $SCRIPT_PATH/zshrc $HOME/.zshrc
    ln -f -s $SCRIPT_PATH/zshrc $HOME/.zprofile
    ln -f -s $SCRIPT_PATH/p10k.zsh $HOME/.p10k.zsh

elif [[ $1 = "bash" ]] ; then
    mv $HOME/.bashrc .bashrc.bk
    mv $HOME/.bash_profile .bash_profile.bk
    ln -f -s $SCRIPT_PATH/bashrc $HOME/.bashrc
    ln -f -s $SCRIPT_PATH/bash_profile $HOME/.bash_profile
    ln -f -s $SCRIPT_PATH/bash-prompt.sh $HOME/.bash-prompt.sh
    ln -f -s $SCRIPT_PATH/git-prompt.sh $HOME/.git-prompt.sh
    ln -f -s $SCRIPT_PATH/z.sh $HOME/.local/.z
else
    echo "Install fish"
    sudo apt install fish git
    echo /usr/bin/fish | sudo tee -a /etc/shells
    chsh -s /usr/bin/fish
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    fish -c "fisher install jethrokuan/z"
    fish -c "fisher install pure-fish/pure"

fi

mv $SCRIPT_PATH/profile $HOME/.profile
# sh
ln -f -s $SCRIPT_PATH/profile $HOME/.profile

ln -f -s $SCRIPT_PATH/shconfig.sh $HOME/.shconfig.sh
ln -f -s $SCRIPT_PATH/_display.sh $HOME/.display.sh
ln -f -s $SCRIPT_PATH/gitconfig $HOME/.gitconfig
ln -f -s $SCRIPT_PATH/gitignore_global $HOME/.gitignore_global
# ideavimrc
ln -f -s $SCRIPT_PATH/_ideavimrc $HOME/.ideavimrc

# tmux
ln -f -s $SCRIPT_PATH/tmux.conf $HOME/.tmux.conf

# aerospace
ln -f $SCRIPT_PATH/aerospace.toml $HOME/.aerospace.toml

cp $SCRIPT_PATH/localconfig.sh $HOME/.localconfig.sh

rm -rf $HOME/.config
ln -f -s $SCRIPT_PATH/_config $HOME/.config

git clone --depth=1 https://github.com/Anemone95/myvim.git
cd myvim && bash ./install.sh
