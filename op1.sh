#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-op1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git passwall_packages https://github.com/lxiaya/openwrt-passwall-packages.git;main' >>feeds.conf.default
#echo 'src-git homeproxy https://github.com/lxiaya/openwrt-homeproxy.git' >>feeds.conf.default
#echo 'src-git openclash https://github.com/vernesong/OpenClash' >>feeds.conf.default
#echo 'src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main' >>feeds.conf.default
#echo 'net.netfilter.nf_conntrack_max=65535' >>package/kernel/linux/files/sysctl-nf-conntrack.conf

# 仅保留常用的LUCI和网络插件，移除 passwall、openclash 等第三方 feeds[cite: 1, 2]
echo 'net.netfilter.nf_conntrack_max=65535' >> package/kernel/linux/files/sysctl-nf-conntrack.conf
