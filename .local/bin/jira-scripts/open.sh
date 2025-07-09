#!/bin/zsh

set -euo pipefail

splitStringAtIndex() {
    local STRING_TO_SPLIT=$1
    local DELIMITER=$2
    local INDEX=$(($3 + 1))
    local PRINT_STATEMENT="{print \$$INDEX}"
    SPLIT_STRING_AT_INDEX=$(echo "$STRING_TO_SPLIT" | awk -F "$DELIMITER" "$PRINT_STATEMENT")
}

# Get current Git branch
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Extract the Jira ticket (e.g., FRA-1234) using your helper
splitStringAtIndex "$BRANCH_NAME" "/" 1
JIRA_TICKET="$SPLIT_STRING_AT_INDEX"

if [[ -z "$JIRA_TICKET" ]]; then
    echo "❌ Could not determine Jira ticket from branch: $BRANCH_NAME"
    exit 1
fi

# Construct and open Jira URL
JIRA_URL="https://fetchrewards.atlassian.net/browse/$JIRA_TICKET"
echo "🌐 Opening $JIRA_URL"
open "$JIRA_URL"