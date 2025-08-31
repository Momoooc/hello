# Proxmox VE (PVE) 9.0 全方位部署与优化教程

本教程将指导您完成 PVE 安装后的关键配置步骤，涵盖存储空间优化、更新源配置、核显虚拟化 (GVT-g) 以及界面优化。请根据您的硬件情况和使用需求，选择相应的章节进行操作。

## 一、存储空间优化

根据您的硬盘数量和规划，从以下三种方案中**选择一种**进行操作。

### **方案一：单硬盘 - 合并内置存储空间**

**目标：** 将默认安装后分离的 `data` 卷空间，全部合并到系统所在的 `root` 卷。这能让您更灵活地使用所有磁盘空间，统一存放虚拟机、容器、ISO镜像和备份文件。

> **注意：** 此操作会删除 `local-lvm` 存储及其中的所有数据。请在全新的系统上执行。

**第1步：登录 PVE 节点 Shell**

在 PVE 网页管理后台，选择您的节点，然后点击 “>\_ Shell” 打开命令行终端。

**第2步：删除 data 逻辑卷**

*   **执行命令：** (直接复制粘贴到 Shell 中回车)
    ```bash
    lvremove /dev/pve/data
    ```
*   **操作确认：** 系统会提示 `Do you really want to remove and DISCARD logical volume pve/data? [y/n]:`，输入 `y` 然后按回车。
*   **成功提示：** 看到 `Logical volume "data" successfully removed` 即表示成功。

**第3步：扩展 root 逻辑卷并刷新文件系统**

*   **说明：** 此命令会将刚刚释放的全部空间添加给 `root` 卷，并自动扩展文件系统。
*   **执行命令：**
    ```bash
    lvextend -l +100%FREE -r /dev/pve/root
    ```
*   **成功提示：** 看到 `Logical volume "root" successfully resized.` 等信息即表示成功。

**第4步：在网页后台配置存储**

1.  返回 PVE 网页管理后台。
2.  导航到 `数据中心` -> `存储`。
3.  **移除 `local-lvm`**：选中名为 `local-lvm` 的存储，点击 `移除` 按钮，在弹出的窗口确认。
4.  **编辑 `local`**：双击名为 `local` 的存储，打开编辑窗口。
5.  在 `内容` 选项中，确保**所有类型**的复选框都被勾选上（如磁盘镜像、ISO镜像、容器模板等）。
6.  点击 `确定` 保存。

**至此，您的内置存储空间已合并完成！**

---

### **方案二：多硬盘 - 添加新硬盘扩容系统分区**

**目标：** 将一块全新的物理硬盘（例如 `/dev/sdb`）添加到 PVE 系统中，并用其空间来**扩展系统 `root` 分区**。

> **警告：** 此操作会清空新硬盘上的所有数据。请务必确认您使用的硬盘标识符（如 `/dev/sdb`）是正确的！您可以通过 `lsblk` 命令查看所有磁盘。

**第1步：将新硬盘初始化为物理卷**

*   **执行命令：** (请将 `/dev/sdb` 替换为您自己的硬盘)
    ```bash
    pvcreate /dev/sdb
    ```
*   **成功提示：** 看到 `Physical volume "/dev/sdb" successfully created.` 即表示成功。

**第2步：将物理卷加入 pve 卷组**

*   **说明：** `pve` 是 PVE 默认的卷组（可以理解为一个存储池）。
*   **执行命令：** (请将 `/dev/sdb` 替换为您自己的硬盘)
    ```bash
    vgextend pve /dev/sdb
    ```
*   **成功提示：** 看到 `Volume group "pve" successfully extended.` 即表示成功。

**第3步：扩展 root 逻辑卷**

*   **说明：** 将 `pve` 卷组中所有新增加的空闲空间分配给 `root` 卷。
*   **执行命令：**
    ```bash
    lvextend -l +100%FREE -r /dev/pve/root
    ```
*   **成功提示：** 看到 `Logical volume "root" successfully resized.` 等信息即表示成功。

**第4步：刷新文件系统使空间生效 (最关键！)**

