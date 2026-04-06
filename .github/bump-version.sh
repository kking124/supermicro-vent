#!/bin/sh
set -e

script_dir=$(cd "$(dirname "$0")" && pwd)
version_file="$script_dir/../VERSION"
today=$(date +%Y.%m.%d)

if [ -f "$version_file" ]; then
  old_version=$(cat "$version_file" | tr -d '[:space:]')
else
  old_version="0.0.0.0"
fi

if echo "$old_version" | grep -E "^$today\.[0-9]+$" >/dev/null 2>&1; then
  bugfix=$(printf '%s' "$old_version" | awk -F. '{print $NF}')
  next=$((bugfix + 1))
else
  next=0
fi

new_version="$today.$next"
echo "$new_version" > "$version_file"
echo "$new_version"
