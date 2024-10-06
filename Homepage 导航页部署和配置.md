### 一、docker 部署 Homepage 导航页
```bash
docker run -d \
  --name homepage \
  -e PUID=0 \
  -e PGID=0 \
  -p 80:3000 \
  -v /home/docker/homepage:/app/config \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --restart unless-stopped \
  ghcr.io/gethomepage/homepage:latest
```
### 二、编辑/home/docker/homepage的配置文件
#### ./docker.yaml
```yaml
 my-docker:
   socket: /var/run/docker.sock
```

#### ./services.yaml
```yaml
- 监控容器:
    - Portainer:
          icon: portainer.png
          href: http://192.168.2.201:9000
          description: Portainer管理界面
          server: my-docker # 此处的server名称应与docker.yaml配置中的实例名称匹配
          container: portainer # Portainer容器的名称
          version: 4
          widget:
            type: portainer
            url: http://192.168.2.201:9000
            env: 2
            key: <your_key>
    - Home Assistant:
          icon: home-assistant-alt.png
          href: http://192.168.2.201:8123
          description: 智能家居控制中心
          server: my-docker
          container: homeassistant
          widget:
            type: homeassistant
            url: http://192.168.2.201:8123
            key: <your_key>
- 我的容器:
    - AriaNG:
          icon: ariang.png
          href: http://192.168.2.201:6880
          description: Aria2下载工具
          server: my-docker
          container: ariang
    - Glances:
          icon: glances.png
          href: http://192.168.2.201:61208
          description: 服务器监控工具
          server: my-docker
          container: glances
    - Speedtest:
          icon: speedtest-tracker-old.png
          href: http://192.168.2.201:5555
          description: 网络速度测试
          server: my-docker
          container: speedtest
    - File Browser:
          icon: filebrowser.png
          href: http://192.168.2.201:8080
          description: 文件管理工具
          server: my-docker
          container: thirsty_saha
    - Alist:
          icon: https://cdn.jsdelivr.net/gh/alist-org/logo@main/logo.svg
          href: http://192.168.2.201:5244
          description: 文件列表工具
          server: my-docker
          container: alist
    - Qinglong:
          icon: https://qn.whyour.cn/logo.png
          href: http://192.168.2.201:5700
          description: 青龙面板
          server: my-docker
          container: qinglong
    - Xiaoya:
          icon: https://s2.loli.net/2023/04/24/Z9bMjB3TutzKDGY.png
          href: http://192.168.2.201:5678
          description: 小雅文件管理
          server: my-docker
          container: xiaoya
- 状态监测:
    - 系统信息:
        widget:
          type: glances
          url: http://192.168.2.201:61208
          metric: info
          version: 4
    - 处理器:
        widget:
          type: glances
          url: http://192.168.2.201:61208
          metric: cpu
          version: 4
    - 内存:
        widget:
          type: glances
          url: http://192.168.2.201:61208
          metric: memory
          version: 4
    - 进程:
        widget:
          type: glances
          url: http://192.168.2.201:61208
          metric: process
          version: 4
    - 网络:
        widget:
          type: glances
          url: http://192.168.2.201:61208
          metric: network:eth0
          version: 4
    - 硬盘:
        widget:
          type: glances
          url: http://192.168.2.201:61208
          metric: disk:sda
          version: 4
- 导航:
    - Github:
        icon: github-light.png
        href: https://github.com/
        description: Github开源社区
    - 吾爱破解:
        icon: https://avatar.52pojie.cn/data/avatar/002/22/25/56_avatar_small.jpg
        href: https://www.52pojie.cn/
        description: 吾爱破解论坛
    - 恩山论坛:
        icon: https://www.right.com.cn/logo.jpg
        href: https://www.right.com.cn/forum/
        description: 恩山无线论坛
    - 远景论坛:
        icon: https://bbs.pcbeta.com/favicon.png
        href: https://bbs.pcbeta.com/
        description: 远景论坛
    - 国家法律法规数据库:
        icon: https://splcgk.court.gov.cn/gzfwww//images/logo_01_v2.png
        href: https://flk.npc.gov.cn/
        description: 国家法律法规数据库
    - 中国裁判文书网:
        icon: https://splcgk.court.gov.cn/gzfwww//images/logo_01_v2.png
        href: https://wenshu.court.gov.cn/
        description: 中国裁判文书网
    - 人民法院案例库:
        icon: https://splcgk.court.gov.cn/gzfwww//images/logo_01_v2.png
        href: https://rmfyalk.court.gov.cn/
        description: 人民法院案例库
    - 湖南律师综合管理信息系统:
        icon: http://hunanlawyer.justice.org.cn:81/cloud/assets/images/titile.png
        href: http://hunanlawyer.justice.org.cn:81/
        description: 湖南律师综合管理信息系统
    - 阿水AI 6.0:
        icon: https://feixue666.com/wp-content/uploads/2024/09/2024090514364755.png
        href: https://ai.ashuiai.com/home
        description: 阿水AI 6.0
    - 画草图:
        icon: https://excalidraw.com/apple-touch-icon.png
        href: https://excalidraw.com/
        description: 在线画草图
    - CPU天梯:
        icon: https://www.cpuid.com/medias/images/softwares/cpu-z.svg
        href: https://tools.miku.ac/cpu_rank/
        description: CPU性能天梯图
    - IPTV 直播源采集:
        icon: vikunja.png
        href: https://m3u.ibert.me/
        description: IPTV 直播源采集
    - 在线PS:
        icon: https://www.nuanque.com/favicon.ico
        href: https://www.nuanque.com/ps/
        description: 在线Photoshop
    - 校园联合镜像站:
        icon: https://mirrors.cernet.edu.cn/static/img/mirrorz.svg
        href: https://mirrors.cernet.edu.cn/
        description: 校园联合镜像站
    - 山东大学镜像站:
        icon: https://mirrors.sdu.edu.cn/assets/member-U8YpTTOX.png
        href: https://mirrors.sdu.edu.cn/
        description: 山东大学镜像站
    - 南京大学镜像站:
        icon: https://mirrors.nju.edu.cn/assets/nju-c3c6250d.png
        href: https://mirrors.nju.edu.cn/
        description: 南京大学镜像站
```

#### ./settings.yaml
```yaml
providers:
  openweathermap: openweathermapapikey
  weatherapi: weatherapiapikey
language: zh-CN
title: 家庭服务器
color: gray
theme: dark
headerStyle: clean
hideVersion: true
statusStyle: "dot"
useEqualHeights: true
layout:
  状态监测:
    style: row
    columns: 6
    header: false
  监控容器:
    style: row
    columns: 2
    header: false
  我的容器:
    style: row
    columns: 3
    header: false
  导航:
    style: row
    columns: 5
```

#### ./widgets.yaml
```yaml
- resources:
    cpu: true
    memory: true
    disk:
      - /
    cputemp: true
    tempmin: 0
    tempmax: 100
    uptime: true
    units: metric
    refresh: 3000
    diskUnits: bbytes
- search:
    provider: baidu
    focus: true
    target: _blank
- datetime:
    text_size: 2xl
    format:
      hourCycle: h23
      dateStyle: short
      timeStyle: short
```
