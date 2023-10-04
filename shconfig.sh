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
    alias ls='ls --color=always'
    alias ll='ls -al --color=always'
    alias dir='dir --color=always'
    alias vdir='vdir --color=always'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
    alias ack="ack --color"
elif [[ $OS = "OSX" ]]; then
    alias ll='ls -al'
    alias dir='dir --color=always'
    alias vdir='vdir --color=always'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
    alias ack="ack --color"
else
    alias ll='ls -al'
fi
alias less="less -r"

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
if [[ $OS =~ "wsl" ]]; then
    source $HOME/.display.sh
fi

if [[ $OS = "OSX" ]]; then
    if command -v /usr/libexec/java_home >/dev/null 2>&1; then
        export JAVA_8_HOME="$(/usr/libexec/java_home -v 1.8)"
        export JAVA_11_HOME="$(/usr/libexec/java_home -v 11)"

        alias jdk8='export JAVA_HOME=$JAVA_8_HOME'
        alias jdk11='export JAVA_HOME=$JAVA_11_HOME'

        # 默认使用JDK8
        export JAVA_HOME=$JAVA_8_HOME
        # export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

source $HOME/.localconfig.sh

# tmux
alias sp="tmux splitw -v"
alias vs="tmux splitw -h"
alias tt="tmux attach -t TMUX || tmux new -s TMUX"

if command -v tmux >/dev/null 2>&1; then
    should_start_tmux=0
    setted=0

    if [ $TMUX ]; then
        should_start_tmux=0
        setted=1
    elif [[ $OS = "wsl1" ]]; then
        should_start_tmux=0
        setted=1
    elif [[ $OS = "wsl2" ]]; then
        idea=`/mnt/c/Windows/System32/cmd.exe /C echo "%idea%"`
        if [[ $idea =~ "true" ]]; then
            should_start_tmux=0
            setted=1
        else
            should_start_tmux=1
            setted=1
        fi
    fi
    if [[ "$(ps -o command $PPID |sed -n '2p')" =~\
        "(emacs|tmux)" ]]
    then
        should_start_tmux=0
        setted=1
    fi
    if [ "$TERMINAL_EMULATOR" = "JetBrains-JediTerm" ]; then
        should_start_tmux=0
        setted=1
    fi

    if [ -z "$TMUX" ]; then
        if (( $setted == 0 )); then
            export setted;
            should_start_tmux=1
        fi
    fi


    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        should_start_tmux=0
    else
      case $(ps -o comm= -p $PPID) in
        sshd|*/sshd) should_start_tmux=0;;
      esac
    fi

    if [[ $(who am i) =~ \([-a-zA-Z0-9\.]+\)$ ]] ; then should_start_tmux=0; fi

    if (( $should_start_tmux )); then
        tmux
    fi
fi

# ssh keep alive
export ServerAliveInterval=120
export ServerAliveCountMax=3

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
        ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock;
    fi
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock;
fi
