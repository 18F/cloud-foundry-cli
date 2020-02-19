#!/bin/bash

set -o errexit
set -o pipefail
set -x

app=${1}
org=${2}
space=${3}
manifest=${4:-manifest.yml}
push_command="push"

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
# If the app already exists, switch to using the
# zero-downtime-push with the autopilot plugin; otherwise
# perform a normal push for a first time deployment.
if cf app $app; then
  push_command="zero-downtime-push"
fi

cf $push_command "$app" -f "$manifest"
