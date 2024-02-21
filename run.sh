#!/usr/bin/env bash

set -xe
# Exit on command failure and unset variables
set -euo pipefail

# Import helper functions
source /usr/local/bin/helper.sh

function aws_secrets_manager_parser() {
  if [ -z "${AWS_SECRET_NAME}" ]; then
    echo -e "Error: AWS_SECRET_NAME environment variable is not set.\n Using the credentials that are being passed in."
  fi

  export FLYWAY_URL=$(aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_NAME} | jq -r '.SecretString' | jq -r '.host')
  if [ ! -z "${FLYWAY_URL}" ]; then
    echo -e "\nYour FLYWAY_URL has been set."
  fi

  export FLYWAY_USER=$(aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_NAME} | jq -r '.SecretString' | jq -r '.username')
  if [ ! -z "${FLYWAY_USER}" ]; then
      echo "Your FLYWAY_USER has been set."
  fi

  export FLYWAY_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_NAME} | jq -r '.SecretString' | jq -r '.password')
  if [ ! -z "${FLYWAY_PASSWORD}" ]; then
      echo -e "Your FLYWAY_PASSWORD has been set.\n"
  fi
}

initialize
aws_secrets_manager_parser
# Execute command(s)
for CMD in "${!COMMAND@}"; do
  eval "${!CMD}"
done
