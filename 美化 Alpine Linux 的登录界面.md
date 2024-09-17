## 教程：美化 Alpine Linux 的登录界面

通过这个教程，你可以在每次登录 Alpine Linux 时，动态显示系统信息，并美化登录界面。

### 步骤 1：创建 `system_info.sh` 脚本

首先，我们需要在 `/etc/profile.d/` 目录下创建一个名为 `system_info.sh` 的脚本文件。

1. 打开终端并输入以下命令来创建并编辑文件：

    ```sh
    sudo nano /etc/profile.d/system_info.sh
    ```

2. 把以下内容复制并粘贴到文件中：

    ```sh
    #!/bin/bash

    # 美化内容
    echo -e "\033[1;31m    _     _       __  ____  __ \033[0m\033[1;34m  ______     ______  \033[0m"
    echo -e "\033[1;31m   | |   (_)_   _|  \/  \ \/ / \033[0m\033[1;34m / ___\ \   / /  _ \ \033[0m"
    echo -e "\033[1;31m   | |   | | | | | |\/| |\  /  \033[0m\033[1;34m \___ \ \ / /| |_) | \033[0m"
    echo -e "\033[1;31m   | |___| | |_| | |  | |/  \  \033[0m\033[1;34m  ___) |\ V / |  _ <  \033[0m"
    echo -e "\033[1;31m   |_____|_|\__,_|_|  |_/_/\_\ \033[0m\033[1;34m |____/  \_/  |_| \_\ \033[0m"
    echo -e "\033[4m_______________________________________________________\033[0m"
    echo ""

    # 系统版本和内核版本用黄色加粗展示
    echo -e "\033[1;31m系统版本:\033[1;33m $(grep 'PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '\"')\033[0m"
    echo -e "\033[1;31m内核版本:\033[1;33m $(uname -r)\033[0m"

    # CPU型号、CPU温度、CPU核心、CPU占用率、内存占用率用绿色加粗展示
    echo -e "\033[1;31mCPU型号:\033[1;32m $(lscpu | grep 'Model name' | head -n 1 | cut -d: -f2 | sed 's/^ *//')\033[0m"
    echo -e "\033[1;31mCPU温度:\033[1;32m $(sensors | grep 'Core 0' | grep -o '+[0-9.]*°C' | head -n 1 | cut -d'+' -f2) \033[0m"
    echo -e "\033[1;31mCPU核心:\033[1;32m $(lscpu | grep '^CPU(s):' | head -n 1 | cut -d: -f2 | sed 's/^ *//')\033[0m"
    echo -e "\033[1;31mCPU占用率:\033[1;32m $(echo "100 - $(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/')" | bc)%\033[0m"
    echo -e "\033[1;31m内存占用率:\033[1;32m $(free -m | grep Mem: | grep -o '[0-9]*' | head -n 2 | paste -sd '/' - | while IFS=/ read total used; do echo "$used.00/$total.00 MB ($(echo "scale=2; $used/$total*100" | bc)%)"; done)\033[0m"

    # IPv4地址、IPv6地址用蓝色加粗展示
    echo -e "\033[1;31mIPv4地址:\033[1;34m $(ifconfig eth0 | grep 'inet addr:' | sed -n 's/.*inet addr:\([0-9.]*\).*/\1/p')\033[0m"
    echo -e "\033[1;31mIPv6地址:\033[1;34m $(ifconfig eth0 | grep 'inet6 addr:' | grep -v 'fe80' | sed -n 's/.*inet6 addr: \([a-f0-9:]*\).*/\1/p')\033[0m"

    # Nginx配置、Docker路径用青色加粗展示
    echo -e "\033[1;31mNginx配置:\033[1;36m /home/web/nginx.conf\033[0m"
    echo -e "\033[1;31mDocker路径:\033[1;36m $(which docker)\033[0m"

    # 当前时间用淡白色粗体展示
    echo -e "\033[1;31m当前时间:\033[1;37m $(date '+%Y-%m-%d %H:%M:%S')\033[0m"

    echo -e "\033[4m_______________________________________________________\033[0m"
    echo ""
    echo ""
    ```

    **提示**：你可以从网上生成不同的艺术字来美化内容，例如使用 [TAAG](http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20) 或类似的 ASCII 艺术生成器。

3. 保存并退出编辑器（在 `nano` 中，你可以按 `Ctrl+X`，然后按 `Y` 确认保存并按 `Enter`）。

### 步骤 2：删除 `/etc/motd` 的内容

系统默认的 `/etc/motd` 文件通常包含一些静态信息。为了保持登录界面整洁，你需要删除该文件的内容，仅留两行空白。

1. 打开 `/etc/motd` 文件并编辑：

    ```sh
    sudo nano /etc/motd
    ```

2. 删除所有内容并仅保留两行空白。

3. 保存并退出编辑器。

### 步骤 3：使脚本可执行

确保 `system_info.sh` 脚本具有可执行权限。

```sh
sudo chmod +x /etc/profile.d/system_info.sh
```

### 步骤 4：测试登录界面

注销并重新登录以查看效果。你应该会看到美化后的系统信息。

### 自定义功能

如果你希望根据自己的需求定制更多功能，可以修改脚本中的正则表达式。例如：

- 修改 CPU 温度读取的正则表达式以适配不同的硬件；
- 根据需求定制内存占用率的计算方式；
- 添加更多的系统信息展示，比如磁盘占用情况、网络连接状态等。

### 总结

通过以上步骤，你已经成功地配置了一个在每次登录时显示动态系统信息的美化界面。这不仅让界面看起来更吸引人，还提供了有用的系统信息，方便你快速了解系统状态。根据需求定制正则表达式和显示内容，能让你的登录界面更加个性化。
