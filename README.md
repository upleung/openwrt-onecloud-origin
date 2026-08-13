# OpenWrt-OneCloud-Docker版官方原生镜像

<br>

## 🐧为了更好地维护与更新，已迁移至新仓库[OpenWrt-OneCloud-Docker](https://github.com/upleung/OpenWrt-OneCloud-Docker)

<br>

---

## 📋 支持的设备
- ✅ **玩客云S1608**

- 登录地址:
  - 192.168.50.235
  - 密码:空

- 系统内核:
  - [默认] TCP 关闭BBR
  - 原因:开启BBR上传速度异常

- 刷机工具:
  - [下载](https://xd1314.lanzoul.com/iXHbz17bqjhc)


- 相关引导:

  - [`u-boot`](https://github.com/hzyitc/u-boot-onecloud)


- 固件说明:

  - 固件和Docker镜像均为OpenWrt公版，未添加第三方插件，为保持镜像纯净原生体验，可后期通过SSH方式自定义添加插件（如Clash、Xray、Sing-box等）


---


## 💎实测可用，优先使用[OpenWrt 23.05.6](https://hub.docker.com/repository/docker/mcgtekwrt/openwrt-onecloud)版本(即latest版)：


### 🐧拉取镜像

```
docker pull mcgtekwrt/openwrt-onecloud:latest
```

### 🐧检查 Docker 网络 (Macvlan)

- 如原先跑过旧的 OpenWrt 容器，说明 Macvlan 网络已经创建好，用以下命令查看网络名称：

```
docker network ls
```
- 通常名字叫 macnet 或 macvlan（下面命令以 macnet 为例）。如果没找到，可以重新创建：

```
# 仅当 docker network ls 中没有 macvlan 网络时执行：（根据自己的网段和默认网关填写）

docker network create -d macvlan \
  --subnet=192.168.50.0/24 \
  --gateway=192.168.50.1 \
  -o parent=eth0 macnet
```


### 🐧启动运行

- 首次测试

```
docker run \
-d \
--name openwrt-new \
--network macnet \
--privileged \
--restart=no \
mcgtekwrt/openwrt-onecloud:latest \
/sbin/init
```

- 数据持久化运行

```
docker run -d \
  --name openwrt-new \
  --network macnet \
  --privileged \
  --restart=always \
  -v /root/openwrt/etc/config:/etc/config \
  mcgtekwrt/openwrt-onecloud:latest \
  /sbin/init
```

- 使用 Docker Compose运行（推荐，方便管理）

```
version: '3.8'

services:
  openwrt:
    image: mcgtekwrt/openwrt-onecloud:latest
    container_name: openwrt-new
    privileged: true
    restart: always
    command: /sbin/init
    networks:
      macnet: {}
    volumes:
      # 持久化关键网络和系统配置
      - ./etc/config:/etc/config
      # 保留用户密码和账户数据
      - ./etc/shadow:/etc/shadow

networks:
  macnet:
    external: true
```


### 🐧默认登录地址

```
192.168.50.235
密码:空
```

根据自己的网段修改登录地址:[更多设置方法](https://github.com/upleung/openwrt-onecloud-origin/blob/main/docs/1.%20%E4%BF%AE%E6%94%B9%E7%99%BB%E5%BD%95%E5%9C%B0%E5%9D%80.md)

(如果因为网段不通无法进入后台，可以直接进入容器内部修改网络配置)

- 进入正在运行的 OpenWrt 容器终端：
```bash
#docker exec -it <你的容器名称或ID> sh

docker exec -it openwrt-new sh

```


- 编辑网络配置文件：
```bash
vi /etc/config/network

```


- 找到 `config interface 'lan'` 代码段：
```text
config interface 'lan'
    option device 'br-lan'
    option proto 'static'
    option ipaddr '192.168.50.235'    # 将此处的 IP 改为你的目标网段 IP
    option netmask '255.255.255.0'

```


1. 保存并退出编辑器（在 `vi` 中按 `Esc` 键，输入 `:wq` 并回车）。
2. 重启网络服务使之生效：
```bash
/etc/init.d/network restart

```

### 🐧常用查询命令：

```
#查看是否启动（Up xx seconds表示正常启动）
docker ps -a | grep openwrt

#查看运行LOG运行日志
docker logs openwrt-new

#列出所有容器（包括已停止的容器）
docker ps -a

#列出本地存储所有的openwrt镜像
docker images | grep openwrt

#查询真实IP
docker inspect openwrt-new | grep IPAddress

```

### 🐧停用删除镜像

```
docker stop openwrt-new
docker rm openwrt-new

#删除一个或多个镜像
docker rmi 'CONTAINER ID' or 'IMAGE ID'
```

---

### 🔗相关使用指南

[1. 修改登录地址](https://github.com/upleung/openwrt-onecloud-origin/blob/main/docs/1.%20%E4%BF%AE%E6%94%B9%E7%99%BB%E5%BD%95%E5%9C%B0%E5%9D%80.md)

[2. 网络代理和初步设置](https://github.com/upleung/openwrt-onecloud-origin/blob/main/docs/2.%20%E7%BD%91%E7%BB%9C%E4%BB%A3%E7%90%86%E5%92%8C%E5%88%9D%E6%AD%A5%E8%AE%BE%E7%BD%AE.md)
[]()
[]()
[]()





