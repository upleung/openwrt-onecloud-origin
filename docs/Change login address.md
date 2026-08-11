## 玩客云 OpenWrt Docker 镜像登录信息

* **默认后台地址**: `192.168.50.235`

* **默认登录密码**: 空（无需输入密码，直接点击登录）

---

## 修改登录地址（匹配你自己的 Armbian 网段）教程

根据你的实际使用阶段，可以通过以下三种方法将 OpenWrt 的后台 IP 修改为与你的 Armbian 宿主机同网段的 IP。

<br>

---

### 方法一：编译前修改（推荐，一劳永逸）

如果你是通过 GitHub Actions 自行编译源码，可以在修改 `op2.sh` 脚本时直接指定你的目标网段 IP。

1. 打开项目根目录下的 `op2.sh` 文件。


2. 找到修改默认 IP 的命令行：


```bash
sed -i "s/192.168.1.1/192.168.50.235/g" package/base-files/files/bin/config_generate

```


3. 将其中的 `192.168.50.235` 替换为你实际想要的网段 IP（例如你的 Armbian 路由网段是 `192.168.2.x`，则可改为 `192.168.2.235`）。
4. 保存修改并重新触发编译。

<br>

---

### 方法二：通过 OpenWrt 后台修改（容器运行中）

如果容器已经在 Armbian 中正常运行，且你能够通过默认的 `192.168.50.235` 访问后台：

1. 浏览器输入 `192.168.50.235` 登录 OpenWrt。


2. 依次点击顶部菜单的 **网络 (Network)** -> **接口 (Interfaces)**。
3. 找到 **LAN** 接口，点击右侧的 **修改 (Edit)**。
4. 在 **基本设置 (General Settings)** 中，将 **IPv4 地址 (IPv4 address)** 修改为你 Armbian 局域网所在的同网段 IP（例如 `192.168.1.253`，需确保该 IP 未被局域网内其他设备占用）。
5. 滚动到页面底部，点击 **保存 & 应用 (Save & Apply)**。
6. 网络重启后，使用修改后的新 IP 地址重新访问后台。

<br>

---

### 方法三：通过命令行直接修改配置文件（Docker 终端）

如果因为网段不通无法进入后台，可以直接进入容器内部修改网络配置：

1. 进入正在运行的 OpenWrt 容器终端：
```bash
docker exec -it <你的容器名称或ID> /bin/sh

```


2. 编辑网络配置文件：
```bash
vi /etc/config/network

```


3. 找到 `config interface 'lan'` 代码段：
```text
config interface 'lan'
    option device 'br-lan'
    option proto 'static'
    option ipaddr '192.168.50.235'    # 将此处的 IP 改为你的目标网段 IP
    option netmask '255.255.255.0'

```


4. 保存并退出编辑器（在 `vi` 中按 `Esc` 键，输入 `:wq` 并回车）。
5. 重启网络服务使之生效：
```bash
/etc/init.d/network restart

```
