#!/bin/bash

# 配置
BINARY_PATH="/tmp/allinone_linux_arm"
REMOTE_URL="http://138.2.50.24:40033/api/v3/file/download/WqglhL2iKjHwEG2E?sign=NNGEw0KUApdGjuzfey36UVsetuY0Lz9LzUkzO3nU90I%3D%3A1733215996"
PID_FILE="/var/run/mybinary.pid"

# 函数：安装脚本
install_script() {
    echo "正在下载并安装脚本..."
    wget -O "$BINARY_PATH" "$REMOTE_URL"
    if [ $? -ne 0 ]; then
        echo "下载失败，请检查 URL 或网络连接。"
        exit 1
    fi
    chmod +x "$BINARY_PATH"
    echo "脚本安装成功。"
}

# 函数：启动程序
start() {
    echo "启动程序..."
    nohup "$BINARY_PATH" > /dev/null 2>&1 &
    echo $! > "$PID_FILE"
    echo "程序已启动，PID：$(cat "$PID_FILE")"
}

# 函数：停止程序
stop() {
    echo "停止程序..."
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill "$PID" > /dev/null 2>&1; then
            echo "程序已成功停止。"
        else
            echo "停止失败，进程可能不存在。"
        fi
        rm -f "$PID_FILE"
    else
        echo "未找到正在运行的程序。"
    fi
}

# 函数：查看程序状态
status() {
    if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" > /dev/null 2>&1; then
        echo "程序正在运行，PID：$(cat "$PID_FILE")"
    else
        echo "程序未运行。"
    fi
}

# 函数：更新脚本
update_script() {
    echo "正在更新脚本..."
    wget -O "$BINARY_PATH" "$REMOTE_URL"
    if [ $? -ne 0 ]; then
        echo "更新失败，请检查 URL 或网络连接。"
        exit 1
    fi
    chmod +x "$BINARY_PATH"
    echo "脚本更新成功。"
}

# 函数：退出脚本
exit_script() {
    echo "退出脚本。"
    exit 0
}

# 用户提示
echo "欢迎使用脚本管理工具！请选择操作："
echo "1. 安装脚本"
echo "2. 启动程序"
echo "3. 停止程序"
echo "4. 查看程序状态"
echo "5. 更新脚本"
echo "6. 退出"

# 读取用户输入
read -p "请输入操作编号 (1-6): " choice

# 根据用户输入执行相应操作
case "$choice" in
    1)
        install_script
        ;;
    2)
        start
        ;;
    3)
        stop
        ;;
    4)
        status
        ;;
    5)
        update_script
        ;;
    6)
        exit_script
        ;;
    *)
        echo "无效的选择，请输入 1 到 6 之间的数字。"
        ;;
esac
