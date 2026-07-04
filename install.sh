#!/usr/bin/env bash

# Generic installer for scripts in Alice060404/linux-tools.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Alice060404/linux-tools/main/install.sh | sudo bash -s vpsinfo

set -u

REPO_RAW_BASE="https://raw.githubusercontent.com/Alice060404/linux-tools/main"
INSTALL_DIR="/usr/local/bin"

die() {
    printf '错误：%s\n' "$*" >&2
    exit 1
}

info() {
    printf '%s\n' "$*"
}

confirm() {
    local prompt="$1"
    local answer=""

    if [ ! -r /dev/tty ]; then
        die "$prompt 需要交互确认，请在终端中运行安装命令。"
    fi

    printf '%s [y/N]: ' "$prompt" >/dev/tty
    read -r answer </dev/tty
    case "$answer" in
        y|Y|yes|YES|Yes)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

check_os() {
    local id="" id_like=""

    [ -r /etc/os-release ] || die "无法读取 /etc/os-release，无法确认系统类型。"

    # shellcheck disable=SC1091
    . /etc/os-release
    id="${ID:-}"
    id_like="${ID_LIKE:-}"

    case " $id $id_like " in
        *" ubuntu "*|*" debian "*)
            return 0
            ;;
        *)
            die "当前系统不是 Ubuntu/Debian 系 Linux，已停止安装。"
            ;;
    esac
}

check_root() {
    if [ "${EUID:-$(id -u)}" -ne 0 ]; then
        die "请使用 root 用户运行，或通过 sudo 执行安装命令。"
    fi
}

check_script_name() {
    local script_name="$1"

    [ -n "$script_name" ] || die "未传入脚本名。用法：sudo bash install.sh vpsinfo"

    case "$script_name" in
        .|..|*/*|*\\*|"")
            die "脚本名不合法：$script_name"
            ;;
    esac

    if ! printf '%s' "$script_name" | grep -Eq '^[A-Za-z0-9._-]+$'; then
        die "脚本名只能包含字母、数字、点、下划线和短横线：$script_name"
    fi
}

check_conflict() {
    local script_name="$1"
    local target="$2"
    local existing_path=""

    existing_path="$(command -v "$script_name" 2>/dev/null || true)"

    if [ -n "$existing_path" ]; then
        info "检测到 $script_name 已存在：$existing_path"

        if [ "$existing_path" = "$target" ]; then
            confirm "是否覆盖 $target？" || die "用户取消安装。"
        else
            info "系统中已经存在同名命令，继续安装可能造成命令优先级冲突。"
            confirm "是否继续安装到 $target？" || die "用户取消安装。"
        fi
    fi

    if [ -e "$target" ] && [ "$existing_path" != "$target" ]; then
        info "检测到目标文件已存在：$target"
        confirm "是否覆盖 $target？" || die "用户取消安装。"
    fi
}

main() {
    local script_name="${1:-}"
    local script_url=""
    local target=""
    local tmp_file=""

    check_os
    check_root
    check_script_name "$script_name"

    command -v curl >/dev/null 2>&1 || die "未检测到 curl，无法从 GitHub 下载脚本。"

    script_url="${REPO_RAW_BASE}/scripts/${script_name}"
    target="${INSTALL_DIR}/${script_name}"

    info "检查远程脚本：$script_url"
    curl -fsSI --connect-timeout 5 --max-time 10 "$script_url" >/dev/null \
        || die "远程脚本不存在或暂时无法访问：$script_url"

    check_conflict "$script_name" "$target"

    tmp_file="$(mktemp)" || die "无法创建临时文件。"
    trap 'rm -f "$tmp_file"' EXIT

    curl -fsSL --connect-timeout 5 --max-time 30 "$script_url" -o "$tmp_file" \
        || die "下载脚本失败：$script_url"

    mkdir -p "$INSTALL_DIR" || die "无法创建安装目录：$INSTALL_DIR"
    cp "$tmp_file" "$target" || die "无法安装到：$target"
    chmod +x "$target" || die "无法添加可执行权限：$target"

    info "安装完成：$target"
    info "现在可以运行："
    info "  $script_name"
}

main "$@"
