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

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"wdd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
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
zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
# zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
# zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
# zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

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

# Git

alias cob="git co -b"

# Git Machete

alias gma="git-machete add"
alias gms="git-machete status"
alias gmr="git machete traverse --fetch --start-from=first-root"
alias gme='GIT_MACHETE_EDITOR=vim git machete edit'
alias gmd='git machete slide-out'

# Github:

alias wb='gh pr comment -b /distribute-firebase'
alias ghr="gh pr edit --add-reviewer fetch-rewards/groupnotfound404 && gh pr ready"
alias prc='git log --reverse --pretty=format:"- %s" --author="$(git config user.name)" | grep -vE "\(#[0-9]+\)" | pbcopy && echo "✅ CopiAed commit list to clipboard!"'

alias web="gh pr view --web"
alias webr="gh repo view --web"

# Fetch Commands:

alias fo="fetch open"
alias fc="fetch checkout"
# 'cob' already refers to 'git co -b' higher up; keep single definition
# alias cob="fetch checkout"
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
