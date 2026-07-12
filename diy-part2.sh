#!/bin/bash
# Description: OpenWrt DIY script part 2 (After Update feeds)

sudo apt install libfuse-dev -y
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 1. 写入固定的硬件平台架构基础配置
cat > .config <<EOF
CONFIG_TARGET_mediatek=y
CONFIG_TARGET_mediatek_filogic=y
CONFIG_TARGET_mediatek_filogic_DEVICE_cmcc_rax3000m=y
EOF

# 2. 动态读取 GitHub Actions 环境变量并注入软件包配置
for pkg in $CUSTOM_PACKAGES; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done

# 3. 底层内核特性注入
TARGET_CONFIG="target/linux/mediatek/filogic/config-6.12"
if [ -f "$TARGET_CONFIG" ]; then
    sed -i '/CONFIG_CPU_FREQ/d' "$TARGET_CONFIG"
    echo "CONFIG_CPU_FREQ=y" >> "$TARGET_CONFIG"
    echo "CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y" >> "$TARGET_CONFIG"
    echo "CONFIG_CPU_FREQ_STAT=y" >> "$TARGET_CONFIG"
    echo "CONFIG_CPUFREQ_DT=y" >> "$TARGET_CONFIG"
fi
