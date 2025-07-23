# dot-files

My personal dotfiles for macOS setup, including configurations, scripts, and automated installation of development tools.

## 🚀 Quick Setup

Run this single command on a fresh macOS installation:

```bash
curl -fsSL https://raw.githubusercontent.com/4omar9/dot-files-omar/main/setup.sh | bash
```

Or, if you prefer to review the script first:

```bash
curl -fsSL https://raw.githubusercontent.com/4omar9/dot-files-omar/main/setup.sh -o setup.sh
# Review the script
cat setup.sh
# Run it
bash setup.sh
```

## 📦 What's Included

### Applications (via Homebrew Cask)

#### Development Tools
- Visual Studio Code
- Cursor
- Fork
- Postman
- Proxyman
- Charles
- Paw
- Dash
- DB Browser for SQLite
- Developer
- Warp

#### iOS Development
- RocketSim
- SF Symbols
- A Companion for SwiftUI
- SwiftFormat for Xcode

#### Productivity & Organization
- Raycast
- Obsidian
- Microsoft Outlook
- Fantastical
- Day One
- Flow
- Miro
- 1Password

#### Communication
- Slack
- Discord
- WhatsApp
- Zoom
- Arc

#### AI & Design
- Claude
- ChatGPT
- Figma

#### System & Utilities
- MonitorControl
- GPG Keychain
- Cloudflare WARP
- NordVPN
- Okta Extension App
- Okta Verify
- Elgato Wave Link
- Logi Options Plus

#### Entertainment
- Spotify

### CLI Tools (via Homebrew)
- gh (GitHub CLI)
- node
- jq
- starship
- swiftlint
- mint
- mise
- rbenv & ruby-build
- graphviz
- mailsy
- xcodes
- xcodegen
- xcbeautify
- xcpretty
- fastlane
- sourcery
- swiftgen
- periphery
- tuist
- chisel
- ios-deploy
- libimobiledevice
- ideviceinstaller

### NPM Global Packages
Configure any global npm packages you need in bootstrap.zsh

### Shell Configuration
- **Powerlevel10k** theme for Zsh (with fallback to Oh My Zsh)
- **Starship** prompt (when not using Powerlevel10k)
- Extensive PATH configuration for development tools
- rbenv and mise for version management
- Custom aliases for project navigation
- GPG configuration for signed commits

### Configuration Files
- `.zshrc` - Main shell configuration
- `.p10k.zsh` - Powerlevel10k configuration
- `.gitconfig` - Git configuration
- `.zshrc_private` - Private environment variables (not tracked)
- Custom scripts in `~/.local/bin`

## 📱 iOS Development Tools

### Xcode Management
- **xcodes** - Manage multiple Xcode versions
- **xcbeautify** - Beautiful Xcode build output
- **xcpretty** - Flexible and fast xcodebuild formatter

### Build & Dependency Tools
- **xcodegen** - Generate Xcode projects from spec files
- **tuist** - Create, maintain, and interact with Xcode projects at scale
- **fastlane** - Automate building and releasing iOS apps
- **mint** - Package manager for Swift command line tools

### Code Quality & Analysis
- **swiftlint** - Enforce Swift style and conventions
- **swiftformat** - Format Swift code
- **swiftgen** - Code generator for assets, strings, etc.
- **sourcery** - Meta-programming for Swift
- **periphery** - Identify unused code

### Debugging & Device Tools
- **chisel** - Collection of LLDB commands for debugging
- **ios-deploy** - Install and debug iOS apps from command line
- **libimobiledevice** - Cross-platform library for iOS device communication
- **ideviceinstaller** - Manage apps on iOS devices

### GUI Apps for iOS Development
- **RocketSim** - Enhance Xcode Simulator
- **SF Symbols** - Apple's icon library
- **Dash** - API documentation browser
- **DB Browser for SQLite** - SQLite database viewer
- **Charles/Proxyman** - HTTP proxy for debugging
- **Paw** - API testing tool

### Useful iOS Aliases & Functions
- `xc` - Open Xcode workspace/project
- `xcclean` - Clean DerivedData
- `sim` - Launch iOS Simulator
- `simlist` - List available simulators
- `ioslog` - Stream device logs
- `clean-build` - Clean all build artifacts

## 🔧 Manual Setup

If you prefer to set things up manually:

1. Clone the repository as a bare repo:
   ```bash
   git clone --bare https://github.com/4omar9/dot-files-omar.git $HOME/.dotfiles
   ```

2. Define the alias:
   ```bash
   alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
   ```

3. Checkout the files:
   ```bash
   dotfiles checkout
   ```

4. Set Git to not show untracked files:
   ```bash
   dotfiles config --local status.showUntrackedFiles no
   ```

5. Run the bootstrap script:
   ```bash
   zsh ~/bootstrap.zsh
   ```

## 📝 Managing Dotfiles

After setup, you can manage your dotfiles using the `dotfiles` command:

```bash
# Check status
dotfiles status

# Add a new file
dotfiles add ~/.newconfig

# Commit changes
dotfiles commit -m "Add new configuration"

# Push to GitHub
dotfiles push
```

## 🔑 GitHub Authentication

The setup script will help you configure GitHub access. Make sure you have:
- A GitHub account
- Your GitHub email address ready
- GitHub CLI will guide you through the authentication process

## 📂 Structure

- `bootstrap.zsh` - Main installation script for apps and tools
- `setup.sh` - One-liner setup script for complete installation
- `.local/bin/` - Custom shell scripts and utilities
  - `github/` - GitHub-related scripts
  - `ios-pr-scripts/` - iOS PR workflow scripts
  - `jira-scripts/` - JIRA integration scripts
  - `sync-fork` - Fork synchronization utility

## 🛠️ Customization

Feel free to fork this repository and customize it for your own needs. The main files to modify are:
- `bootstrap.zsh` - Add/remove applications and tools
- `.zshrc` - Shell configuration (will be created after setup)
- Scripts in `.local/bin/` - Add your own utility scripts
