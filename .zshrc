# If you come from Bash you might have to adjust your PATH. We'll configure PATH
# in a dedicated section below, so no need for a separate export here.

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
  $path
)

# Export the joined PATH string
PATH=$(IFS=:; echo "${path[*]}")

ZSH_THEME="robbyrussell"

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
alias spm="cd /Users/gage/Dev/swift/swift-package-manager"
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

export JIRA_USER="g.halverson@fetchrewards.com"
# JIRA_API_TOKEN and related secrets live in ~/.zshrc_private


# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/gage/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;
export JAVA_HOME=$(/usr/libexec/java_home)




# (PATH has already been configured earlier; redundant exports removed)

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/gage/.lmstudio/bin"
eval "$(mise activate zsh)"
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'


# Fetch iOS
path=('/Users/g.halverson/Dev/ios-fetch-rewards/bin' $path)
# export PATH source /Users/g.halverson/.zshrc
