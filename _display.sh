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
# add WSL display
if [[ $OS = "wsl1" ]]; then
    export DISPLAY=localhost:0.0
    export DOCKER_HOST=tcp://127.0.0.1:2376 DOCKER_TLS_VERIFY=1
elif [[ $OS = "wsl2" ]]; then
    export WIN_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
    export DISPLAY=$WIN_HOST:0
    sed -i "s/socks5.*1089/socks5 ${WIN_HOST} 1089/g" /etc/proxychains4.conf
fi

# fcitx on wsl
if [[ $OS =~ "wsl" ]]; then
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
    export DefaultIMModule=fcitx
    if [[ ! "$(ps -ef |grep fcitx)" =~\
        "usr/bin/fcitx" ]]
    then
        fcitx-autostart>/var/log/fcitx/fcitx.log 2>&1
    fi
fi
export PATH=/root/.local/node_v14/bin:$PATH

