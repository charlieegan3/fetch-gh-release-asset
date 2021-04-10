#!/bin/bash

set -exo pipefail

sudo apt-get install -y curl jq

if [[ -z "$INPUT_FILE" ]]; then
  echo "Missing file input in the action"
  exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
  echo "Missing GITHUB_REPOSITORY env variable"
  exit 1
fi

REPO=$GITHUB_REPOSITORY
if ! [[ -z ${INPUT_REPO} ]]; then
  REPO=$INPUT_REPO
fi

# Optional target file path
TARGET=$INPUT_FILE
if ! [[ -z ${INPUT_TARGET} ]]; then
  TARGET=$INPUT_TARGET
fi

# Optional personal access token for external repository
TOKEN=$GITHUB_TOKEN
if ! [[ -z ${INPUT_TOKEN} ]]; then
  TOKEN=$INPUT_TOKEN
fi

API_URL="https://$TOKEN:@api.github.com/repos/$REPO"
RELEASE_DATA=$(curl $API_URL/releases/${INPUT_VERSION})
MESSAGE=$(echo $RELEASE_DATA | jq -r ".message")

if [[ "$MESSAGE" == "Not Found" ]]; then
  echo "[!] Release asset not found"
  echo "Release data: $RELEASE_DATA"
  echo "-----"
  echo "repo: $REPO"
  echo "asset: $INPUT_FILE"
  echo "target: $TARGET"
  echo "version: $INPUT_VERSION"
  exit 1
fi

ASSET_ID=$(echo $RELEASE_DATA | jq -r ".assets | map(select(.name == \"${INPUT_FILE}\"))[0].id")
TAG_VERSION=$(echo $RELEASE_DATA | jq -r ".tag_name" | sed -e "s/^v//" | sed -e "s/^v.//")

if [[ -z "$ASSET_ID" ]]; then
  echo "Could not find asset id"
  exit 1
fi

# sudo to allow to write to path location if needed
sudo curl \
  -J \
  -L \
  -H "Accept: application/octet-stream" \
  "$API_URL/releases/assets/$ASSET_ID" \
  --create-dirs \
  -o ${TARGET}

if ! [[ -z "$INPUT_CHMOD_X" ]]; then
  sudo chmod +x ${TARGET}
  echo "$(dirname $TARGET)" >> $GITHUB_PATH
  echo "target made executable"
fi
