#!/bin/bash
# Description: OpenWrt DIY script part 2 (After Update feeds)

sudo apt install libfuse-dev -y
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

cat > .config <<EOF
CONFIG_TARGET_mediatek=y
CONFIG_TARGET_mediatek_filogic=y
CONFIG_TARGET_mediatek_filogic_DEVICE_cmcc_rax3000m=y
EOF

for pkg in $CUSTOM_PACKAGES; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done
