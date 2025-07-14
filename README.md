# dot-files

My personal dotfiles for macOS setup, including configurations, scripts, and automated installation of development tools.

## 🚀 Quick Setup

Run this single command on a fresh macOS installation:

```bash
curl -fsSL https://raw.githubusercontent.com/hi2gage/dot-files/main/setup.sh | bash
```

Or, if you prefer to review the script first:

```bash
curl -fsSL https://raw.githubusercontent.com/hi2gage/dot-files/main/setup.sh -o setup.sh
# Review the script
cat setup.sh
# Run it
bash setup.sh
```

## 📦 What's Included

### Applications (via Homebrew Cask)
- Alfred 5
- Visual Studio Code
- GitHub Desktop
- iTerm2
- Postman
- Rectangle
- ChatGPT
- Obsidian
- Docker Desktop
- Slack

### CLI Tools (via Homebrew)
- opensim
- xcodes
- mise
- git-machete
- jira
- mint
- lazygit
- lazydocker
- gh (GitHub CLI)
- node
- tree

### NPM Global Packages
- @anthropic-ai/claude-code
- @openai/codex

### Configuration
- Oh My Zsh setup
- Custom scripts in `~/.local/bin`
- Git configuration
- Shell aliases and functions

## 🔧 Manual Setup

If you prefer to set things up manually:

1. Clone the repository as a bare repo:
   ```bash
   git clone --bare https://github.com/hi2gage/dot-files.git $HOME/.dotfiles
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