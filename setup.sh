#!/usr/bin/env bash
# ============================================================================
# dotfiles 交互式初始化（Linux / macOS）
# 用法：
#   ./setup.sh              # 交互式
#   ./setup.sh --list       # 只看计划
#   ./setup.sh --all        # 全部建立
#   ./setup.sh --force      # 替换冲突项
# 所有链接目标以脚本自身位置（仓库根）推导，与用户名无关
# ============================================================================
set -u

REPO="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="${HOME_DIR:-$HOME}"
ALL=0; LIST=0; FORCE=0
while [ $# -gt 0 ]; do
    case "$1" in
        --all) ALL=1 ;;
        --list) LIST=1 ;;
        --force) FORCE=1 ;;
        *) echo "未知参数: $1（支持 --all/--list/--force）"; exit 1 ;;
    esac
    shift
done

case "$(uname -s)" in
    Linux*)  OS_CONF='.gitconfig-linux.conf' ;;
    Darwin*) OS_CONF='.gitconfig-macos.conf' ;;
    *)       OS_CONF='' ;;
esac

# key|描述|链接位置(相对 HOME)|目标(相对仓库)|类型
MANIFEST="
git|Git 配置|.gitconfig|git/.gitconfig|file
ssh|SSH 配置|.ssh/config|ssh/config|file
vim|Vim 配置 (.vim)|.vim|vim|dir
nvim|Neovim 配置|.config/nvim|nvim|dir
wezterm|WezTerm 终端|.config/wezterm|wezterm|dir
tmux|Tmux 配置|.tmux.conf|.tmux.conf|file
ideavim|IntelliJ IdeaVim|.ideavimrc|.ideavimrc|file
vrapper|Eclipse vrapper|.vrapperrc|.vrapperrc|file
npm|NPM 配置|.npmrc|.npmrc|file
mpv|mpv 按键配置|.config/mpv/input.conf|mpv/input.conf|file
"

state_of() {  # $1=link $2=target(绝对)
    if [ -L "$1" ]; then
        [ "$(readlink "$1")" = "$2" ] && echo ok || echo conflict
    elif [ -e "$1" ]; then
        echo conflict
    else
        echo missing
    fi
}

mark_of() { case "$1" in ok) echo '[已链接]' ;; conflict) echo '[冲突!]' ;; *) echo '[未建立]' ;; esac; }

print_list() {
    echo
    echo "dotfiles 初始化（仓库: $REPO -> HOME: $HOME_DIR）"
    echo
    local i=0
    while IFS='|' read -r key desc link target type; do
        [ -z "$key" ] && continue
        i=$((i+1))
        lp="$HOME_DIR/$link"; tp="$REPO/$target"
        if [ ! -e "$tp" ]; then st='no_target'; mk='[仓库缺失]'
        else st=$(state_of "$lp" "$tp"); mk=$(mark_of "$st"); fi
        printf '  %2d. %-10s %-10s %s\n' "$i" "$key" "$mk" "$desc"
    done <<EOF
$MANIFEST
EOF
}

write_git_platform() {
    [ -z "$OS_CONF" ] && return
    printf '# 由 setup.sh 生成（机器本地，勿提交）\n[include]\n    path = %s/git/%s\n' \
        "$REPO" "$OS_CONF" > "$REPO/git/.gitconfig-platform"
    echo "  -> 已生成 git/.gitconfig-platform -> $OS_CONF"
}

do_link() {  # $1=link $2=target $3=key
    local lp="$1" tp="$2"
    if [ ! -e "$tp" ]; then echo "[失败] $3: 仓库中不存在 $tp"; return 2; fi
    local st; st=$(state_of "$lp" "$tp")
    if [ "$st" = ok ]; then echo "[跳过] $3: 已是正确链接"; return 1; fi
    if [ "$st" = conflict ] && [ "$FORCE" -ne 1 ]; then
        echo "[冲突] $3: $lp 已存在且不是指向本仓库（--force 替换）"; return 2
    fi
    if [ -e "$lp" ] || [ -L "$lp" ]; then rm -rf "$lp"; fi
    mkdir -p "$(dirname "$lp")"
    if ln -s "$tp" "$lp"; then
        echo "[建立] $3: $lp -> $tp (symlink)"
        [ "$3" = git ] && write_git_platform
        return 0
    else
        echo "[失败] $3: ln -s 失败"; return 2
    fi
}

print_list
[ "$LIST" -eq 1 ] && exit 0

if [ "$ALL" -eq 1 ]; then
    :
else
    printf '\n选择要建立的项（如 1,3,5；a=全部；直接回车=逐项确认；q=退出）: '
    read -r ans || exit 0
    [ "$ans" = q ] && exit 0
    if [ "$ans" != a ] && [ "$ans" != A ] && [ -n "$ans" ]; then
        # 只处理选中的编号
        NEW_MANIFEST=""
        local_i=0
        while IFS='|' read -r key desc link target type; do
            [ -z "$key" ] && continue
            local_i=$((local_i+1))
            for n in $(echo "$ans" | tr ', ' '\n' | grep -E '^[0-9]+$'); do
                [ "$n" -eq "$local_i" ] && NEW_MANIFEST="$NEW_MANIFEST$key|$desc|$link|$target|$type
"
            done
        done <<EOF
$MANIFEST
EOF
        MANIFEST="$NEW_MANIFEST"
    elif [ -z "$ans" ]; then
        # 逐项确认
        NEW_MANIFEST=""
        while IFS='|' read -r key desc link target type; do
            [ -z "$key" ] && continue
            printf '  建立 %s (%s)? [Y/n] ' "$key" "$desc"
            read -r y < /dev/tty 2>/dev/null || y=y
            case "$y" in n|N) ;; *) NEW_MANIFEST="$NEW_MANIFEST$key|$desc|$link|$target|$type
" ;; esac
        done <<EOF
$MANIFEST
EOF
        MANIFEST="$NEW_MANIFEST"
    fi
fi

created=0; skipped=0; failed=0
while IFS='|' read -r key desc link target type; do
    [ -z "$key" ] && continue
    out=$(do_link "$HOME_DIR/$link" "$REPO/$target" "$key"); rc=$?
    echo "$out"
    case $rc in
        0) created=$((created+1)) ;;
        1) skipped=$((skipped+1)) ;;
        *) failed=$((failed+1)) ;;
    esac
done <<EOF
$MANIFEST
EOF

echo
echo "完成：建立 $created，跳过 $skipped，失败/冲突 $failed"
echo
echo "后续手动步骤（按需）："
echo "  Vim 插件引导: curl -fLo ~/.vim/autoload/plug.vim --create-dirs \\"
echo "      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
echo "  然后 vim 内 :PlugInstall（或 vim -S plug-snapshot.vim 按锁定版本安装）"
