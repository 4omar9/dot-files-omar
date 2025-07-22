# If you come from Bash you might have to adjust your PATH. We'll configure PATH
# in a dedicated section below, so no need for a separate export here.

# Path to your oh-my-zsh installation.
# Theme configuration - Powerlevel10k takes precedence if available
if [ -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]; then
  source ~/powerlevel10k/powerlevel10k.zsh-theme
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Load private, untracked secrets if they exist
if [ -f "$HOME/.zshrc_private" ]; then
  source "$HOME/.zshrc_private"
fi

# Load Fetch-specific config if it exists
# source ~/.fetch-stuff.zsh

# --- PATH configuration ----------------------------------------------------
# Prepend commonly-used local paths then let Homebrew and system paths follow.
# Use unique array to avoid duplicates when the file is sourced multiple times.
typeset -U path PATH

# User binaries
path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$HOME/.local/bin/jira-scripts"
  "$HOME/.local/bin/github"

  # Go toolchains
  "$HOME/go/bin"
  "/opt/homebrew/opt/go/libexec/bin"

  # Homebrew default locations
  "/opt/homebrew/bin"
  "/usr/local/bin"
  
  # Ruby via rbenv or mise
  "$HOME/.local/share/mise/installs/ruby/3.3.5/bin"
  "$HOME/.rbenv/shims"
  
  $path
)

# Export the joined PATH string
PATH=$(IFS=:; echo "${path[*]}")

# Set theme only if not using Powerlevel10k
if [ ! -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]; then
  ZSH_THEME="robbyrussell"
fi

HIST_STAMPS="mm/dd/yyyy"

plugins=(
    gitfast
    git
    gh 
    gitignore
    zsh-autosuggestions
    copybuffer
    macos
    docker
    docker-compose
    alias-finder
)

# Setting up alias-finder display settings
zstyle ':omz:plugins:alias-finder' autoload yes

source $ZSH/oh-my-zsh.sh

alias a="sed -n '/# Aliases Start/,/# Aliases End/{
  /# Aliases Start/b
  /# Aliases End/b
  p
}' ~/.zshrc | sed -E 's/^alias ([^=]+)=/\x1b[96;4m\1\x1b[0m=/'"
# Aliases Start

alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias ios="open *.xcodeproj"
alias tok="~/./Dev/scripts/get_auth_token.sh"
alias gapp="cd ~/Dev/groupionary/groupinary-app"
alias ggraph="cd ~/Dev/groupionary/groupionary-graph"
alias dev="git co development"
alias devp="dev && git pull"
alias devpp="devp"
alias prcreate="gh pr create -B develop -t"
alias rt="./runtests.zsh"
alias xx="killall Xcode"
# alias spm="cd ~/Dev/swift/swift-package-manager"  # Update path as needed
alias op="open Package.swift"
alias aa="grep '^alias ' ~/.zshrc"

# Git Machete

alias gma="git-machete add"
alias gms="git-machete status"
alias gmr="git machete traverse --fetch --start-from=first-root"
alias gme='GIT_MACHETE_EDITOR=vim git machete edit'
alias gmd='git machete slide-out'

# Git
alias f="cd Dev/ios-fetch-rewards/"
alias c="cd Dev/card-service/"

# Github:

alias wb='gh pr comment -b /distribute-firebase'
alias ghr="gh pr edit --add-reviewer fetch-rewards/groupnotfound404 && gh pr ready"
alias prc='git log --reverse --pretty=format:"- %s" --author="$(git config user.name)" | grep -vE "\(#[0-9]+\)" | pbcopy && echo "✅ CopiAed commit list to clipboard!"'

alias web="gh pr view --web"
alias webr="gh repo view --web"

# Fetch Commands:

alias fo="fetch open"
alias fc="fetch checkout"
alias cob="fetch checkout"
alias fpr="fetch pr -d -p"

# Jira:

alias jd="move-ticket.sh -s in-progress"
alias jpr="move-ticket.sh -s waiting-for-pr"
alias jm="move-ticket.sh -s waiting-deploy"
alias jqa="move-ticket.sh -s waiting-qa"
alias jo="open.sh"

# Aliases End

mkdircd() {
  mkdir -p "$1" && cd "$1"
}

# Aliases for git
alias lg="lazygit"
alias air='~/.air'

# Aliases for docker
alias ld="lazydocker"

# Aliases for nvim
alias vim="nvim"


# Aliases for dotfiles
alias lgdot='GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME lazygit'

# Jira Stuff

# JIRA configuration
# JIRA_USER, JIRA_TOKEN and related secrets should be in ~/.zshrc_private


# Java configuration
export JAVA_HOME=$(/usr/libexec/java_home)




# (PATH has already been configured earlier; redundant exports removed)

# Development tool activations
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# Starship prompt (if not using Powerlevel10k)
if command -v starship &> /dev/null && [ ! -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]; then
  eval "$(starship init zsh)"
fi

# GPG configuration
export GPG_TTY=$(tty)

# Dotfiles alias
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Project-specific aliases (customize these)
alias hop='cd ~/Projects/ios-fetch-rewards/FetchHop'
alias rhop='cd ~/Projects/ios-fetch-rewards/'
alias tk='cd ~/Projects/take-home'

# iOS Development aliases
alias xc='open *.xcworkspace || open *.xcodeproj'
alias xcb='xcodebuild'
alias xcclean='rm -rf ~/Library/Developer/Xcode/DerivedData'
alias spm='swift package'
alias spmu='swift package update'
alias spmbuild='swift build'
alias spmtest='swift test'

# Simulator aliases
alias simlist='xcrun simctl list'
alias simboot='xcrun simctl boot'
alias simshut='xcrun simctl shutdown'
alias simreset='xcrun simctl erase'
alias simrecord='xcrun simctl io booted recordVideo'

# Fastlane aliases
alias fl='fastlane'
alias flscan='fastlane scan'
alias flgym='fastlane gym'
alias flmatch='fastlane match'

# Xcode build aliases
alias xcderived='cd ~/Library/Developer/Xcode/DerivedData'
alias xcarchives='cd ~/Library/Developer/Xcode/Archives'

# Swift aliases
alias swiftformat='mint run swiftformat'
alias swiftgen='mint run swiftgen'
alias sourcery='mint run sourcery'

# iOS debugging
alias iosdevices='xcrun xctrace list devices'
alias ioslog='xcrun simctl spawn booted log stream --level debug'

# Functions for iOS development
function sim() {
  if [ -z "$1" ]; then
    open -a Simulator
  else
    xcrun simctl boot "$1" && open -a Simulator
  fi
}

function xcode-version() {
  xcodebuild -version
}

function clean-build() {
  echo "Cleaning DerivedData..."
  rm -rf ~/Library/Developer/Xcode/DerivedData
  echo "Cleaning build folder..."
  xcodebuild clean
  echo "Clean complete!"
}

# Load Powerlevel10k instant prompt if available
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Powerlevel10k configuration if it exists
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
