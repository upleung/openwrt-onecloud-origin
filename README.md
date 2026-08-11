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

### 🐧启动运行

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
