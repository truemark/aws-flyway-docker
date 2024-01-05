#!/usr/bin/env bash

# Exit on command failure and unset variables
set -euo pipefail

# Import helper functions
source /usr/local/bin/helper.sh

function aws_secrets_manager_parser() {
  if [ -z "${AWS_SECRET_NAME}" ]; then
    echo "Error: AWS_SECRET_NAME environment variable is not set."
    return 1
  fi

  export FLYWAY_URL=$(aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_NAME} | jq -r '.SecretString' | jq -r '.host')
  export FLYWAY_USER=$(aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_NAME} | jq -r '.SecretString' | jq -r '.username')
  export FLYWAY_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_NAME} | jq -r '.SecretString' | jq -r '.password')

  if [ -z "${FLYWAY_URL}" ] || [ -z "${FLYWAY_USER}" ] || [ -z "${FLYWAY_PASSWORD}" ]; then
    echo "Error: One or more FLYWAY variables did not get set."
    return 1
  fi
}

initialize
aws_secrets_manager_parser
# Execute command(s)
for CMD in "${!COMMAND@}"; do
  eval "${!CMD}"
done
