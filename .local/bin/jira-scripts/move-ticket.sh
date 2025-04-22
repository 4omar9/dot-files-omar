#!/usr/bin/env zsh

# --- Requirement Checks ---

if ! git status > /dev/null 2>&1
then
    echo "❌ ERROR: Must be in the fetch git repository directory"
    exit 1
fi

if ! command -v jq > /dev/null
then
    echo "❌ ERROR: jq is not installed. Please install jq with 'brew install jq'"
    exit 1
fi

if [ -z "$JIRA_USER" ]
then
    echo "❌ ERROR: JIRA_USER is not set. Add export JIRA_USER=\"Your Jira email\" to your .zshrc"
    exit 1
fi

if [ -z "$JIRA_TOKEN" ]
then
    echo "❌ ERROR: JIRA_TOKEN is not set. Add export JIRA_TOKEN=\"Your Jira token\" to your .zshrc"
    exit 1
fi

# --- Handle Arguments ---

STATUS_NAME=""
HELP="false"

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -s|--status)
      STATUS_NAME="$2"
      shift 2
      ;;
    -h|--help)
      HELP="true"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

if [ "$HELP" = "true" ]; then
    echo "Usage: fetch status -s|--status <status name>"
    echo "Valid statuses: in-progress, waiting-for-pr, waiting-deploy"
    exit 0
fi

typeset -A STATUS_MAP
STATUS_MAP=(
  in-progress 231
  waiting-for-pr 11530
  waiting-deploy 11300
)

if [ -z "$STATUS_NAME" ]; then
    echo "❌ ERROR: You must specify a status with -s|--status"
    echo "Valid statuses:"
    for key in "${(@k)STATUS_MAP}"; do
    echo "  - $key"
    done
    exit 1
fi

# --- Status Mapping ---



STATUS_ID="${STATUS_MAP[$STATUS_NAME]}"

if [ -z "$STATUS_ID" ]; then
    echo "❌ ERROR: Unknown status name '$STATUS_NAME'"
    echo "Valid statuses: ${!STATUS_MAP[@]}"
    exit 1
fi

# --- Helper Functions ---

splitStringAtIndex()
{
    local STRING_TO_SPLIT=$1
    local DELIMITER=$2
    local INDEX=$(($3 + 1))
    local PRINT_STATEMENT="{print \$$INDEX}"
    SPLIT_STRING_AT_INDEX=$(echo "$STRING_TO_SPLIT" | awk -F "$DELIMITER" "$PRINT_STATEMENT")
}

# --- Script Execution ---

BRANCH="$(git branch --show-current)"

splitStringAtIndex "$BRANCH" "/" 1
JIRA_TICKET=$SPLIT_STRING_AT_INDEX

if [[ ! "$JIRA_TICKET" =~ ^[A-Z]+-[0-9]+$ ]]; then
    echo "❌ ERROR: Could not parse Jira ticket from branch name: $BRANCH"
    exit 1
fi

echo "🔄 Updating Jira ticket $JIRA_TICKET to status '$STATUS_NAME' (ID: $STATUS_ID)..."

RESPONSE=$(curl --silent --write-out "\n%{http_code}" \
  --request POST \
  --url "https://fetchrewards.atlassian.net/rest/api/3/issue/$JIRA_TICKET/transitions" \
  --user "$JIRA_USER:$JIRA_TOKEN" \
  --header "Content-Type: application/json" \
  --data "{
    \"transition\": {
      \"id\": \"$STATUS_ID\"
    }
  }")

# Separate body and status
HTTP_BODY=$(echo "$RESPONSE" | sed '$d')        # Removes the last line
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)       # Gets the last line

if [ "$HTTP_CODE" -eq 204 ]; then
  echo "✅ Successfully updated Jira status to '$STATUS_NAME'"
else
  echo "❌ Failed to update Jira status. HTTP code: $HTTP_CODE"
  echo "📨 Response:"
  echo "$HTTP_BODY"
fi