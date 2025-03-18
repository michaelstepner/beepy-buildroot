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

# Check if GH_TOKEN environment variable is set
if [ -z "$GH_TOKEN" ]; then
    echo "Error: GH_TOKEN environment variable must be set"
    exit 1
fi

# Read values from JSON file
pr_title=$(jq -r '.commit_message' "$config_file")
pr_body=$(jq -r '.pr_body' "$config_file")

# Get existing PR number if it exists
existing_pr_num=$(gh pr list --head "$BRANCH_NAME" | sed 's/^\([0-9]*\).*/\1/g' | head -n 1)

echo "" >> "$GITHUB_STEP_SUMMARY"
if [ -n "$existing_pr_num" ]; then
    # Update existing PR
    gh pr edit "$existing_pr_num" \
        --title "$pr_title" \
        --body "$pr_body"
    echo "➡️ Updated existing PR [#${existing_pr_num}](${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/pull/${existing_pr_num})" | tee -a "$GITHUB_STEP_SUMMARY"
else
    # Create new PR
    gh pr create --base "main" \
        --title "$pr_title" \
        --body "$pr_body"
    
    # Get the new PR number for the summary
    new_pr_num=$(gh pr list --head "$BRANCH_NAME" | sed 's/^\([0-9]*\).*/\1/g' | head -n 1)
    echo "➡️ Created new PR [#${new_pr_num}](${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/pull/${new_pr_num})" | tee -a "$GITHUB_STEP_SUMMARY"
fi
