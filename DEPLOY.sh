#!/usr/bin/env bash
set -euo pipefail

BRANCH="${DEPLOY_BRANCH:-master}"
REMOTE="${DEPLOY_REMOTE:-origin}"
PUSH="false"
DRY_RUN="false"

usage() {
  cat <<'USAGE'
Deploy the watthem profile repo by pushing the default branch.

Usage:
  ./DEPLOY.sh [options]

Options:
  --branch <name>           Branch to publish (default: master)
  --remote <name>           Remote to push (default: origin)
  --push                    Push the branch after validation
  --dry-run                 Print commands only
  -h, --help                Show help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --branch)
      BRANCH="$2"
      shift 2
      ;;
    --remote)
      REMOTE="$2"
      shift 2
      ;;
    --push)
      PUSH="true"
      shift
      ;;
    --dry-run)
      DRY_RUN="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

run_cmd() {
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '+ '
    printf '%q ' "$@"
    printf '\\n'
  else
    "$@"
  fi
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

CURRENT_BRANCH="$(git branch --show-current)"
if [[ "$CURRENT_BRANCH" != "$BRANCH" ]]; then
  echo "Error: checked out branch is '$CURRENT_BRANCH', expected '$BRANCH'" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Error: working tree is not clean. Commit or stash changes before deploy." >&2
  exit 1
fi

if [[ "$PUSH" == "true" ]]; then
  run_cmd git push "$REMOTE" "$BRANCH"
  echo "Deployment complete via GitHub push to '$REMOTE/$BRANCH'."
else
  echo "No wrangler deployment for this repo."
  echo "Use ./DEPLOY.sh --push to publish '$BRANCH' to '$REMOTE'."
fi
