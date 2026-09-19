#!/bin/zsh
set -e

DOTFILES="$HOME/.dotfiles"

# Initialize git submodules (vim plugins)
git -C "$DOTFILES" submodule update --init --recursive

# Create directories not tracked by git
mkdir -p "$DOTFILES/.vim/backup"

# Symlink a file/directory, backing up any existing non-symlink target.
# Skip when the destination path is the source path. That link would point at itself.
link() {
    local src="$1"
    local dest="$2"
    local src_parent dest_parent src_landed dest_landed

    # Compare parent directories only. realpath on the final name follows a self-link and fails.
    src_parent=$(realpath "$(dirname "$src")" 2>/dev/null || true)
    dest_parent=$(realpath "$(dirname "$dest")" 2>/dev/null || true)
    src_landed="$src_parent/$(basename "$src")"
    dest_landed="$dest_parent/$(basename "$dest")"
    if [ -n "$src_parent" ] && [ -n "$dest_parent" ] && [ "$src_landed" = "$dest_landed" ]; then
        echo "Skip $dest (same path as $src)"
        return
    fi

    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -e "$dest" ]; then
        echo "Backing up $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -s "$src" "$dest"
    echo "Linked $dest -> $src"
}

# Top-level dotfiles
for file in .bashrc .zshrc .vimrc .tmux.conf .vim; do
    link "$DOTFILES/$file" "$HOME/$file"
done

# .config subdirectories (don't symlink all of .config)
mkdir -p "$HOME/.config"
for dir in nvim alacritty htop; do
    link "$DOTFILES/.config/$dir" "$HOME/.config/$dir"
done

# Optional local shell file.
if [ ! -e "$HOME/.bashrc_tesla" ]; then
    printf 'create ~/.bashrc_tesla? [y/N] '
    read -r reply
    case "$reply" in
        [yY]|[yY][eE][sS])
            cat > "$HOME/.bashrc_tesla" <<'EOF'
# Local shell settings. This file is not in git.
EOF
            chmod 600 "$HOME/.bashrc_tesla"
            echo "Created $HOME/.bashrc_tesla"
            ;;
        *)
            echo "Skipped ~/.bashrc_tesla"
            ;;
    esac
fi
