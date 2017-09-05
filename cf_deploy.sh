#!/bin/bash

set -o errexit
set -o pipefail
set -x

app=${1}
org=${2}
space=${3}
manifest=${4:-manifest.yml}

if [[ -z $org || -z $space || -z $app ]]; then
  echo "Usage: $0  <app> <org> <space> [manifest.yml]" >&2
  exit 1
fi

if [[ ! -r "$manifest" ]]; then
  echo Manifest file \`"$manifest"\` does not exist. >&2
  exit 1
fi

if [[ -n "$CF_API" ]]; then
  cf api "$CF_API"
fi

(
  set +x # Disable debugging

  # Log in if necessary
  if [[ -n $CF_DEPLOY_USER && -n $CF_DEPLOY_PASSWORD ]]; then
    cf auth "$CF_DEPLOY_USER" "$CF_DEPLOY_PASSWORD"
  fi
)

# Target space
cf target -o "$org" -s "$space"

# Deploy web-app
cf zero-downtime-push "$app" -f "$manifest"
