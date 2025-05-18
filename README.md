# 哪吒 Magisk 模块介绍

> 💡 本模块由 ChatGPT 协助生成，旨在将 [哪吒监控客户端（nezha-agent）](https://github.com/nezhahq/agent) 通过 Magisk 模块形式集成进 Android 系统，实现无系统权限下的持久运行。
> 
> ⚠️ 模块内预置的 `nezha-agent` 为 **ARM64 架构**，如您的设备为 **ARM (32位)** 或 **x86 架构**，请自行从官方仓库下载对应版本并替换模块中的可执行文件。

## ✅ 使用方法

1. 下载 `module.zip`；
2. 修改模块中的 `/bin/config.yml` 配置文件，填写你的探针信息；
3. 使用 Magisk App 刷入该模块；
4. 重启后自动运行，无需手动启动。

## 🖥️ 探针效果展示

![效果展示](./effect.jpg) <!-- 请确保图片在仓库的根目录下 -->

## 🔧 脚本逻辑说明

模块使用了两个核心脚本，分别在不同阶段自动执行：

### 🧩 `post-fs-data.sh`（系统早期阶段执行）
- 自动创建合并系统证书文件 `cacerts.pem`，供 `nezha-agent` 使用 TLS 连接。
- 首次启动时执行一次，防止重复写入，提高性能。
- 赋予 `nezha-agent` 执行权限，确保后续启动无权限问题。

### 🛡️ `service.sh`（系统开机后持续守护）
- 启动前自动检测网络连接（ping 3 次判断），避免在无网络状态下启动 agent。
- 设置环境变量 `SSL_CERT_FILE` 指向合并证书，解决 HTTPS 连接报错问题。
- 使用 `wake_lock` 防止设备休眠，保证 `nezha-agent` 持续在线。
- 实现重启守护逻辑：
  - 每次 agent 异常退出后自动重启；
  - 连续失败最多重试 5 次，之后延迟 10 分钟再尝试，防止系统资源浪费。

## 📁 文件结构

```text
/
├── bin/
│   ├── nezha-agent       # 可执行文件
│   └── config.yml        # 探针配置文件（需手动修改）
├── service.sh            # 后台守护进程脚本
└── post-fs-data.sh       # 系统早期初始化脚本
```

---
