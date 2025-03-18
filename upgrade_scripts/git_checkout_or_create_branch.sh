#!/bin/bash
set -e

# Check a branch name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <BRANCH_NAME>"
  exit 1
fi
BRANCH_NAME="$1"

# Checkout the branch if it exists, otherwise create it
if git ls-remote --heads origin "$BRANCH_NAME" | grep -q .; then
  git fetch --depth 1 origin "$BRANCH_NAME"
  git checkout "$BRANCH_NAME"
else
  git checkout -b "$BRANCH_NAME"
fi
