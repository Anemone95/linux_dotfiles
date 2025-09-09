#!/usr/bin/env bash
###############################################################################
# 连续运行 borders 命令；若进程退出则自动重启。
# 终端内 Ctrl-C / kill -INT/-TERM 可安全终止本脚本。
# pgrep -af borders | awk '{print $1}' | xargs -r kill -TERM
###############################################################################

#———— 可调节参数 ————#
sleep_interval=1                    # 两次启动间隔秒数
cmd=(borders active_color=0xffedafb8 width=10)   # 命令本体（数组写法更安全）

#———— 信号处理：让脚本可被优雅停止 ————#
trap 'echo -e "\n[INFO] 接收到终止信号，脚本退出。"; exit 0' INT TERM

if pgrep -af 'borders active_color=0xffedafb8 width=10' | grep -v "$$" > /dev/null; then
    echo "[INFO] 已有 borders 实例在运行，当前脚本退出。"
    exit 0
fi

#———— 主循环 ————#
while true; do
    if pgrep -af 'borders.sh' | grep -v "$$" > /dev/null; then
        echo "[INFO] 已有 borders 实例在运行，当前脚本退出。"
        exit 0
    fi
    "${cmd[@]}"                     # 启动 borders
    exit_code=$?                    # 捕获退出码
    printf '[WARN] %(%F %T)T borders 已退出（代码 %d），%ds 后重启…\n' -1 "$exit_code" "$sleep_interval" >&2
    sleep "$sleep_interval"
done
