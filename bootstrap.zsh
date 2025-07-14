#!/bin/zsh

set -e
echo "🚀 Starting dotfiles bootstrap..."

# Helper Functions
install_cask_app() {
  local app_name="$1"
  local app_path="$2"
  local cask_name="$3"

  if ! ls /Applications | grep -q "$app_path"; then
    echo "🍺 Installing $app_name..."
    brew install --cask "$cask_name"
  else
    echo "✅ $app_name already installed."
  fi
}

install_brew_package() {
  local name="$1"

  if ! command -v "$name" &>/dev/null; then
    echo "🔧 Installing $name..."
    brew install "$name"
  else
    echo "✅ $name already installed."
  fi
}

install_cask_by_name() {
  local name="$1"

  if ! brew list --cask | grep -q "^${name}$"; then
    echo "🍺 Installing $name via brew cask..."
    brew install --cask "$name"
  else
    echo "✅ $name already installed."
  fi
}

# Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed."
fi

# Install apps via loop
apps=(
  "Alfred 5.app:Alfred:alfred"
  "Visual Studio Code.app:VS Code:visual-studio-code"
  "Github Desktop.app:Github Desktop:github"
  "iTerm.app:iTerm2:iterm2"
  "Postman.app:Postman:postman"
  "Rectangle.app:Rectangle:rectangle"
  "ChatGPT.app:ChatGPT:chatgpt"
  "Obsidian.app:Obsidian:obsidian"
  "Docker.app:Docker Desktop:docker"
)

for entry in "${apps[@]}"; do
  IFS=":" read -r app_path name cask <<< "$entry"
  install_cask_app "$name" "$app_path" "$cask"
done

# VS Code CLI
if [ ! -f "/usr/local/bin/code" ] && [ ! -f "/opt/homebrew/bin/code" ]; then
  echo "🔗 Enabling 'code' command for VS Code..."
  ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "/usr/local/bin/code" 2>/dev/null || \
  ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "/opt/homebrew/bin/code"
else
  echo "✅ 'code' command already set up."
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed."
fi

# Dotfiles setup
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "📦 Cloning dotfiles repo..."
  git clone --bare https://github.com/hi2gage/dot-files.git "$HOME/.dotfiles"
  echo "🔧 Checking out dotfiles..."
  alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
  # Handle potential conflicts during checkout
  if ! dotfiles checkout 2>/dev/null; then
    echo "⚠️  Backing up pre-existing dotfiles..."
    mkdir -p .dotfiles-backup
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
    dotfiles checkout
  fi
  dotfiles config --local status.showUntrackedFiles no
else
  echo "✅ Dotfiles already present."
fi

if ! grep -q "alias dotfiles=" "$HOME/.zshrc"; then
  echo "➕ Adding dotfiles alias to .zshrc..."
  echo "alias dotfiles='git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME'" >> "$HOME/.zshrc"
fi

# Create Dev directory
if [ ! -d "$HOME/Dev" ]; then
  echo "📁 Creating ~/Dev directory..."
  mkdir "$HOME/Dev"
else
  echo "✅ ~/Dev directory already exists."
fi

# CLI tools
cli_tools=(
  "opensim"
  "xcodes"
  "mise"
  "git-machete"
  "jira"
  "mint"
  "lazygit"
  "lazydocker"
  "gh"
  "node"
  "tree"
)

for tool in "${cli_tools[@]}"; do
  install_brew_package "$tool"
done

# Install global npm packages (requires Node/npm)
if command -v npm &>/dev/null; then
  # Helper to install npm package globally if not already present
  install_npm_package() {
    local package_name="$1"

    if ! npm list -g --depth=0 | grep -q "${package_name}@"; then
      echo "📦 Installing ${package_name} (npm)..."
      npm install -g "$package_name"
    else
      echo "✅ ${package_name} already installed (npm)."
    fi
  }

  # Claude Code
  install_npm_package "@anthropic-ai/claude-code"

  # OpenAI Codex
  install_npm_package "@openai/codex"
else
  echo "⚠️  npm not found. Skipping installation of global npm packages."
fi

# -----------------------------------------------------------------------------
# GitHub access setup
# -----------------------------------------------------------------------------

setup_github_access() {
  # Ensure GitHub CLI is installed (should be via brew above)
  if ! command -v gh &>/dev/null; then
    echo "🔧 Installing GitHub CLI (gh)..."
    brew install gh
  fi

  # Authenticate via GitHub CLI if not already
  if ! gh auth status &>/dev/null; then
    echo "🔑 Launching interactive GitHub authentication..."
    gh auth login
  else
    echo "✅ GitHub CLI already authenticated."
  fi

  # Generate SSH key if one doesn't exist
  if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo "🔐 Generating new SSH key (ed25519)..."
    read "github_email?📧  Enter the email associated with your GitHub account: "
    ssh-keygen -t ed25519 -C "$github_email" -f "$HOME/.ssh/id_ed25519" -N ""
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add "$HOME/.ssh/id_ed25519"
  else
    echo "✅ SSH key already exists."
  fi

  # Upload public key to GitHub, if it's not there yet
  PUB_KEY_CONTENT=$(cat "$HOME/.ssh/id_ed25519.pub")
  if ! gh ssh-key list --json key -q '.[].key' | grep -q "$PUB_KEY_CONTENT"; then
    echo "➕ Uploading SSH public key to GitHub..."
    gh ssh-key add "$HOME/.ssh/id_ed25519.pub" -t "$(hostname)"
  else
    echo "✅ SSH key already present on GitHub."
  fi
}

# Run GitHub setup
setup_github_access

# Convert dotfiles remote to SSH after GitHub setup
if [ -d "$HOME/.dotfiles" ] && command -v gh &>/dev/null && gh auth status &>/dev/null; then
  echo "🔄 Converting dotfiles remote to SSH..."
  alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
  dotfiles remote set-url origin git@github.com:hi2gage/dot-files.git
  echo "✅ Dotfiles remote converted to SSH for push access."
fi

echo "🎉 Bootstrap complete!"