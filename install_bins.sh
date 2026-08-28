#!/bin/sh

# installing all bin files 
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target_dir="$HOME/.local/bin"

mkdir -p "$target_dir"

for tool in "$repo_dir"/bin/*; do
  [ -f "$tool" ] || continue

  name=$(basename "$tool")
  ln -sfn "$tool" "$target_dir/$name"
  echo "Linked $name"
done

