#!/bin/zsh

set -e

echo "🚀 Starting dotfiles bootstrap..."

### Install Homebrew if needed
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed."
fi

### Install Alfred if needed
if ! ls /Applications | grep -q "Alfred 5.app"; then
  echo "🍺 Installing Alfred..."
  brew install --cask alfred
else
  echo "✅ Alfred already installed."
fi

### Install VS Code via Homebrew Cask
if ! ls /Applications | grep -q "Visual Studio Code.app"; then
  echo "🧠 Installing Visual Studio Code..."
  brew install --cask visual-studio-code
else
  echo "✅ VS Code already installed."
fi

### Enable 'code' command for VS Code
if [ ! -f "/usr/local/bin/code" ] && [ ! -f "/opt/homebrew/bin/code" ]; then
  echo "🔗 Enabling 'code' command for VS Code..."
  ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
    "/usr/local/bin/code" 2>/dev/null || \
  ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
    "/opt/homebrew/bin/code"
else
  echo "✅ 'code' command already set up."
fi

### Install Github Desktop via Homebrew Cask
if ! ls /Applications | grep -q "Github Desktop.app"; then
  echo "🧠 Installing Visual Studio Code..."
  brew install --cask github
else
  echo "✅ Github Desktop already installed."
fi



### Install OpenSim via Homebrew Cask
if ! brew list --cask | grep -q "^opensim$"; then
  echo "Installing OpenSim…"
  brew install --cask opensim
else
  echo "OpenSim already installed"
fi

### Install iTerm2 via Homebrew Cask
if ! ls /Applications | grep -q "iTerm.app"; then
  echo "🧠 Installing iTerm2..."
  brew install --cask iterm2
else
  echo "✅ iTerm2 already installed."
fi

### Install Postman via Homebrew Cask
if ! ls /Applications | grep -q "Postman.app"; then
  echo "🧠 Installing Postman..."
  brew install --cask postman
else
  echo "✅ Postman already installed."
fi

### Install Rectangle via Homebrew Cask
if ! ls /Applications | grep -q "Rectangle.app"; then
  echo "🧠 Installing Rectangle..."
  brew install --cask rectangle
else
  echo "✅ Rectangle already installed."
fi

### Install ChatGPT via Homebrew Cask
if ! ls /Applications | grep -q "ChatGPT.app"; then
  echo "🧠 Installing ChatGPT..."
  brew install --cask chatgpt
else
  echo "✅ ChatGPT already installed."
fi

### Install Obsidian via Homebrew Cask
if ! ls /Applications | grep -q "obsidian.app"; then
  echo "🧠 Installing Obsidian..."
  brew install --cask obsidian
else
  echo "✅ Obsidian already installed."
fi

### Install Oh My Zsh if needed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed."
fi

### Clone dotfiles repo (only if not cloned manually)
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

### Add alias to shell config
if ! grep -q "alias dotfiles=" "$HOME/.zshrc"; then
  echo "➕ Adding dotfiles alias to .zshrc..."
  echo "alias dotfiles='git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME'" >> "$HOME/.zshrc"
fi

### Create Dev directory
if [ ! -d "$HOME/Dev" ]; then
  echo  "📁 Creating ~/Dev directory..."
  mkdir "$HOME/Dev"
else
  echo "✅ ~/Dev directory already exists."
fi

### Install xcodes if needed
if ! command -v xcodes &>/dev/null; then
  echo "🛠 Installing xcodes..."
  brew install xcodesorg/made/xcodes
else
  echo "✅ xcodes already installed."
fi

### Install mise if needed
if ! command -v mise &>/dev/null; then
  echo "🧰 Installing mise..."
  curl https://mise.run | sh
else
  echo "✅ mise already installed."
fi

### Install Git Machete if needed
if ! command -v git-machete &>/dev/null; then
  echo "🔧 Installing Git Machete..."
  brew install git-machete
else
  echo "✅ Git Machete already installed."
fi

### Install JIRA CLI if needed
if ! command -v jira &>/dev/null; then
  echo "🔧 Installing JIRA CLI (jira)..."
  brew install jira-cli
else
  echo "✅ JIRA CLI already installed."
fi

### Install mint if needed
if ! command -v mint &>/dev/null; then
  echo "🔧 Installing mint..."
  brew install mint
else
  echo "✅ mint already installed."
fi


### Install LazyGit if needed
if ! command -v lazygit &>/dev/null; then
  echo "🌀 Installing LazyGit..."
  brew install lazygit
else
  echo "✅ LazyGit already installed."
fi


### Install Docker Desktop if needed
# (bundles the Docker daemon, CLI, buildx, compose, etc.)
if ! ls /Applications | grep -q "Docker.app"; then
  echo "🐳 Installing Docker Desktop..."
  brew install --cask docker
  echo "⚠️  Launch Docker Desktop once to finish setup & grant daemon privileges:"
  echo "    open -a Docker"
else
  echo "✅ Docker Desktop already installed."
fi

### Install LazyDocker if needed
if ! command -v lazydocker &>/dev/null; then
  echo "🛠 Installing LazyDocker..."
  brew install lazydocker
else
  echo "✅ LazyDocker already installed."
fi

echo "🎉 Bootstrap complete!"

echo "🎉 Bootstrap complete!"
