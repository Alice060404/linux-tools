#!/usr/bin/env bash

# Generic uninstaller for scripts installed from Alice060404/linux-tools.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Alice060404/linux-tools/main/uninstall.sh | sudo bash -s vpsclean

set -u

INSTALL_DIR="/usr/local/bin"

die() {
    printf '错误：%s\n' "$*" >&2
    exit 1
}

info() {
    printf '%s\n' "$*"
}

check_root() {
    if [ "${EUID:-$(id -u)}" -ne 0 ]; then
        die "请使用 root 用户运行，或通过 sudo 执行卸载命令。"
    fi
}

check_script_name() {
    local script_name="$1"

    [ -n "$script_name" ] || die "未传入脚本名。用法：sudo bash uninstall.sh <script-name>，例如 vpsinfo 或 vpsclean。"

    case "$script_name" in
        .|..|*/*|*\\*|"")
            die "脚本名不合法：$script_name"
            ;;
    esac

    if ! printf '%s' "$script_name" | grep -Eq '^[A-Za-z0-9._-]+$'; then
        die "脚本名只能包含字母、数字、点、下划线和短横线：$script_name"
    fi
}

main() {
    local script_name="${1:-}"
    local target=""
    local existing_path=""

    check_root
    check_script_name "$script_name"

    target="${INSTALL_DIR}/${script_name}"

    if [ -e "$target" ]; then
        rm -f "$target" || die "删除失败：$target"
        info "已卸载：$target"
    else
        info "未找到安装文件：$target"
    fi

    existing_path="$(command -v "$script_name" 2>/dev/null || true)"
    if [ -n "$existing_path" ]; then
        info "注意：系统中仍存在同名命令：$existing_path"
        info "该路径不是本卸载脚本管理的目标文件，请按需手动检查。"
    fi
}

main "$@"
