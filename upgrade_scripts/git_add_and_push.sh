#!/bin/bash
set -e

# Function to display usage
usage() {
    echo "Usage: $0 -c <json_file>"
    exit 1
}

# Parse command line arguments
while getopts "c:" opt; do
    case $opt in
        c) config_file="$OPTARG";;
        *) usage;;
    esac
done

# Check if config file was provided
if [ -z "$config_file" ]; then
    echo "Error: JSON config file must be specified with -c option"
    usage
fi

# Check if config file exists
if [ ! -f "$config_file" ]; then
    echo "Error: Config file $config_file does not exist"
    exit 1
fi

# Check if BRANCH_NAME environment variable is set
if [ -z "$BRANCH_NAME" ]; then
    echo "Error: BRANCH_NAME environment variable must be set"
    exit 1
fi

# Add modified files
jq -r '.files_modified[]' "$config_file" | xargs git add

# Set up branch tracking and sync with remote if it exists
if git ls-remote --heads origin "$BRANCH_NAME" | grep -q .; then
    git branch --set-upstream-to "origin/$BRANCH_NAME"
    git pull --ff-only
fi

git commit -m "$(jq -r '.commit_message' "$config_file")"
git push --set-upstream origin "$BRANCH_NAME"
