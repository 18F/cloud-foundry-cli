#!/bin/bash

set -o errexit
set -o pipefail
set -x

org=${1}
space=${2}

if [[ -z $org || -z $space ]]; then
  echo "Usage: $0 <org> <space>" >&2
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

