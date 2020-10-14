#!/bin/bash
if [[ $(uname) = "Darwin" ]]; then
    export OS="OSX"
elif grep -q Microsoft /proc/version; then
    export OS="wsl1"
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
elif grep -q microsoft /proc/version; then
    export OS="wsl2"
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
    export OS="linux"
fi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# alias
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias ll='ls -al --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    alias ll='ls -al'
fi

# ~/.local/bin;~/bin
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Miniconda2
if [ -d "$HOME/miniconda2" ] ; then
    . $HOME/miniconda2/etc/profile.d/conda.sh
fi
if [ -d "$HOME/miniconda3" ] ; then
    . $HOME/miniconda3/etc/profile.d/conda.sh
fi
if [ -d "$HOME/anaconda2" ] ; then
    . $HOME/anaconda2/etc/profile.d/conda.sh
fi
if [ -d "$HOME/anaconda3" ] ; then
    . $HOME/anaconda3/etc/profile.d/conda.sh
fi

# add WSL display
if [[ $OS = "wsl1" ]]; then
    export DISPLAY=localhost:0.0
    export DOCKER_HOST=tcp://127.0.0.1:2376 DOCKER_TLS_VERIFY=1
elif [[ $OS = "wsl2" ]]; then
    export WIN_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
    export DISPLAY=$WIN_HOST:0
    # sed -i "s/socks5.*1080/socks5 ${WIN_HOST} 1080/g" /etc/proxychains.conf
fi

if [[ $OS = "OSX" ]]; then
    export JAVA_8_HOME="$(/usr/libexec/java_home -v 1.8)"
    export JAVA_11_HOME="$(/usr/libexec/java_home -v 11)"

    alias jdk8='export JAVA_HOME=$JAVA_8_HOME'
    alias jdk11='export JAVA_HOME=$JAVA_11_HOME'

    # 默认使用JDK8
    export JAVA_HOME=$JAVA_8_HOME
    export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
fi

source $HOME/.localconfig.sh

# tmux
alias sp="tmux splitw -v"
alias vs="tmux splitw -h"
alias tt="tmux attach -t TMUX || tmux new -s TMUX"

if command -v tmux >/dev/null 2>&1; then
    should_start_tmux=0
    if [ -z "$TMUX" ]; then
        should_start_tmux=1
    fi
    if [[ "$(ps $PPID -o command|sed -n '2p')" =~\
        "(emacs|Vim|vim|idea|webstorm|pycharm)" ]]
    then
        should_start_tmux=0
    fi

    echo "$should_start_tmux"
    if (( $should_start_tmux )); then
        tmux
        # tmux attach -t TMUX || tmux new -s TMUX
    fi
fi
