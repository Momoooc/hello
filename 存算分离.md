### 存算分离方案实现教程

本教程将指导你如何在两台设备上实现存算分离，通过NFS（网络文件系统）将存储和计算分离，以提高系统性能和资源利用效率。

#### 硬件配置

- **设备1（计算主机）**：
  - CPU: J1900
  - 内存: 8GB
  - 硬盘: 60GB
  - 网络: 1000Mbps有线网卡, 300Mbps无线网卡

- **设备2（存储设备，私家云2代）**：
  - CPU: 晶晨S905x
  - 内存: 1GB
  - 存储: 8GB eMMC, 挂载了2个298GB的机械硬盘
  - 网络: 100Mbps有线网卡, 300Mbps无线网卡
  - 操作系统: Ubuntu（已刷机）

### 1. 配置NFS服务器（存储设备）

#### 1.1 安装NFS服务器

使用SSH或直接登录到存储设备，运行以下命令安装NFS服务器：

```bash
sudo apt update
sudo apt install nfs-kernel-server
```

#### 1.2 创建共享目录

创建一个用于共享的目录，例如 `/DATA`：

```bash
sudo mkdir /DATA
sudo chmod 777 /DATA  # 临时设置宽权限以便测试
```

#### 1.3 配置NFS导出

编辑 `/etc/exports` 文件，添加以下内容以导出共享目录：

```plaintext
/DATA 192.168.2.0/24(rw,sync,no_subtree_check)
```

重新导出共享目录：

```bash
sudo exportfs -ra
```

#### 1.4 启动NFS服务

确保NFS服务启动并设置为开机自启：

```bash
sudo systemctl start nfs-kernel-server
sudo systemctl enable nfs-kernel-server
```

### 2. 配置NFS客户端（计算主机）

#### 2.1 安装NFS客户端

在计算主机上安装NFS客户端：

```bash
sudo apt update
sudo apt install nfs-common
```

#### 2.2 创建挂载点

创建一个挂载点目录，例如 `/mnt/remote_storage`：

```bash
sudo mkdir -p /mnt/remote_storage
```

#### 2.3 挂载NFS共享

挂载NFS共享目录：

```bash
sudo mount -t nfs 192.168.2.200:/DATA /mnt/remote_storage
```

#### 2.4 验证挂载

验证是否成功挂载，并测试读写操作：

```bash
echo "hello, NFS" | sudo tee /mnt/remote_storage/testfile.txt
cat /mnt/remote_storage/testfile.txt
sudo rm /mnt/remote_storage/testfile.txt
```

### 3. 配置自动挂载

#### 3.1 编辑 `/etc/fstab`

在计算主机上编辑 `/etc/fstab` 文件，添加以下挂载配置：

```plaintext
192.168.2.200:/DATA /mnt/remote_storage nfs defaults,rsize=8192,wsize=8192,async,noatime,vers=4 0 0
```

#### 3.2 应用配置

运行以下命令应用新的挂载配置：

```bash
sudo mount -a
```

#### 3.3 验证挂载状态

验证NFS挂载的状态：

```bash
mount | grep nfs
```

你应该看到类似以下的输出：

```plaintext
192.168.2.200:/DATA on /mnt/remote_storage type nfs (rw,relatime,rsize=8192,wsize=8192,vers=4,addr=192.168.2.200)
```

### 总结

通过上述步骤，你已经成功地配置了NFS服务器和客户端，使得两个设备可以实现存算分离。存储设备负责存储数据，计算主机通过网络文件系统访问这些数据，从而提升整体系统性能和资源利用效率。

如果你在过程中遇到任何问题或需要进一步的帮助，请随时联系。祝你的存算分离方案顺利运行！
