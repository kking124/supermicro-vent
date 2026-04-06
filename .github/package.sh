#!/bin/sh
set -e

script_dir=$(cd "$(dirname "$0")" && pwd)
version=$(sh "$script_dir/bump-version.sh")
zipname="supermicro-vent-${version}.zip"
rm -f "$zipname"
zip -r "$zipname" LICENSE design print VERSION

echo "Created package: $zipname"

