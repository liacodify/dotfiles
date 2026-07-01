export LANG=C.UTF-8

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting sudo extract)

source $ZSH/oh-my-zsh.sh

alias ll='ls -lah'
alias la='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gp='git push'

# Lazy load nvm
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# iniciar tmux automáticamente
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  if tmux has-session -t main 2>/dev/null; then
    tmux attach-session -t main
  else
    tmux new-session -s main
  fi
fi

export CAPACITOR_ANDROID_STUDIO_PATH=/snap/bin/android-studio


export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# opencode
export PATH=/home/pc/.opencode/bin:$PATH


. "$HOME/.local/bin/env"

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"
