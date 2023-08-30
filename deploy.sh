#!/bin/bash

# Check if NAMESPACE is provided
if [ -z "$NAMESPACE" ]; then
  echo "Error: NAMESPACE must be set."
  exit 1
fi

# Check if NAMESPACE is provided
if [ -z "$CODE_SERVER_PASSWORD" ]; then
  echo "Error: CODE_SERVER_PASSWORD must be set."
  exit 1
fi

# Check if SSH_KEY_PATH is provided and file exists
if [ -z "$SSH_KEY_PATH" ] || [ ! -f "$SSH_KEY_PATH" ]; then
  echo "Error: SSH_KEY_PATH must be set and point to a valid file."
  exit 1
fi

# Check if GPG_USER_ID is provided
if [ -z "$GPG_USER_ID" ]; then
  echo "Error: GPG_USER_ID must be set."
  exit 1
fi

# Base64 encode the SSH key
SSH_KEY_BASE64=$(base64 -w 0 $SSH_KEY_PATH)

# Export and base64 encode the GPG private key
GPG_KEY_BASE64=$(gpg --export-secret-key -a "$GPG_USER_ID" | base64 -w 0)

# Check if GPG key was successfully exported and encoded
if [ -z "$GPG_KEY_BASE64" ]; then
  echo "Error: Failed to export and encode GPG key for user ID $GPG_USER_ID."
  exit 1
fi

# Template file
TEMPLATE_FILE="deploy.yml"

# Deploy the template
oc process -f $TEMPLATE_FILE \
  -p NAMESPACE=$NAMESPACE \
  -p SSH_KEY_BASE64=$SSH_KEY_BASE64 \
  -p GPG_KEY_BASE64=$GPG_KEY_BASE64 \
  -p CODE_SERVER_PASSWORD=$CODE_SERVER_PASSWORD | oc apply -f -
