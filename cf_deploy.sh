#!/bin/bash

set -o errexit
set -o pipefail
set -x

app=${1}
org=${2}
space=${3}
manifest=${4:-manifest.yml}
push_comand="push"

if [[ -z $org || -z $space || -z $app ]]; then
  echo "Usage: $0  <app> <org> <space> [manifest.yml]" >&2
  exit 1
fi

if [[ ! -r "$manifest" ]]; then
  echo Manifest file \`"$manifest"\` does not exist. >&2
  exit 1
fi

cf_login_and_target.sh $org $space

# Deploy web-app
# If the app already exists, switch to using the
# zero-downtime-push with the autopilot plugin; otherwise
# perform a normal push for a first time deployment.
if cf app $app; then
  push_command="zero-downtime-push"
fi

cf $push_command "$app" -f "$manifest"
