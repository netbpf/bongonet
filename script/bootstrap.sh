#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "== Bootstrap =="

for cmd in git cargo rustc; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Missing required command: $cmd" >&2
    echo "Install Git and Rust, then rerun this script." >&2
    exit 1
  }
done

MIN_FREE_GB="${MIN_FREE_GB:-5}"
AVAILABLE_KB="$(df -Pk "$ROOT" | awk 'NR==2 {print $4}')"
REQUIRED_KB=$((MIN_FREE_GB * 1024 * 1024))
if [[ "$AVAILABLE_KB" -lt "$REQUIRED_KB" ]]; then
  echo "Only $((AVAILABLE_KB / 1024 / 1024)) GiB free; recommended minimum is ${MIN_FREE_GB} GiB." >&2
  echo "Run script/disk-audit.sh and review safe cleanup options. Nothing was deleted." >&2
  exit 2
fi

echo "Running locked Cargo check..."
cargo check --workspace --all-targets --locked
echo "Bootstrap checks completed. No system cleanup was performed."