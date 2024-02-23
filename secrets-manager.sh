#!/usr/bin/env bash

# Exit on command failure and unset variables
set -euo pipefail

# Import helper functions
source /usr/local/bin/helper.sh

function parser() {
  initialize
  echo -e "\nPulling the secret with name ${AWS_SECRET_NAME} from AWS Secrets Manager."
  export SECRET_INFO=$(aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_NAME})

  if [ -z "${AWS_SECRET_NAME}" ]; then
    echo -e "Error: AWS_SECRET_NAME environment variable is not set.\n Using the credentials that are being passed in."
  fi

  if [ -z "${CONF_FILE_PATH}" ]; then
    echo -e "Error: CONF_FILE_PATH environment variable is not set."
    exit 1
  fi

  export FLYWAY_URL=$(echo ${SECRET_INFO} | jq -r '.SecretString' | jq -r '.host')
  if [ ! -z "${FLYWAY_URL}" ]; then
    echo "Adding the flyway.url to the conf file."
  fi

  export FLYWAY_USER=$(echo ${SECRET_INFO} | jq -r '.SecretString' | jq -r '.username')
  if [ ! -z "${FLYWAY_USER}" ]; then
      echo "Adding the flyway.user to the conf file."
  fi

  export FLYWAY_PASSWORD=$(echo ${SECRET_INFO} | jq -r '.SecretString' | jq -r '.password')
  if [ ! -z "${FLYWAY_PASSWORD}" ]; then
      echo "Adding the flyway.password to the conf file."
  fi

  echo "flyway.url=jdbc:mysql://${FLYWAY_URL}:3306/tracking" >> ${CONF_FILE_PATH}
  echo "flyway.user=${FLYWAY_USER}" >> ${CONF_FILE_PATH}
  echo "flyway.password=${FLYWAY_PASSWORD}" >> ${CONF_FILE_PATH}

}

if [[ "$1" == "parser" ]]; then
    # Call the function
    parser
fi
