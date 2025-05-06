#!/system/bin/sh

MODDIR=${0%/*}
AGENT="$MODDIR/bin/nezha-agent"

# 如果 nezha-agent 没有执行权限，则添加
if [ ! -x "$AGENT" ]; then
    chmod +x "$AGENT"
fi

# 启动 nezha-agent 并保持运行，防止崩溃退出
while true; do
    # 直接启动 nezha-agent，输出重定向到 /dev/null
    $AGENT &>/dev/null &
    wait $!
    sleep 30  # 等待 30 秒钟后重启程序，防止进程崩溃后马上重启
done
