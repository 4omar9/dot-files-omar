#!/bin/zsh

set -e

echo "🚀 Starting dotfiles bootstrap..."

### 1. Install Homebrew if needed
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed."
fi

### 2. Install VS Code via Homebrew Cask
if ! ls /Applications | grep -q "Visual Studio Code.app"; then
  echo "🧠 Installing Visual Studio Code..."
  brew install --cask visual-studio-code
else
  echo "✅ VS Code already installed."
fi

### 3. Install Oh My Zsh if needed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed."
fi

### 4. Clone dotfiles repo (only if not cloned manually)
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "📦 Cloning dotfiles repo..."
  git clone --bare git@github.com:hi2gage/dotfiles.git "$HOME/.dotfiles"

  echo "🔧 Checking out dotfiles..."
  alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
  dotfiles checkout
  dotfiles config --local status.showUntrackedFiles no
else
  echo "✅ Dotfiles already present."
fi

### 5. Add alias to shell config
if ! grep -q "alias dotfiles=" "$HOME/.zshrc"; then
  echo "➕ Adding dotfiles alias to .zshrc..."
  echo "alias dotfiles='git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME'" >> "$HOME/.zshrc"
fi

echo "🎉 Bootstrap complete!"