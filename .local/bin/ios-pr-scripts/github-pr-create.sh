#!/bin/zsh

BRANCH_NAME=$(git branch | grep \* | sed -e 's/* \(.*\)/\1/')
BRANCH_NUMBER=$(echo $BRANCH_NAME| sed -e 's/.*\/\([^_]*\).*/\1/' | tr '[:lower:]' '[:upper:]')

echo "Enter the PR Title for branch ($BRANCH_NAME):"
read END




PR_NAME="$BRANCH_NUMBER: $END"

FILE_PATH="/Users/gage.halverson/rust/pull_request_template.md"

# Add Jira Link
URL="https://onxmaps.atlassian.net/browse/"
BRANCH_LINK="$URL$BRANCH_NUMBER"
SEARCH_LINE_JIRA="## Jira Ticket"
PR_BODY_JIRA=$(sed "/$SEARCH_LINE_JIRA/a\\
$BRANCH_LINK" $FILE_PATH)

# Add by Commit section
SEARCH_LINE_DESCRIPTION="## Description"
read -r -d '' NEW_DESCRIPTION_TEXT << EOM
\\
<details>\\
#<summary>Screen Recording</summary>\\ 
\\
\\
\\
#</details>\\
### Problem Statement:\\
\\
\\
#### This PR does the following by commit:\\
- Commit 1\\
- 
EOM
PR_BODY_DESCRIPTION=$(echo "$PR_BODY_JIRA")

# Add Test Plan Section

APP_VERSION="25.5.0"
SEARCH_LINE_TEST_PLAN="## Test Plan"
read -r -d '' NEW_TEST_PLAN_TEXT << EOM
\\
install TestFlight \(Test on one vertical because the code is shared\):\\
- \`Offroad ${APP_VERSION} \(\)\`\\
- \`Backcountry ${APP_VERSION} \(\)\`\\
- \`Hunt ${APP_VERSION} \(\)\`\\
--- 
EOM

PR_BODY_TEST_PLAN=$(echo "$PR_BODY_DESCRIPTION" | sed "/$SEARCH_LINE_TEST_PLAN/a\\
$NEW_TEST_PLAN_TEXT")

gh pr create -d -b $PR_BODY_TEST_PLAN --fill -t $PR_NAME
