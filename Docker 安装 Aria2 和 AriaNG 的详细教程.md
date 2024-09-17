# Docker 安装 Aria2 和 AriaNG 的详细教程及自动化脚本

在本教程中，我们将介绍如何使用 Docker 来安装和运行 Aria2 和 AriaNG。这两者的组合可以帮助你轻松管理和加速下载任务。Aria2 是一个功能强大的下载工具，而 AriaNG 是其图形用户界面（GUI），可以让你更加方便地操作 Aria2。

## 1. 安装 Docker

在开始之前，请确保你已经在系统上安装了 Docker。如果没有安装，请参考 [Docker 官方文档](https://docs.docker.com/get-docker/) 来完成安装。

## 2. 拉取 Docker 镜像

首先，我们需要拉取 Aria2 和 AriaNG 的 Docker 镜像。打开终端并执行以下命令：

```bash
docker pull p3terx/aria2-pro
docker pull p3terx/ariang
```

## 3. 运行 Aria2 容器

接下来，我们将运行 Aria2 容器。执行以下命令：

```bash
docker run -d --name aria2 \
  --restart unless-stopped \
  --log-opt max-size=1m \
  -e PUID=$UID \
  -e PGID=$GID \
  -e UMASK_SET=022 \
  -e RPC_SECRET=abcdefg12345678 \
  -e RPC_PORT=6800 \
  -e LISTEN_PORT=6888 \
  -p 16800:6800 \
  -p 16888:6888 \
  -p 16888:6888/udp \
  -v /home/docker/config:/config \
  -v /home/downloads:/downloads \
  p3terx/aria2-pro
```

### 参数说明

- `--name aria2`: 容器名称为 `aria2`。
- `--restart unless-stopped`: 容器会在系统重启后自动启动，除非你手动停止它。
- `--log-opt max-size=1m`: 设置容器日志的最大大小为 1MB。
- `-e PUID=$UID`: 设置容器内进程的用户 ID。
- `-e PGID=$GID`: 设置容器内进程的用户组 ID。
- `-e UMASK_SET=022`: 设置文件权限掩码。
- `-e RPC_SECRET=abcdefg12345678`: 设置 Aria2 的 RPC 密钥。**请自行修改为安全的密钥**。
- `-e RPC_PORT=6800`: 设置 Aria2 的 RPC 端口。
- `-e LISTEN_PORT=6888`: 设置 Aria2 的监听端口。
- `-p 16800:6800`: 将宿主机的 16800 端口映射到容器内的 6800 端口。
- `-p 16888:6888`: 将宿主机的 16888 端口映射到容器内的 6888 端口。
- `-p 16888:6888/udp`: 将宿主机的 16888 端口映射到容器内的 6888 端口（UDP）。
- `-v /home/docker/config:/config`: 将宿主机的 `/home/docker/config` 目录挂载到容器内的 `/config` 目录。**请自行修改为你的配置文件保存路径**。
- `-v /home/downloads:/downloads`: 将宿主机的 `/home/downloads` 目录挂载到容器内的 `/downloads` 目录。**请自行修改为你的下载目录**。

### 注意事项

请特别注意以下几点：

- **RPC_SECRET**：请务必修改为一个安全的密钥。
- **配置文件路径**：`/home/docker/config` 需要改为你本地系统中的实际配置文件保存路径。
- **下载目录**：`/home/downloads` 需要改为你本地系统中的实际下载目录。

## 4. 运行 AriaNG 容器

现在，我们来运行 AriaNG 容器。执行以下命令：

```bash
docker run -d --name ariang \
  --restart unless-stopped \
  --log-opt max-size=1m \
  -p 46880:6880 \
  p3terx/ariang
```

### 参数说明

- `--name ariang`: 容器名称为 `ariang`。
- `--restart unless-stopped`: 容器会在系统重启后自动启动，除非你手动停止它。
- `--log-opt max-size=1m`: 设置容器日志的最大大小为 1MB。
- `-p 46880:6880`: 将宿主机的 46880 端口映射到容器内的 6880 端口。

## 5. 自定义修改端口及目录

你可以根据自己的需求修改端口和目录：

- **修改端口**：如果默认的端口（16800、16888、46880）已被占用，可以修改 `-p` 参数来使用其他端口，例如 `-p 18000:6800`。
- **修改配置文件保存目录**：修改 `-v /home/docker/config:/config` 部分，选择你本地系统中的其他目录。
- **修改下载目录**：修改 `-v /home/downloads:/downloads` 部分，选择你本地系统中的其他目录。

## 6. 访问 AriaNG

打开浏览器，访问 `http://<你的宿主机 IP>:46880`，你将看到 AriaNG 的界面。在设置中输入你的 Aria2 RPC 密钥和地址，即可开始使用。

## 7. 自动化安装脚本

我们提供一个自动化脚本，用于简化上述安装过程。该脚本会提示用户输入 RPC 密钥、安装路径（宿主机配置文件保存目录）和下载路径。

### 自动化脚本内容

将以下内容保存为 `install_aria2_ariang.sh`：

```bash
#!/bin/bash

# 提示用户输入 RPC 密钥
read -p "请输入 Aria2 RPC 密钥: " rpc_secret

# 提示用户输入宿主机配置文件保存目录
read -p "请输入宿主机配置文件保存目录 (默认: /home/docker/config): " config_path
config_path=${config_path:-/home/docker/config}

# 提示用户输入宿主机下载目录
read -p "请输入宿主机下载目录 (默认: /home/downloads): " downloads_path
downloads_path=${downloads_path:-/home/downloads}

# 检查并安装 Docker
if ! command -v docker &> /dev/null
then
    echo "Docker 未安装，正在安装 Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

# 拉取 Docker 镜像
echo "拉取 Aria2 和 AriaNG 的 Docker 镜像..."
docker pull p3terx/aria2-pro
docker pull p3terx/ariang

# 运行 Aria2 容器
echo "运行 Aria2 容器..."
docker run -d --name aria2 \
  --restart unless-stopped \
  --log-opt max-size=1m \
  -e PUID=$UID \
  -e PGID=$GID \
  -e UMASK_SET=022 \
  -e RPC_SECRET=$rpc_secret \
  -e RPC_PORT=6800 \
  -e LISTEN_PORT=6888 \
  -p 16800:6800 \
  -p 16888:6888 \
  -p 16888:6888/udp \
  -v $config_path:/config \
  -v $downloads_path:/downloads \
  p3terx/aria2-pro

# 运行 AriaNG 容器
echo "运行 AriaNG 容器..."
docker run -d --name ariang \
  --restart unless-stopped \
  --log-opt max-size=1m \
  -p 46880:6880 \
  p3terx/ariang

echo "Aria2 和 AriaNG 已成功安装并运行。"
echo "请在浏览器中访问：http://<你的宿主机 IP>:46880"
echo "在 AriaNG 设置中输入你的 Aria2 RPC 密钥和地址即可开始使用。" 
```

### 使用方法

1. 将上述脚本内容复制到一个名为 `install_aria2_ariang.sh` 的文件中。
2. 给予脚本执行权限：

    ```bash
    chmod +x install_aria2_ariang.sh
    ```

3. 运行脚本：

    ```bash
    ./install_aria2_ariang.sh
    ```

**至此，你已经成功在 Docker 上安装并运行了 Aria2 和 AriaNG。祝你下载愉快！**
