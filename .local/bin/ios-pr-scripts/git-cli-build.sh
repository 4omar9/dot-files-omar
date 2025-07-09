#!/bin/zsh

# Define allowed values
allowed_values=("backcountry" "offroad" "hunt" "Fish")

# Function to check if value is allowed
is_allowed() {
  local value="$1"
  for val in "${allowed_values[@]}"; do
    if [[ "$val" == "$value" ]]; then
      return 0
    fi
  done
  return 1
}

# Check if argument is provided
if (( $# == 0 )); then
  echo "Please provide at least one argument."
  exit 1
fi

# Validate and set command
if [[ $1 == "-a" ]]; then
  command="gh pr comment -b \"@onx-mobile-ci beta hunt backcountry offroad fish\""
else
  if ! is_allowed "$1"; then
    echo "Invalid argument. Allowed values are: backcountry, offroad, hunt, fish"
    exit 1
  fi
  command="gh pr comment -b \"@onx-mobile-ci beta $*\""
fi

eval $command