*   **说明：** 让操作系统识别到 `root` 卷变大后的新空间。
*   **执行命令：**
    ```bash
    resize2fs /dev/mapper/pve-root
    ```
*   **成功提示：** 命令执行后会显示文件系统的新大小，没有报错即表示成功。

**至此，您已成功用新硬盘为系统分区扩容！**

---

### **方案三：多硬盘 - 添加新硬盘作为独立存储 (推荐)**

**目标：** 将一块全新的物理硬盘（例如 `/dev/sdc`）添加为**独立的 LVM-Thin 存储池**，专门用于存放虚拟机和容器的磁盘，使其与系统盘分离。

> **警告：** 此操作会清空新硬盘上的所有数据。请务必确认您使用的硬盘标识符（如 `/dev/sdc`）是正确的！您可以通过 `lsblk` 命令查看所有磁盘。

**第1步：将新硬盘初始化为物理卷**

*   **执行命令：** (请将 `/dev/sdc` 替换为您自己的硬盘)
    ```bash
    pvcreate /dev/sdc
    ```
*   **成功提示：** 看到 `Physical volume "/dev/sdc" successfully created.` 即表示成功。

**第2步：创建新的卷组 (Volume Group)**

*   **说明：** 我们将创建一个名为 `hdd-storage` 的新卷组，作为独立的存储池。
*   **执行命令：** (您可以将 `hdd-storage` 替换为您喜欢的名称)
    ```bash
    vgcreate hdd-storage /dev/sdc
    ```
*   **成功提示：** 看到 `Volume group "hdd-storage" successfully created` 即表示成功。

**第3步：创建 LVM-Thin 池**

*   **说明：** 在新卷组中创建一个名为 `vm-storage` 的 Thin Pool。Thin-Provisioning（精简配置）可以更高效地利用存储空间。
*   **执行命令：**
    ```bash
    lvcreate -l 100%FREE -T -n vm-storage hdd-storage
    ```
*   **成功提示：** 看到 `Logical volume "vm-storage" created.` 即表示成功。

**第4步：在网页后台添加 LVM-Thin 存储**

1.  返回 PVE 网页管理后台。
2.  导航到 `数据中心` -> `存储`。
3.  点击 `添加` 按钮，然后从下拉菜单中选择 `LVM-Thin`。
4.  在弹出的 "添加: LVM-Thin" 窗口中，按如下内容填写：
    *   **ID:** 给存储起一个名字，例如 `vm-data` (它将显示在左侧存储列表中)。
    *   **卷组 (Volume Group):** 从下拉菜单中选择我们刚刚创建的 `hdd-storage`。
    *   **Thin Pool:** 从下拉菜单中选择我们刚刚创建的 `vm-storage`。
    *   **内容 (Content):** 勾选 `磁盘镜像` 和 `容器`。
    *   **启用 (Enable):** 确保此复选框已勾选。
5.  点击 `添加` 按钮完成。

**至此，您已成功添加了一块新的独立硬盘用于存储虚拟机和容器！**

---

## 二、配置 PVE 更新源 (换源教程)

**目标：** 将 Proxmox VE 的默认企业版更新源更换为国内的清华大学镜像源，并启用无订阅更新，以提高软件更新速度并消除“未订阅”的弹窗提示。

> **背景知识：** Proxmox VE 基于 Debian 系统，其软件源分为 PVE 自身的软件源 (pve) 和 Debian 基础系统的软件源 (debian)。我们将对这两部分以及 Ceph 存储的源进行配置。

**第1步：登录 PVE 节点 Shell**

**第2步：备份默认源文件 (可选，但推荐)**

```bash
cp /etc/apt/sources.list.d/pve-enterprise.sources /etc/apt/sources.list.d/pve-enterprise.sources.bak
```

**第3步：禁用企业版更新源**

*   **执行命令：** (该命令会将文件内容的每一行开头加上 `#` 号，将其注释掉)
    ```bash
    sed -i 's/^/# /' /etc/apt/sources.list.d/pve-enterprise.sources
    ```

**第4步：配置 PVE 无订阅更新源**

