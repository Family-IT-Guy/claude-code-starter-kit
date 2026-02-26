#!/bin/bash

# Claude Code Status Line
# Shows: Branch | Context% | Model
# Context% helps you know when to run /session-end before hitting limits.

input=$(cat)

# Extract basic info from JSON input
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')

# Extract context window info
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
current_usage=$(echo "$input" | jq '.context_window.current_usage')

if [ "$current_usage" != "null" ]; then
    input_tokens=$(echo "$current_usage" | jq '.input_tokens // 0')
    cache_create=$(echo "$current_usage" | jq '.cache_creation_input_tokens // 0')
    cache_read=$(echo "$current_usage" | jq '.cache_read_input_tokens // 0')
    total_tokens=$((input_tokens + cache_create + cache_read))
    context_percent=$((total_tokens * 100 / context_size))
else
    context_percent=0
fi

# Get git branch
cd "$current_dir" 2>/dev/null
git_branch=$(git branch --show-current 2>/dev/null)

# Build status line
components=()

if [ -n "$git_branch" ]; then
    components+=("$git_branch")
fi

components+=("${context_percent}%")
components+=("$model")

# Join with " | "
status_line=""
for i in "${!components[@]}"; do
    if [ $i -eq 0 ]; then
        status_line="${components[$i]}"
    else
        status_line="$status_line | ${components[$i]}"
    fi
done

printf "%s" "$status_line"
