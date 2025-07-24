#!/bin/zsh

set -e
echo "🚀 Starting dotfiles bootstrap..."

# Define dotfiles function for the entire script
function dotfiles {
  git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"
}

# Helper Functions
install_cask_app() {
  local app_name="$1"
  local app_path="$2"
  local cask_name="$3"

  if [ ! -e "/Applications/$app_path" ]; then
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
  "Raycast.app:raycast"
  "Claude.app:claude"
  "Visual Studio Code.app:VS Code:visual-studio-code"
  "Postman.app:Postman:postman"
  "ChatGPT.app:ChatGPT:chatgpt"
  "Obsidian.app:Obsidian:obsidian"
  "Microsoft Outlook.app:microsoft-outlook"
  "Arc.app:Arc:arc"
  "Discord.app:Discord:discord"
  "Slack.app:Slack:slack"
  "Spotify.app:Spotify:spotify"
  "WhatsApp.app:WhatsApp:whatsapp"
  "Warp.app:Warp:warp"
  "Cursor.app:Cursor:cursor"
  "Fork.app:Fork:fork"
  "Proxyman.app:Proxyman:proxyman"
  "MonitorControl.app:MonitorControl:monitorcontrol"
  "1Password.app:1Password:1password"
  "Figma.app:Figma:figma"
  "Fantastical.app:Fantastical:fantastical"
  "NordVPN.app:NordVPN:nordvpn"
  "RocketSim.app:RocketSim:rocketsim-for-xcode"
  "SF Symbols.app:SF Symbols:sf-symbols"
  "Dash.app:Dash:dash"
  "DB Browser for SQLite.app:db-browser-for-sqlite"
  "Charles.app:Charles:charles"
  "Paw.app:Paw:paw"
  "A Companion for SwiftUI.app:swiftui-companion"
  "Developer.app:Developer:apple-developer"
  "Flow.app:Flow:flow"
  "Day One.app:Day One:day-one"
  "GPG Keychain.app:GPG Keychain:gpg-suite"
  "zoom.us.app:Zoom:zoom"
  "Elgato Wave Link.app:elgato-wave-link"
  "logioptionsplus.app:logi-options-plus"
  "Cloudflare WARP.app:cloudflare-warp"
  "Okta Extension App.app:okta-extension-app"
  "Okta Verify.app:Okta Verify:okta-verify"
  "Miro.app:Miro:miro"
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

# Install Oh My Zsh or Powerlevel10k
if [ ! -d "$HOME/powerlevel10k" ]; then
  echo "💡 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
else
  echo "✅ Powerlevel10k already installed."
fi


# Dotfiles setup
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "📦 Cloning dotfiles repo..."
  git clone --bare https://github.com/4omar9/dot-files-omar.git "$HOME/.dotfiles"
  echo "🔧 Checking out dotfiles..."
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

# Create necessary directories
if [ ! -d "$HOME/Dev" ]; then
  echo "📁 Creating ~/Dev directory..."
  mkdir "$HOME/Dev"
else
  echo "✅ ~/Dev directory already exists."
fi

if [ ! -d "$HOME/Projects" ]; then
  echo "📁 Creating ~/Projects directory..."
  mkdir "$HOME/Projects"
else
  echo "✅ ~/Projects directory already exists."
fi

# CLI tools
cli_tools=(
  "gh"
  "node"
  "jq"
  "starship"
  "swiftlint"
  "mint"
  "mise"
  "rbenv"
  "ruby-build"
  "graphviz"
  "mailsy"
  "xcodes"
  "xcodegen"
  "xcbeautify"
  "xcpretty"
  "fastlane"
  "sourcery"
  "swiftgen"
  "periphery"
  "tuist"
  "chisel"
  "ios-deploy"
  "libimobiledevice"
  "ideviceinstaller"
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

  # Note: Add your own npm packages here as needed
  # Example:
  # install_npm_package "prettier"
  # install_npm_package "typescript"
  # install_npm_package "@vue/cli"
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
  dotfiles remote set-url origin git@github.com:4omar9/dot-files-omar.git
  echo "✅ Dotfiles remote converted to SSH for push access."
fi

# Install Cask apps that need special handling
install_cask_by_name "swiftformat-for-xcode"

# Setup rbenv
if command -v rbenv &>/dev/null; then
  echo "🔧 Setting up rbenv..."
  rbenv init || true
  # Install Ruby 3.3.5 if not present
  if ! rbenv versions | grep -q "3.3.5"; then
    echo "💎 Installing Ruby 3.3.5..."
    rbenv install 3.3.5
    rbenv global 3.3.5
  fi
  
  # Install bundler and iOS development gems
  echo "💎 Installing bundler and iOS gems..."
  gem install bundler
  gem install xcpretty
  gem install fastlane
  rbenv rehash
else
  echo "⚠️  rbenv not found."
fi

# Setup mise
if command -v mise &>/dev/null; then
  echo "🔧 Setting up mise..."
  mise activate zsh || true
else
  echo "⚠️  mise not found."
fi

# Install iOS development tools via Mint
if command -v mint &>/dev/null; then
  echo "🌿 Installing iOS tools via Mint..."
  # Only install via Mint if not already installed via Homebrew
  if ! command -v swiftgen &>/dev/null; then
    mint install SwiftGen/SwiftGen
  fi
  if ! command -v sourcery &>/dev/null; then
    mint install krzysztofzablocki/Sourcery
  fi
  if ! command -v periphery &>/dev/null; then
    mint install peripheryapp/periphery
  fi
  # Note: SwiftLint and SwiftFormat are already installed via Homebrew
else
  echo "⚠️  Mint not found. Skipping Mint-based iOS tools."
fi

# Configure Xcode command line tools
if command -v xcode-select &>/dev/null; then
  echo "🛠️  Ensuring Xcode command line tools are installed..."
  xcode-select --install 2>/dev/null || echo "✅ Xcode command line tools already installed."
fi

# Install simulators
if command -v xcodes &>/dev/null; then
  echo "📱 Setting up iOS simulators..."
  # List available Xcode versions but don't install automatically
  echo "Available Xcode versions:"
  xcodes list
  echo "To install a specific Xcode version, run: xcodes install <version>"
fi

# Setup private configuration
setup_private_config() {
  echo ""
  echo "🔐 Setting up private configuration..."
  
  if [ ! -f "$HOME/.zshrc_private" ]; then
    echo "📝 Creating .zshrc_private for sensitive data..."
    
    # Copy template if it exists
    if [ -f "$HOME/.zshrc_private.template" ]; then
      cp "$HOME/.zshrc_private.template" "$HOME/.zshrc_private"
    else
      touch "$HOME/.zshrc_private"
    fi
    
    echo ""
    echo "Would you like to configure API keys and credentials now? (y/n)"
    read -r configure_now
    
    if [[ "$configure_now" == "y" ]]; then
      # Git configuration
      echo ""
      echo "📧 Git Configuration:"
      read -p "Enter your full name for Git commits: " git_name
      read -p "Enter your email for Git commits: " git_email
      
      # Update .gitconfig
      if [ -f "$HOME/.gitconfig" ]; then
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
      fi
      
      # Jira configuration
      echo ""
      echo "🎫 Jira Configuration (press Enter to skip):"
      read -p "Enter your Jira email: " jira_user
      read -p "Enter your Jira API token: " jira_token
      
      if [ -n "$jira_user" ]; then
        echo "export JIRA_USER=\"$jira_user\"" >> "$HOME/.zshrc_private"
      fi
      if [ -n "$jira_token" ]; then
        echo "export JIRA_TOKEN=\"$jira_token\"" >> "$HOME/.zshrc_private"
      fi
      
      # API Keys
      echo ""
      echo "🔑 API Keys (press Enter to skip any):"
      read -p "Enter your OpenAI API key: " openai_key
      read -p "Enter your Anthropic API key: " anthropic_key
      read -p "Enter your Google Gemini API key: " gemini_key
      
      if [ -n "$openai_key" ]; then
        echo "export OPENAI_API_KEY=\"$openai_key\"" >> "$HOME/.zshrc_private"
      fi
      if [ -n "$anthropic_key" ]; then
        echo "export ANTHROPIC_API_KEY=\"$anthropic_key\"" >> "$HOME/.zshrc_private"
      fi
      if [ -n "$gemini_key" ]; then
        echo "export GEMINI_API_KEY=\"$gemini_key\"" >> "$HOME/.zshrc_private"
      fi
      
      # Project-specific
      echo ""
      echo "🏢 Company/Project Configuration (press Enter to skip):"
      read -p "Enter your Apple Developer username: " apple_dev_user
      read -p "Enter your Firebase project ID: " firebase_project
      
      if [ -n "$apple_dev_user" ]; then
        echo "export APPLE_DEVELOPER_USERNAME=\"$apple_dev_user\"" >> "$HOME/.zshrc_private"
      fi
      if [ -n "$firebase_project" ]; then
        echo "export GOOGLE_CLOUD_PROJECT=\"$firebase_project\"" >> "$HOME/.zshrc_private"
      fi
      
      echo ""
      echo "✅ Private configuration saved to ~/.zshrc_private"
      echo "💡 You can always edit this file later to add or update values"
    else
      echo ""
      echo "⚠️  Skipping configuration. You can set up your private config later by:"
      echo "   1. Copying ~/.zshrc_private.template to ~/.zshrc_private"
      echo "   2. Filling in your API keys and credentials"
    fi
  else
    echo "✅ Private configuration already exists at ~/.zshrc_private"
  fi
}

# Run private config setup
setup_private_config

echo "🎉 Bootstrap complete!"
