# Minecraft Deceased Craft Server

## 简述

我的世界亡者世界整合包服务器

**可用版本：**

| 版本 | 镜像 tag |
| --- | --- |
| 最新正式版 | `latest` |

## 最新正式版

### 资源占用信息

#### 端口

| 端口号 | 协议 | 说明 |
| --- | --- | --- |
| 25565 | TCP | 游戏联机端口 |
| 25575 | TCP | RCON 端口 |

#### 持久卷

| 宿主路径 | 容器路径 | 说明 |
| --- | --- | --- |
| `./minecraft-deceased-craft-World` | `/app/World` | 游戏世界存档 |

#### 环境变量

| 变量名 | 必填 | 说明 |
| --- | --- | --- |
| `JVM_MEMORY` | 否 | JVM 堆内存大小（同时作用于 -Xms/-Xmx），如 4G、2500M |
| `JVM_AUTHLIB_INJECTOR_URL` | 否 | 外置登录（authlib-injector）Yggdrasil API 地址，置空则跳过外置登录 |
| `GAME_MAX_PLAYERS` | 否 | 服务器列表显示的玩家容量，达到上限后新玩家无法加入 |
| `GAME_ONLINE_MODE` | 否 | 是否启用在线验证模式：true=开启，false=关闭 |
| `GAME_ENABLE_RCON` | 否 | 是否启用 RCON |
| `GAME_RCON_PASSWORD` | 否 | RCON 口令 |

### 构建与运行

#### 构建并运行（Docker）

```bash
docker build -t minecraft-deceased-craft:temp . && \
    docker run --rm -it \
        -e JVM_MEMORY=16G \
        -e JVM_AUTHLIB_INJECTOR_URL=your_jvm_authlib_injector_url \
        -e GAME_MAX_PLAYERS=8 \
        -e GAME_ONLINE_MODE=true \
        -e GAME_ENABLE_RCON=false \
        -e GAME_RCON_PASSWORD=your_game_rcon_password \
        -p 25565:25565/tcp \
        -p 25575:25575/tcp \
        -v ./minecraft-deceased-craft-World:/app/World \
        minecraft-deceased-craft:temp
```

#### 运行服务器（Podman）

```bash
IMAGE=ghcr.io/hm-gamesrv/minecraft-deceased-craft:latest

if ! podman pull "$IMAGE"; then
    exit 1
fi

podman run --rm -it \
    --name minecraft-deceased-craft \
    --userns keep-id \
    --network pasta \
    -e JVM_MEMORY=16G \
    -e JVM_AUTHLIB_INJECTOR_URL=your_jvm_authlib_injector_url \
    -e GAME_MAX_PLAYERS=8 \
    -e GAME_ONLINE_MODE=true \
    -e GAME_ENABLE_RCON=false \
    -e GAME_RCON_PASSWORD=your_game_rcon_password \
    -p 25565:25565/tcp \
    -p 25575:25575/tcp \
    -v ./minecraft-deceased-craft-World:/app/World \
    "$IMAGE"
```

