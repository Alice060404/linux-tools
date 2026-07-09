# linux-tools

## 项目简介

适用于 Ubuntu VPS 的常用脚本工具集合。

## 支持系统

- Ubuntu 20.04
- Ubuntu 22.04
- Ubuntu 24.04
- Debian 系系统理论可用

## 可用脚本

| 命令 | 说明 |
|---|---|
| `vpsinfo` | 查看 VPS 基础运行状态 |
| `vpsclean` | 安全清理 APT 缓存、systemd journal 日志和过旧临时文件 |
| `5command` | 按用途分类查阅 Linux 常用命令 |

## 安装 5command

```bash
curl -fsSL https://raw.githubusercontent.com/Alice060404/linux-tools/main/install.sh | sudo bash -s 5command
```

安装后运行：

```bash
5command
```

工具会列出文件、文本、权限、系统、进程、磁盘、网络、服务、软件包、压缩、SSH、Shell、安全和容器等分类。输入分类编号即可查看相关命令及简要说明。

也可以直接查看指定分类或列出分类：

```bash
5command 7
5command --list
5command --help
```

`5command` 只显示命令说明，不会执行列表中的命令。

## 卸载 5command

```bash
curl -fsSL https://raw.githubusercontent.com/Alice060404/linux-tools/main/uninstall.sh | sudo bash -s 5command
```

## 安装 vpsclean

```bash
curl -fsSL https://raw.githubusercontent.com/Alice060404/linux-tools/main/install.sh | sudo bash -s vpsclean
```

安装脚本会从 GitHub 下载 `scripts/vpsclean`，安装到 `/usr/local/bin/vpsclean`，并添加执行权限。若本机已有同名命令或目标文件，会提示确认是否覆盖。

## 使用 vpsclean

```bash
vpsclean
vpsclean --dry-run
sudo vpsclean --apply
sudo vpsclean --yes
sudo vpsclean --help
```

可选参数：

```bash
sudo vpsclean --apply --journal-days 7 --tmp-days 7
sudo vpsclean --yes --journal-days 3 --tmp-days 10
```

- `--journal-days N`：systemd journal 只保留最近 N 天，默认 7 天。
- `--tmp-days N`：清理 `/tmp` 中超过 N 天未访问的普通文件，默认 7 天。

## 卸载 vpsclean

```bash
curl -fsSL https://raw.githubusercontent.com/Alice060404/linux-tools/main/uninstall.sh | sudo bash -s vpsclean
```

## 安装 vpsinfo

```bash
curl -fsSL https://raw.githubusercontent.com/Alice060404/linux-tools/main/install.sh | sudo bash -s vpsinfo
```

## 卸载 vpsinfo

```bash
curl -fsSL https://raw.githubusercontent.com/Alice060404/linux-tools/main/uninstall.sh | sudo bash -s vpsinfo
```

## 安全说明

- 默认 dry-run，不直接清理。
- 执行真实清理需要 root 权限。
- 不删除用户目录。
- 不删除网站目录。
- 不删除数据库目录。
- 不直接删除 `/var/log/*`。
- 不修改 SSH、防火墙、内核参数。
- 不清理 Docker。
- 不上传任何数据。
- 不执行 `apt-get autoremove`。

## 目录结构

```text
linux-tools/
├── scripts/
│   ├── 5command
│   ├── vpsinfo
│   └── vpsclean
├── install.sh
├── uninstall.sh
├── README.md
├── LICENSE
└── .gitignore
```

## 开发与更新

```bash
cd ~/linux-tools
nano scripts/vpsclean
bash -n scripts/vpsclean
git add .
git commit -m "Update vpsclean"
git push
```
