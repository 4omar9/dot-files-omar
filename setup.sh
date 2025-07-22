#!/bin/bash

# Complete macOS setup script with dotfiles management
# Usage: curl -fsSL https://raw.githubusercontent.com/omasri/dot-files-omar/main/setup.sh | bash

set -e

echo "🚀 Starting complete macOS setup with dotfiles..."

# Function to handle existing files during checkout
backup_conflicting_files() {
    echo "📦 Backing up any conflicting files..."
    BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Get list of files that would be overwritten
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout 2>&1 | grep -E "^\s" | awk '{print $1}' | while read -r file; do
        if [ -f "$HOME/$file" ]; then
            echo "  Backing up: $file"
            mkdir -p "$BACKUP_DIR/$(dirname "$file")"
            mv "$HOME/$file" "$BACKUP_DIR/$file"
        fi
    done
    
    if [ -z "$(ls -A "$BACKUP_DIR")" ]; then
        rmdir "$BACKUP_DIR"
        echo "  No conflicts found."
    else
        echo "  Backed up files to: $BACKUP_DIR"
    fi
}

# Clone dotfiles as bare repository
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "📦 Cloning dotfiles repository..."
    # Use HTTPS for initial clone (no auth needed for public repos)
    git clone --bare https://github.com/omasri/dot-files-omar.git "$HOME/.dotfiles"
    
    # Define the dotfiles alias function for this session
    function dotfiles {
        git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"
    }
    
    # Try to checkout, backing up conflicts if needed
    if ! dotfiles checkout 2>/dev/null; then
        echo "⚠️  Found existing files that would be overwritten."
        backup_conflicting_files
        dotfiles checkout
    fi
    
    # Set git to not show untracked files
    dotfiles config --local status.showUntrackedFiles no
    
    echo "✅ Dotfiles repository set up successfully!"
else
    echo "✅ Dotfiles repository already exists."
fi

# Ensure the bootstrap script is available
if [ -f "$HOME/bootstrap.zsh" ]; then
    echo "🔧 Running bootstrap.zsh..."
    zsh "$HOME/bootstrap.zsh"
else
    echo "❌ bootstrap.zsh not found in home directory. Downloading..."
    curl -fsSL https://raw.githubusercontent.com/omasri/dot-files-omar/main/bootstrap.zsh -o "$HOME/bootstrap.zsh"
    chmod +x "$HOME/bootstrap.zsh"
    zsh "$HOME/bootstrap.zsh"
fi

# Ensure .local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo "📝 Adding ~/.local/bin to PATH in .zshrc..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# Make all scripts in .local/bin executable
if [ -d "$HOME/.local/bin" ]; then
    echo "🔧 Making scripts in ~/.local/bin executable..."
    find "$HOME/.local/bin" -type f -name "*.sh" -exec chmod +x {} \;
    find "$HOME/.local/bin" -type f ! -name "*.*" -exec chmod +x {} \;
fi

echo "✨ Complete setup finished!"
echo ""
echo "📌 Next steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc"
echo "   2. Your dotfiles are managed with: dotfiles <git commands>"
echo "   3. Example: dotfiles status, dotfiles add <file>, dotfiles commit"
echo ""
echo "🔑 GitHub Access:"
echo "   - The bootstrap script sets up GitHub CLI and SSH keys"
echo "   - Remote is automatically converted to SSH after authentication"
echo "   - You can now push changes with: dotfiles push"