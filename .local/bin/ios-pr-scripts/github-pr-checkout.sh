#!/bin/zsh

# Commands
exitCommand="pkill -x Xcode XCBBuildService"
switchCommand="gh pr checkout"

function execute_commands() {
    pr_number=$(gh mine --state open \
        --json number,title,headRefName,updatedAt \
        --template '{{range .}}{{tablerow (printf "#%v" .number | autocolor "green") .title .headRefName (timeago .updatedAt)}}{{end}}' | 
        fzf \
        --height 25% \
        --border \
        --ansi \
        --color=dark \
        --scheme=history \
        --bind=k:up,j:down \
        -e \
        --no-sort |
        egrep -o '[[:digit:]]+' | 
        head -n 1)
    
    if [[ -n "$pr_number" ]]; then
        sleep 1
        eval "$exitCommand" &&
        sleep 1
        eval "$switchCommand $pr_number" &&
    fi
}

execute_commands
