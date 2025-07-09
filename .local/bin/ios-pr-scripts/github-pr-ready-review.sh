#!/bin/zsh

gh pr ready

BRANCH_NAME=$(git branch | grep \* | sed -e 's/* \(.*\)/\1/')
BRANCH_NUMBER=$(echo $BRANCH_NAME| sed -e 's/.*\/\([^_]*\).*/\1/' | tr '[:lower:]' '[:upper:]')

echo $BRANCH_NUMBER

jira issue move $BRANCH_NUMBER "In Review"
