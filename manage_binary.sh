#!/bin/bash

# 配置
BINARY_PATH="/root/manage_binary.sh"
REMOTE_URL="https://raw.githubusercontent.com/tmxk2020/binary-manager/main/manage_binary.sh"
PID_FILE="/var/run/mybinary.pid"

# 下载并赋权
download_and_run() {
    echo "正在下载二进制文件..."
    curl -o "$BINARY_PATH" "$REMOTE_URL"
    if [ $? -ne 0 ]; then
        echo "下载失败，请检查 URL 或网络连接。"
        exit 1
    fi
    echo "文件下载完成，正在去除 Windows 换行符..."
    sed -i 's/\r$//' "$BINARY_PATH"
    chmod +x "$BINARY_PATH"
    echo "赋予执行权限完成！"
    nohup "$BINARY_PATH" > /dev/null 2>&1 &
    echo $! > "$PID_FILE"
    echo "二进制文件已启动，PID: $(cat "$PID_FILE")"
}

# 启动、停止、状态等函数
start() {
    download_and_run
}

stop() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill "$PID" > /dev/null 2>&1; then
            echo "二进制文件已成功停止。"
        else
            echo "停止失败，进程可能不存在。"
        fi
        rm -f "$PID_FILE"
    else
        echo "没有运行中的进程。"
    fi
}

status() {
    if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" > /dev/null 2>&1; then
        echo "二进制文件正在运行，PID: $(cat "$PID_FILE")"
    else
        echo "二进制文件未运行。"
    fi
}

# 脚本执行选择
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    *)
        echo "使用方法：$0 {start|stop|status}"
        ;;
esac
