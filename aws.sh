#!/usr/bin/env bash

# Exit on command failure and unset variables
set -euo pipefail

# Import helper functions
source /usr/local/bin/helper.sh

function secrets_manager_parser() {
  initialize
  echo -e "\nPulling the secret with name ${AWS_SECRET_NAME} from AWS Secrets Manager."

  if [ -z "${AWS_SECRET_NAME}" ]; then
    echo -e "Error: AWS_SECRET_NAME environment variable is not set.\n Using the credentials that are being passed in."
  fi

  if [ -z "${CONF_FILE_PATH}" ]; then
    echo -e "Error: CONF_FILE_PATH environment variable is not set."
    exit 1
  fi

  export FLYWAY_URL=$(aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_NAME} | jq -r '.SecretString' | jq -r '.host')
  if [ ! -z "${FLYWAY_URL}" ]; then
    echo -e "\nAdding the flyway.url to the conf file."
  fi

  export FLYWAY_USER=$(aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_NAME} | jq -r '.SecretString' | jq -r '.username')
  if [ ! -z "${FLYWAY_USER}" ]; then
      echo "Adding the flyway.user to the conf file.\n"
  fi

  export FLYWAY_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_NAME} | jq -r '.SecretString' | jq -r '.password')
  if [ ! -z "${FLYWAY_PASSWORD}" ]; then
      echo -e "Adding the flyway.password to the conf file.\n"
  fi

  echo "flyway.url=$FLYWAY_URL" >> ${CONF_FILE_PATH}
  echo "flyway.user=$FLYWAY_USER" >> ${CONF_FILE_PATH}
  echo "flyway.password=$FLYWAY_PASSWORD" >> ${CONF_FILE_PATH}

}

if [[ "$1" == "secrets_manager_parser" ]]; then
    # Call the function
    secrets_manager_parser
fi

# Execute command(s)
#for CMD in "${!COMMAND@}"; do
#  eval "${!CMD}"
#done
