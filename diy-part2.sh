#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 安装 FUSE 依赖并更新 Go 语言环境
sudo apt install libfuse-dev -y
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 从零动态生成基础配置文件 .config
cat > .config <<EOF
CONFIG_TARGET_mediatek=y
CONFIG_TARGET_mediatek_filogic=y
CONFIG_TARGET_mediatek_filogic_DEVICE_cmcc_rax3000m=y

# 集成底层 CPU 调频内核模块
CONFIG_PACKAGE_kmod-cpufreq=y
CONFIG_PACKAGE_kmod-cpufreq-schedutil=y

# 集成 LuCI 图形化调频插件
CONFIG_PACKAGE_luci-app-cpufreq=y
CONFIG_PACKAGE_luci-i18n-cpufreq-zh-cn=y

# 常用基础插件集成
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-ksmbd=y
CONFIG_PACKAGE_luci-app-hd-idle=y
CONFIG_PACKAGE_luci-app-autoreboot=y
EOF

# 针对 25.12 官方底层内核（Linux 6.6）强制注入 cpufreq 硬件级驱动支持
# 防止官方 DTS 缺少 OPP 映射表导致驱动无法加载
TARGET_CONFIG="target/linux/mediatek/filogic/config-6.6"
if [ -f "$TARGET_CONFIG" ]; then
    sed -i '/CONFIG_CPU_FREQ/d' "$TARGET_CONFIG"
    echo "CONFIG_CPU_FREQ=y" >> "$TARGET_CONFIG"
    echo "CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y" >> "$TARGET_CONFIG"
    echo "CONFIG_CPU_FREQ_STAT=y" >> "$TARGET_CONFIG"
    echo "CONFIG_CPUFREQ_DT=y" >> "$TARGET_CONFIG"
fi
