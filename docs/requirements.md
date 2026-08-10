# **OpenWrt-OneCloud 构建系统需求文档（正式版）**  
版本：v1.0  
作者：upleung
项目仓库：https://github.com/upleung/openwrt-onecloud-origin  
DockerHub：https://hub.docker.com/repository/docker/mcgtekwrt/openwrt-onecloud/

---

## **一、项目背景与目标**

本项目旨在基于 **OpenWrt 官方源码 23.05.6 稳定版**，为 **OneCloud（玩客云）设备**构建：

1. **可烧录的 OpenWrt 固件（适配 amlogic/meson8b）**  
2. **可在 Armbian 上运行的 OpenWrt Docker 镜像**

并实现：

- **自动化构建（GitHub Actions）**
- **固件推送到 GitHub Releases**
- **Docker 镜像推送到 GitHub Packages 与 DockerHub**
- **保持最小化插件集，仅保留常用 LUCI 与网络工具**
- **确保所有依赖、运行环境完整可用，系统可正常启动**

本项目将作为 OneCloud 的轻量化 OpenWrt 发行版，适用于 Armbian 用户与刷机用户。

---

## **二、构建目标与产物**

### **2.1 固件构建目标（OpenWrt 23.05.6）**

- 架构：`target/linux/amlogic/meson8b`
- 设备：OneCloud（玩客云）
- 固件类型：
  - `openwrt-onecloud-23.05.6-sysupgrade.img`
  - `openwrt-onecloud-23.05.6-factory.img`（如适用）
- 输出位置：
  - GitHub Releases（自动上传）

---

### **2.2 Docker 镜像构建目标**

用于在 **玩客云 Armbian（armbian/meson8b）** 上运行 OpenWrt 容器。

- 镜像名称：
  - `mcgtekwrt/openwrt-onecloud:latest`
  - `mcgtekwrt/openwrt-onecloud:23.05.6`
- 推送位置：
  - GitHub Packages
  - DockerHub

镜像要求：

- 基于 OpenWrt rootfs 构建
- 支持 overlay、网络桥接、宿主机端口映射
- 保留必要的 init、网络、系统依赖
- 可正常启动 `/sbin/init` 或 `/etc/init.d/` 服务

---

## **三、源码结构与仓库要求**

仓库地址：  
[https://github.com/upleung/openwrt-onecloud-origin](https://github.com/upleung/openwrt-onecloud-origin)

仓库需包含：

```
openwrt-onecloud-origin/
│── configs/                 # OpenWrt 构建配置（.config）
│── scripts/                 # 构建脚本（固件 + Docker）
│── docker/                  # Docker 镜像构建文件
│── patches/                 # OneCloud 设备补丁
│── feeds/                   # 自定义 feed 配置
│── .github/workflows/       # GitHub Actions 自动构建
│── docs/                    # 文档（需求文档、构建说明）
```

---

## **四、OpenWrt 插件与组件要求**

### **4.1 必须保留的 LUCI 插件（常用）**

- `luci`
- `luci-base`
- `luci-mod-admin-full`
- `luci-theme-bootstrap`
- `luci-proto-ipv6`
- `luci-proto-pppoe`
- `luci-app-firewall`
- `luci-app-opkg`

### **4.2 必须保留的网络组件**

- `dnsmasq-full`
- `odhcpd-ipv6only`
- `ppp`
- `ppp-mod-pppoe`
- `iptables / nftables`
- `ip-full`
- `curl`
- `wget`
- `ca-certificates`

### **4.3 必须保留的系统运行依赖**

- `busybox`
- `ubus`
- `uci`
- `rpcd`
- `netifd`
- `procd`
- `fstools`
- `kmod-*`（OneCloud 必要驱动）
- `kernel modules`（meson8b 必要模块）

### **4.4 明确需要删除的内容**

- 删除一些后期可以自己SSH安装的第三方插件（如 passwall、ssr-plus、openclash 等）

---

## **五、OneCloud 设备适配要求**

### **5.1 必要补丁**

- `meson8b` DTS 补丁
- OneCloud NAND/eMMC 存储补丁
- 网络 PHY 驱动补丁
- LED、按键补丁
- U-Boot 适配补丁（如需要）

### **5.2 必要内核模块**

- `kmod-meson-gpio`
- `kmod-usb-core`
- `kmod-usb2`
- `kmod-usb-storage`
- `kmod-fs-ext4`
- `kmod-fs-f2fs`

---

## **六、Docker 镜像构建要求**

### **6.1 Dockerfile 结构**

```
```

要求：

- rootfs 来自 OpenWrt 构建产物
- 保留 init、procd、netifd、ubus 等核心组件
- 支持 overlayfs（容器内）
- 支持宿主机网络桥接
- 支持端口映射

### **6.2 推送要求**

推送到：

- GitHub Packages  
  `ghcr.io/upleung/openwrt-onecloud:latest`

- DockerHub  
  `mcgtekwrt/openwrt-onecloud:latest`  
  `mcgtekwrt/openwrt-onecloud:23.05.6`

---

## **七、自动化构建（GitHub Actions）**

### **7.1 构建流程**

1. 拉取 OpenWrt 官方源码 23.05.6
2. 应用 OneCloud 补丁
3. 加载自定义 feeds
4. 生成 `.config`
5. 编译固件
6. 打包 rootfs
7. 构建 Docker 镜像
8. 推送固件到 GitHub Releases
9. 推送 Docker 镜像到 GitHub Packages + DockerHub

### **7.2 Actions 触发方式**

- 手动触发

---

## **八、最终交付内容**

你需要最终交付：

### **8.1 完整优化后的源码仓库**

包含：

- OneCloud 适配补丁
- 精简后的 feeds
- 精简后的 `.config`
- Docker 构建文件
- GitHub Actions 自动构建脚本
- 文档（需求文档、构建说明）

### **8.2 可用的构建产物**

- OpenWrt 固件（sysupgrade/factory）
- Docker 镜像（latest + 23.05.6）

---

## **九、后续扩展（可选）**

- 增加 Docker Compose 支持
- 增加 OpenWrt 容器的 overlay 持久化方案

---
