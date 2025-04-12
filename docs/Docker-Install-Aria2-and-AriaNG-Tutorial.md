下面是您提供的命令的整理版本，用于安装和配置 Aria2 以及 AriaNg，并确保它们能够互相配合工作：

### 安装 Aria2

执行以下命令以在 Docker 中运行 Aria2：

```sh
docker run -d \
  --name aria2 \
  --restart unless-stopped \
  --log-opt max-size=1m \
  -e PUID=0 \
  -e PGID=0 \
  -e UMASK_SET=022 \
  -e RPC_SECRET=admin \
  -e RPC_PORT=6800 \
  -e LISTEN_PORT=53359 \
  --net=host \
  -v /home/docker/aria2/config:/config \
  -v /mnt/usbdisk/downloads:/downloads \
  p3terx/aria2-pro
```

### 参数解析

- **`-d`**: 使容器在后台运行（detached mode）。
- **`--name aria2`**: 为容器指定名称 `aria2`。
- **`--restart unless-stopped`**: 设置容器重启策略为 `unless-stopped`。
- **`--log-opt max-size=1m`**: 限制日志文件大小为 1MB。
- **`-e PUID=0`**: 设置容器内的用户 ID 为 `0`（root 用户）。
- **`-e PGID=0`**: 设置容器内的组 ID 为 `0`（root 组）。
- **`-e UMASK_SET=022`**: 设置 umask 值为 `022`。
- **`-e RPC_SECRET=admin`**: 设置 RPC 密钥为 `admin`。
- **`-e RPC_PORT=6800`**: 设置 RPC 服务端口为 `6800`。
- **`-e LISTEN_PORT=53359`**: 设置监听端口为 `53359`，用于 BT 下载。
- **`--net=host`**: 使用主机网络模式。
- **`-v /home/docker/aria2/config:/config`**: 将主机的配置目录挂载到容器的 `/config` 目录。
- **`-v /mnt/usbdisk/downloads:/downloads`**: 将主机的下载目录挂载到容器的 `/downloads` 目录。
- **`p3terx/aria2-pro`**: 使用的镜像为 `p3terx/aria2-pro`。

### 安装 AriaNg

执行以下命令以在 Docker 中运行 AriaNg：

```sh
docker run -d \
  --name ariang \
  --log-opt max-size=1m \
  --restart unless-stopped \
  --net=host \
  p3terx/ariang
```

### 参数解析

- **`-d`**: 使容器在后台运行（detached mode）。
- **`--name ariang`**: 为容器指定名称 `ariang`。
- **`--log-opt max-size=1m`**: 限制日志文件大小为 1MB。
- **`--restart unless-stopped`**: 设置容器重启策略为 `unless-stopped`。
- **`--net=host`**: 使用主机网络模式。
- **`p3terx/ariang`**: 使用的镜像为 `p3terx/ariang`。

### 配置 AriaNg 连接 Aria2

启动两个容器后，您可以通过浏览器访问 AriaNg，并配置其连接到 Aria2。

#### 访问 AriaNg

使用主机的 IP 地址，通过以下 URL 访问 AriaNg：

```
http://<主机IP>
```

例如，如果主机的 IP 地址是 `192.168.1.100`，则访问：

```
http://192.168.1.100
```

#### 配置 AriaNg

1. 打开 AriaNg 页面。
2. 点击右上角的设置图标。
3. 在“RPC 选项”中，配置以下内容：
   - RPC 地址：`http://localhost:6800/jsonrpc`
   - RPC 密钥：`admin`

保存配置后，AriaNg 将能够连接到 Aria2，并显示下载任务的状态。

### 总结

通过上述步骤，您已经成功在 Docker 中安装并配置了 Aria2 和 AriaNg。您可以通过 AriaNg 的 Web 界面管理和监控 Aria2 的下载任务。
