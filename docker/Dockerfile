# 采用空基础镜像
FROM scratch

# 导入 OpenWrt 编译出的 rootfs 文件[cite: 1]
ADD *-rootfs.tar.gz /

# 暴露常用的 Web 与 SSH 端口[cite: 1]
EXPOSE 22 80 443

USER root

# 保留 init 组件并启动，确保 procd 和网络服务能够正常运行[cite: 1]
CMD ["/sbin/init"]
