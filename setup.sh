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
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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
echo "[5/8] Instalando Tmux..."
if ! command -v tmux &> /dev/null; then
    sudo apt install -y tmux
fi
mkdir -p "$HOME/.tmux/plugins"
[ ! -d "$HOME/.tmux/plugins/tpm" ] && \
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

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
echo "[7/8] Instalando Neovim..."
if ! command -v nvim &> /dev/null; then
    sudo apt install -y neovim
fi
mkdir -p "$HOME/.config/nvim/lua/config"
mkdir -p "$HOME/.config/nvim/lua/plugins"

echo ""
echo "[8/8] Creando symlinks de configs..."
ln -sf "$DOTFILES_REPO/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_REPO/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_REPO/nvim" "$HOME/.config/nvim"

mkdir -p "$HOME/.local/bin"
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
echo "=== Instalación completada ==="
echo ""
echo "PASOS FINALES:"
echo "1. Cierra terminal y abre nueva (o ejecuta 'exec zsh')"
echo "2. En tmux presiona Ctrl+b luego I para instalar plugins TPM"
echo "3. Ejecuta 'nvim' y espera que LazyVim instale plugins"
echo "4. Reinicia la terminal para cargar nvm"