*   **执行命令：** (将 PVE 9.0 (trixie) 的社区源指向清华镜像)
    ```bash
    cat > /etc/apt/sources.list.d/pve-no-subscription.sources <<EOF
    Types: deb
    URIs: https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/pve
    Suites: trixie
    Components: pve-no-subscription
    Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
    EOF
    ```

**第5步：配置 Ceph 存储更新源**

*   **执行命令：** (将 Ceph 源指向清华镜像)
    ```bash
    cat > /etc/apt/sources.list.d/ceph.sources <<EOF
    Types: deb
    URIs: https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/ceph-squid
    Suites: trixie
    Components: no-subscription
    Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
    EOF
    ```

**第6步：配置 Debian 基础系统更新源**

*   **执行命令：** (将 Debian 13 (trixie) 的基础和安全更新源指向清华镜像)
    ```bash
    cat > /etc/apt/sources.list.d/debian.sources <<EOF
    Types: deb
    URIs: https://mirrors.tuna.tsinghua.edu.cn/debian
    Suites: trixie trixie-updates trixie-backports
    Components: main contrib non-free non-free-firmware
    Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

    Types: deb
    URIs: https://security.debian.org/debian-security
    Suites: trixie-security
    Components: main contrib non-free non-free-firmware
    Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
    EOF
    ```

**第7步：刷新软件包列表并更新系统**

*   **执行命令：**
    ```bash
    apt update && apt dist-upgrade -y
    ```
*   **成功提示：** 如果命令执行过程中没有出现错误信息，则表示换源成功。

**至此，您的 PVE 更新源已成功更换为国内镜像！**

---

## 三、开启 Intel 核显虚拟化 (GVT-g)

**目标：** 启用 Intel GVT-g 技术，允许您将 Intel 核显（集成显卡）分割成多个虚拟 GPU，分配给不同的虚拟机使用，实现硬件加速。

**第1步：编辑内核模块**

*   **说明：** 确保系统在启动时加载 GVT-g 所需的内核模块。
*   **执行命令：** 打开 `/etc/modules` 文件进行编辑。
    ```bash
    nano /etc/modules
    ```
*   **添加内容：** 在文件末尾添加以下模块（如果已有请勿重复添加）：
    ```
    vfio
    vfio_iommu_type1
    vfio_pci
    vfio_virqfd
    kvmgt
    ```
*   保存并退出编辑器 (按 `Ctrl + X`，然后按 `Y`，再按回车)。

**第2步：配置 GRUB 引导参数**

*   **说明：** 修改内核引导参数，以开启 IOMMU 和 GVT-g 功能。
*   **执行命令：** 编辑 GRUB 配置文件。
    ```bash
    nano /etc/default/grub
    ```
*   **修改配置：** 找到 `GRUB_CMDLINE_LINUX_DEFAULT` 这一行，修改为：
    ```
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=on iommu=pt i915.enable_gvt=1"
    ```
*   保存并退出编辑器。

**第3步：应用配置并更新引导**

*   **说明：** 使刚刚的修改生效。
*   **执行命令 (更新 GRUB)：**
    ```bash
    update-grub
    ```
*   **执行命令 (更新 initramfs)：**
    ```bash
    update-initramfs -u -k all
    ```

**第4步：重启系统**

*   **说明：** 所有配置需要重启后才能加载。
*   **执行命令：**
    ```bash
    reboot
    ```

**重启后，您的 PVE 主机就成功开启了 GVT-g 功能，可以在虚拟机的硬件配置中添加 PCI 设备来分配虚拟 GPU 了。**

---

## 四、移除“无有效订阅”弹窗

**目标：** 通过修改 JavaScript 文件，屏蔽每次登录时出现的“No valid subscription”提示弹窗。

**第1步：登录 PVE 节点 Shell**

**第2步：执行一键屏蔽命令**

*   **说明：** 此命令会备份原始文件，然后通过 `sed` 命令找到触发弹窗的代码 `Ext.Msg.show({...})`，并将其替换为 `void({...})`，使其失效。最后重启 PVE 代理服务以应用更改。
*   **执行命令：**
    ```bash
    sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
    ```

**命令执行成功后，刷新您的 PVE 网页管理界面，恼人的订阅弹窗就已经消失了。**


