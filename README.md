# v2node
A v2board backend base on moddified xray-core.
一个基于修改版xray内核的V2board节点服务端。

**注意： 本项目需要搭配[修改版V2board](https://github.com/wyx2685/v2board)**

## 软件安装

### 一键安装（Linux）

```bash
wget -N https://raw.githubusercontent.com/wyx2685/v2node/master/script/install.sh && bash install.sh
```

### Docker

**方式一：通过环境变量自动初始化（推荐）**

容器首次启动时若 `/etc/v2node/config.json` 不存在，将自动根据环境变量生成配置，等价于 `v2node generate`。

```bash
docker run -d --name v2node \
  -e V2NODE_API_HOST="https://your-panel.example.com" \
  -e V2NODE_NODE_ID=1 \
  -e V2NODE_API_KEY="your_api_key_here" \
  -v v2node-config:/etc/v2node \
  --network=host \
  ghcr.io/wyx2685/v2node
```

支持的环境变量：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `V2NODE_API_HOST` | 面板 API 地址 | — |
| `V2NODE_NODE_ID` | 节点 ID，支持 `1` 或 `"1,2,3"`（同一面板多节点，逗号分隔） | — |
| `V2NODE_API_KEY` | 节点通讯密钥 | — |
| `V2NODE_LOG_LEVEL` | 日志级别 | `warning` |
| `V2NODE_LOG_ACCESS` | 访问日志 | `none` |
| `V2NODE_TIMEOUT` | API 超时（秒） | `15` |
| `V2NODE_SKIP_GENERATE` | 设为任意值则跳过自动生成 | — |

**方式二：挂载已有配置文件**

```bash
docker run -d --name v2node \
  -v /etc/v2node/config.json:/etc/v2node/config.json \
  --network=host \
  ghcr.io/wyx2685/v2node
```

**构建本地镜像**

```bash
docker build -t v2node:local .
```

## 构建
``` bash
GOEXPERIMENT=jsonv2 go build -v -o build_assets/v2node -trimpath -ldflags "-X 'github.com/wyx2685/v2node/cmd.version=$version' -s -w -buildid="
```

## Stars 增长记录

[![Stargazers over time](https://starchart.cc/wyx2685/v2node.svg?variant=adaptive)](https://starchart.cc/wyx2685/v2node)
