
## 1. 在 Termux 中配置 SSH 服务器
---
### (1) 安装和配置 OpenSSH

#### a) 更新和安装 OpenSSH
首先，确保 Termux 包是最新的，然后安装 OpenSSH。SSH（Secure Shell）是一个加密的网络协议，用于在不安全的网络中安全地操作网络服务。

```sh
pkg update
pkg install openssh
```

#### b) 启动 SSH 服务
启动 SSH 服务，以便能够远程访问。`sshd` 是 SSH 守护进程，它在后台运行，监听传入的 SSH 连接请求。

```sh
sshd
```

#### c) 查看设备 IP 地址
使用以下命令查看设备的 IP 地址，这是你设备在网络中的唯一标识。

```sh
ifconfig
```

记下 `inet` 后面的 IP 地址，这是你将用来连接的地址。

#### d) 查看当前用户名
使用下面的命令查看你的用户名，这个用户名用于 SSH 登录。

```sh
whoami
```

#### e) 设置用户密码
设置一个安全的密码，这个密码将在 SSH 登录时使用。

```sh
passwd
```

两次输入你需要设置的密码。

### (2) 配置 SSH 服务器

#### a) 配置端口和密码登录
使用以下命令配置 SSH 服务器，设置端口为 5522，并启用密码登录。默认情况下，SSH 使用端口 22。我们修改为 5522 以增加安全性。

```sh
cat <<'EOF' > $PREFIX/etc/ssh/sshd_config
# This is the sshd server system-wide configuration file. See
# sshd_config(5) for more information.
# This sshd was compiled with PATH=/data/data/com.termux/files/usr/bin
Include /data/data/com.termux/files/usr/etc/ssh/sshd_config.d/*.conf
Port 5522
PermitRootLogin yes
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication yes
Subsystem sftp /data/data/com.termux/files/usr/libexec/sftp-server
EOF
```

#### b) 重启 SSH 服务
为了使配置生效，需重启 SSH 服务。`pkill sshd` 用于停止正在运行的 SSH 服务，然后通过 `sshd` 命令重新启动服务。

```sh
pkill sshd
sshd
```

## 2. 远程连接到设备

### (1) 使用 SSH 连接
在你的电脑上打开终端或命令提示符，使用以下命令连接到你的设备：

```sh
ssh -p 5522 <用户名>@<手机IP地址>
```

记得将 `<用户名>` 替换为你在 Termux 上的用户名，将 `<手机IP地址>` 替换为你的设备 IP 地址。

## 3. 常见错误及解决方法

#### 错误1: “Connection refused”
- **原因**: SSH 服务未启动或防火墙阻止了连接。
- **解决方法**: 确保 SSH 服务已启动 (`sshd`)，并检查防火墙设置。

#### 错误2: “Permission denied”
- **原因**: 用户名或密码错误。
- **解决方法**: 确认输入的用户名和密码正确。

#### 错误3: “Port 5522: No route to host”
- **原因**: IP 地址错误或设备不在同一网络中。
- **解决方法**: 确认设备 IP 地址正确，并且确保两个设备在同一网络中。

#### 错误4: “Host key verification failed”
- **原因**: SSH 密钥变化导致的信任问题。
- **解决方法**: 在客户端删除旧的已知主机条目，例如在 `~/.ssh/known_hosts` 中删除相关条目。

---

