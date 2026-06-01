#!/bin/bash
set -e

DOTFILES_REPO="$HOME/dotfiles"

echo "=== Dotfiles Setup (Your Real Configs) ==="
echo ""

if [ "$(id -u)" -eq 0 ]; then
    echo "No ejecutes como root"
    exit 1
fi

echo "[1/8] Actualizando sistema..."
sudo apt update
sudo apt install -y git curl wget build-essential libuv1-dev python3-venv ripper fd-find

echo ""
echo "[2/8] Instalando ZSH..."
if ! command -v zsh &> /dev/null; then
    sudo apt install -y zsh
fi

echo ""
echo "[3/8] Instalando Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ] || [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Verificar instalación
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    echo "ERROR: Oh My Zsh no se instaló correctamente"
    echo "Intentando instalación manual..."
    rm -rf "$HOME/.oh-my-zsh"
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

echo ""
echo "[4/8] Instalando plugins de ZSH..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
mkdir -p "$ZSH_CUSTOM/plugins"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo ""
echo "[5/8] Instalando Tmux y plugins..."
if ! command -v tmux &> /dev/null; then
    sudo apt install -y tmux
fi
mkdir -p "$HOME/.tmux/plugins"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if [ ! -f "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh" ]; then
    echo "TPM no encontrado, intentando reinstall..."
    rm -rf "$HOME/.tmux/plugins/tpm"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if [ -f "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh" ]; then
    echo "Instalando plugins de tmux (puede tardar)..."
    bash "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"
else
    echo "ADVERTENCIA: TPM no se instaló correctamente"
    echo "Después de ejecutar este script, abre tmux y presiona Ctrl+b luego I"
fi

echo ""
echo "[6/8] Instalando NVM y Node LTS..."
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts

echo ""
echo "[7/8] Instalando Neovim (última versión)..."
if ! command -v nvim &> /dev/null; then
    curl -fsSL https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz
    sudo tar -xzf /tmp/nvim.tar.gz -C /opt/
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    rm /tmp/nvim.tar.gz
fi
mkdir -p "$HOME/.config/nvim/lua/config"
mkdir -p "$HOME/.config/nvim/lua/plugins"

echo ""
echo "[8/9] Creando symlinks de configs y archivos LazyVim..."
mkdir -p "$HOME/.config/nvim/lua/config"
mkdir -p "$HOME/.config/nvim/lua/plugins"
mkdir -p "$HOME/.local/bin"

ln -sf "$DOTFILES_REPO/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_REPO/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_REPO/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -sf "$DOTFILES_REPO/nvim/lua/config/lazy.lua" "$HOME/.config/nvim/lua/config/lazy.lua"
ln -sf "$DOTFILES_REPO/nvim/lua/config/options.lua" "$HOME/.config/nvim/lua/config/options.lua"
ln -sf "$DOTFILES_REPO/nvim/lua/config/keymaps.lua" "$HOME/.config/nvim/lua/config/keymaps.lua"
ln -sf "$DOTFILES_REPO/nvim/lua/config/autocmds.lua" "$HOME/.config/nvim/lua/config/autocmds.lua"
ln -sf "$DOTFILES_REPO/nvim/lua/plugins/"*.lua "$HOME/.config/nvim/lua/plugins/"
ln -sf "$DOTFILES_REPO/nvim/stylua.toml" "$HOME/.config/nvim/stylua.toml"
ln -sf "$DOTFILES_REPO/nvim/lazyvim.json" "$HOME/.config/nvim/lazyvim.json"

cat > "$HOME/.local/bin/env" << 'ENVEOF'
#!/bin/sh
case ":${PATH}:" in
    *:"$HOME/.local/bin":*)
        ;;
    *)
        export PATH="$HOME/.local/bin:$PATH"
        ;;
esac
ENVEOF
chmod +x "$HOME/.local/bin/env"

echo ""
echo "[9/9] Cambiando shell por defecto a ZSH..."
chsh -s "$(which zsh)"