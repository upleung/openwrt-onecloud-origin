# OpenWrt-OneCloud-Docker版官方原生镜像
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


## 💎Docker正在测试中，优先使用这个版本，实测可用：


### 🐧拉取镜像

```
docker pull mcgtekwrt/openwrt-onecloud:new23.05.6
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
--name openwrt-test \
--network macnet \
--privileged \
--restart=no \
mcgtekwrt/openwrt-onecloud:new23.05.6 \
/sbin/init
```

- 数据持久化运行

```
docker run -d \
  --name openwrt-test \
  --network macnet \
  --privileged \
  --restart=always \
  -v /root/openwrt/etc/config:/etc/config \
  mcgtekwrt/openwrt-onecloud:new23.05.6 \
  /sbin/init
```

- 使用 Docker Compose运行（推荐，方便管理）

```
version: '3.8'

services:
  openwrt:
    image: mcgtekwrt/openwrt-onecloud:new23.05.6
    container_name: openwrt-test
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

根据自己的网段修改登录地址:[更多设置方法](https://github.com/upleung/openwrt-onecloud-origin/blob/main/docs/Change%20login%20address.md)

(如果因为网段不通无法进入后台，可以直接进入容器内部修改网络配置)

- 进入正在运行的 OpenWrt 容器终端：
```bash
#docker exec -it <你的容器名称或ID> sh

docker exec -it openwrt-test sh

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
docker logs openwrt-test

#列出所有容器（包括已停止的容器）
docker ps -a

#列出本地存储所有的openwrt镜像
docker images | grep openwrt

```

### 🐧停用删除

```
docker stop openwrt-test
docker rm openwrt-test

#删除一个或多个镜像
docker rmi 'CONTAINER ID' or 'IMAGE ID'
```
