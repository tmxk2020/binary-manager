#!/bin/bash

# 配置
BINARY_PATH="/tmp/allinone_linux_arm"
REMOTE_URL="http://138.2.50.24:40033/api/v3/file/download/WqglhL2iKjHwEG2E?sign=NNGEw0KUApdGjuzfey36UVsetuY0Lz9LzUkzO3nU90I%3D%3A1733215996"  # 替换为你的 Alist 文件直链
PID_FILE="/var/run/mybinary.pid"

start() {
    echo "Starting binary..."
    wget -O "$BINARY_PATH" "$REMOTE_URL"
    if [ $? -ne 0 ]; then
        echo "Failed to download the file. Check your URL or network."
        exit 1
    fi
    chmod +x "$BINARY_PATH"
    nohup "$BINARY_PATH" > /dev/null 2>&1 &
    echo $! > "$PID_FILE"
    echo "Binary started with PID $(cat "$PID_FILE")."
}

stop() {
    echo "Stopping binary..."
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill "$PID" > /dev/null 2>&1; then
            echo "Binary stopped successfully."
        else
            echo "Failed to stop binary. Process may not exist."
        fi
        rm -f "$PID_FILE"
    else
        echo "No running binary found."
    fi
}

status() {
    if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" > /dev/null 2>&1; then
        echo "Binary is running with PID $(cat "$PID_FILE")."
    else
        echo "Binary is not running."
    fi
}

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
    restart)
        stop
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart}"
        ;;
esac
