# ImmortalWrt 25.12 for CMCC RAX3000M

此项目用于依托 GitHub Actions 云端资源，为中国移动 RAX3000M (NAND 闪存版本) 路由器全自动编译 ImmortalWrt 25.12 定制固件。

基于极简与高可用性原则，该工作流已彻底重构。移除了原版模板中脆弱的第三方图床依赖、失效的短链接组件、冗余的 SSH 调试探针以及频繁请求上游的定时检测脚本。配置系统由传统的静态 `.config` 文件挂载模式升级为顶层环境变量动态注入模式，有效杜绝了跨版本编译时的依赖树冲突。

## 架构规格

* **底层源码**：ImmortalWrt 官方主线 `openwrt-25.12` 分支
* **系统内核**：Linux 6.6
* **目标硬件**：MediaTek MT7981B (Filogic 820) / CMCC RAX3000M NAND

## 固件编译与提取流程

构建过程完全独立执行，不产生冗余的 Release 发布记录，所有产物作为临时构件保留，降低仓库空间占用与维护成本。

1. 访问本仓库的 Actions 面板。
2. 在左侧工作流导航树中选中 `Build OpenWrt`。
3. 点击右侧出现的 `Run workflow` 手动执行编译任务。
4. 云端实例分配与交叉编译耗时约 2 小时。任务标记为绿色成功状态后，点击进入该条目的详情页面。
5. 滚动至页面最下方的 `Artifacts` 区域，点击下载生成的固件压缩包。升级时请使用包内以 `sysupgrade.itb` 结尾的文件。

## 模块化定制指南

业务层组件与底层架构已实现物理隔离。如需调整编译预装的插件，无需介入复杂的源码层配置文件：

1. 编辑 `.github/workflows/build-openwrt.yml` 文件。
2. 定位至顶层 `env` 声明区域。
3. 修改 `CUSTOM_PACKAGES` 变量的值。填入所需的 `luci-app-` 或 `kmod-` 模块名称，各项之间以单个空格分隔。
4. 保存提交后，下一次触发的编译将自动集成对应组件。

## 基础架构鸣谢

* P3TERX (Actions-OpenWrt 自动化框架基础)
* OpenWrt Project
* ImmortalWrt Project
