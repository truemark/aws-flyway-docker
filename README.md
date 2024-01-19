# AWS CLI Flyway Docker Image

The project produces a multi-architecture docker image with minimal layers
containing the AWS CLI, Flyway and a few other useful tools.

# How do I use this docker image?

Authentication using an IAM user
```bash
docker run -it --rm \
  -e AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID" \
  -e AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY" \
  -e AWS_SECRET_NAME="YOUR_SECRET_NAME" \
  truemark/aws-flyway:latest
```

Alternative example using an IAM user
```bash
docker run -it --rm truemark/aws-flyway:latest
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
export AWS_SECRET_NAME="YOUR_SECRET_NAME" 
initialize
```

Example using an IAM user and switching roles
```bash
docker run -it --rm \
  -e AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID" \
  -e AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY" \
  -e AWS_ASSUME_ROLE_ARN="YOUR_ROLE_ARN" \
  -e AWS_ROLE_SESSION_NAME="YOUR_SESSION_NAME" \
  -e AWS_SECRET_NAME="YOUR_SECRET_NAME" \
  truemark/aws-flyway:latest
```

Example using OIDC authentication and switching roles
```bash
docker run -it --rm \
  -e AWS_OIDC_ROLE_ARN="YOUR_ACCESS_KEY_ID" \
  -e AWS_WEB_IDENTITY_TOKEN="YOUR_OIDC_TOKEN" \
  -e AWS_ASSUME_ROLE_ARN="YOUR_ROLE_ARN" \
  -e AWS_ROLE_SESSION_NAME="YOUR_SESSION_NAME" \
  -e AWS_SECRET_NAME="YOUR_SECRET_NAME" \
  truemark/aws-flyway:latest
```


# What are all the environment variables supported by this image?

| Environment Variable        | Description                                                                  |
|:----------------------------|:-----------------------------------------------------------------------------|
| AWS_SECRET_NAME             | Secrets Manager Secret Name to be pulled.                                    |
| AWS_ACCESS_KEY_ID           | Optional access key if using default AWS authentication.                     |
| AWS_ASSUME_ROLE_ARN         | Optional role to assume.                                                     |
| AWS_EXCLUDE_ACCOUNT_IDS     | Account IDs to exclude when using aws_organization_account_ids function.     |
| AWS_EXCLUDE_OU_IDS          | AWS Organizational units to exclude when using aws_organization_account_ids. |
| AWS_OIDC_ROLE_ARN           | Alternative variable to AWS_ROLE_ARN.                                        |
| AWS_ROLE_ARN                | Optional role to assume if using AWS OIDC authentication.                    |
| AWS_ROLE_SESSION_NAME       | Optional session name used in audit logs used when assuming a role.          |
| AWS_SECRET_ACCESS_KEY       | Optional secret access key if using default AWS authentication.              |
| AWS_SESSION_TOKEN           | Optional session token used with temporary credentials.                      |
| AWS_WEB_IDENTITY_TOKEN      | Optional OIDC token if using AWS OIDC authentication.                        |
| AWS_WEB_IDENTITY_TOKEN_FILE | Optional token file if using AWS OIDC authentication.                        |
| LOCAL_PATH                  | Optional value to change working directories.                                |

## License

The contents of this repository are released under the BSD 3-Clause license. See the
license [here](https://github.com/truemark/aws-flyway-docker/blob/main/LICENSE.txt).
