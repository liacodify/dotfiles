#!/bin/bash
set -e

DOTFILES_REPO="$HOME/dotfiles"

echo "=== Dotfiles Setup (Using Your Real Configs) ==="
echo ""

if [ "$(id -u)" -eq 0 ]; then
    echo "No ejecutes como root"
    exit 1
fi

echo "[1/6] Creando directorios necesarios..."
mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$HOME/.tmux/plugins"
mkdir -p "$HOME/.config/nvim/lua/config"
mkdir -p "$HOME/.config/nvim/lua/plugins"
mkdir -p "$HOME/.local/bin"

echo ""
echo "[2/6] Instalando Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo ""
echo "[3/6] Instalando plugins de ZSH..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo ""
echo "[4/6] Instalando Tmux TPM..."
[ ! -d "$HOME/.tmux/plugins/tpm" ] && \
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

echo ""
echo "[5/6] Creando symlinks de configs (archivos completos)..."
ln -sf "$DOTFILES_REPO/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_REPO/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_REPO/nvim" "$HOME/.config/nvim"

echo ""
echo "[6/6] Configurando env..."
cat > "$HOME/.local/bin/env" << 'EOF'
#!/bin/sh
case ":${PATH}:" in
    *:"$HOME/.local/bin":*)
        ;;
    *)
        export PATH="$HOME/.local/bin:$PATH"
        ;;
esac
EOF
chmod +x "$HOME/.local/bin/env"

echo ""
echo "=== Instalación completada ==="
echo "1. Cierra y abre terminal (o ejecuta 'exec zsh')"
echo "2. En tmux: Ctrl+b + I para instalar plugins TPM"
echo "3. Ejecuta 'nvim' y espera que LazyVim instale plugins"