### 一、Filebrowser 文件管理器
```bash
docker run -d \
    --name filebrowser \
    --restart unless-stopped \
    -v /:/srv:ro \
    -v /home/docker/filebrowser/database:/database \
    -v /home/docker/filebrowser/config:/config \
    -e PUID=1000 \
    -e PGID=1000 \
    -p 8080:80 \
    filebrowser/filebrowser:s6
```
File Browser是一个使用go语言编写的软件，功能是可以通过浏览器对服务器上的文件进行管理。

### 二、Portainer 面板(汉化版)
```bash
docker run -d \
  -p 9000:9000 \
  -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /home/docker/portainer_data:/data \
  6053537/portainer-ce
```
Portainer 是一种轻量级的开源管理工具，旨在简化管理 Docker 容器和 Kubernetes 集群的过程。它提供了一个用户友好的图形界面，使用户能够轻松地部署、管理和监控容器化应用。

### 三、Home Assistant 智能家居
```bash
docker run -d \
  --name homeassistant \
  --restart=unless-stopped \
  -e TZ=Asia/Shanghai \
  -v /home/docker/homeassistant:/config \
  --network=host \
  homeassistant/home-assistant:latest
```
Home Assistant 是一个非常强大的智能家居管理平台，支持多种设备和集成，能够满足大多数家庭自动化需求。

### 四、Navidrome 音乐服务器
```bash
docker run -d \
   --name navidrome \
   --restart=unless-stopped \
   -v /mnt/usbdisk:/music \
   -v /home/docker/navidrome:/data \
   -p 4533:4533 \
   -e ND_LOGLEVEL=info \
   deluan/navidrome:latest
```
Navidrome 提供了一个简单且强大的界面，可以管理和播放你的音乐收藏。

### 五、qBittorrent 下载工具
```bash
docker run -d \
  --name=qbittorrent \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=Asia/Shanghai \
  -e WEBUI_PORT=8088 \
  --net=host \
  -v /home/docker/qbittorrent/config:/config \
  -v /mnt/usbdisk/downloads:/downloads \
  --restart unless-stopped \
  linuxserver/qbittorrent
```
qBittorrent 是一个功能强大的 BT 客户端，具有丰富的功能和友好的 Web 界面，可以帮助你高效管理和下载 BT 资源。

### 六、LibreSpeed  网速测试
```bash
docker run -d \
  --name speedtest \
  -e WEBPORT=5555 \
  --network=host \
  ghcr.io/librespeed/speedtest:latest
```
LibreSpeed 提供了一个易于使用的界面，可以帮助你测试网络速度，了解网络性能。

