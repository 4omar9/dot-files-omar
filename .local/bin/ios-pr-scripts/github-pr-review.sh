#!/bin/zsh
search_query="is:open review-requested:@me"

if [[ $1 == "-a" ]]; then
  search_query="is:open is:pr user-review-requested:@me"
fi

gh pr list --search "$search_query" \
    --json number,title,additions,author,updatedAt \
    --template '{{range .}}{{tablerow (printf "#%v" .number | autocolor "green") .title .additions .author.login (timeago .updatedAt)}}{{end}}' | 
sort -t '|' -k3 -n |
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
head -n 1 |
xargs gh pr view --web
