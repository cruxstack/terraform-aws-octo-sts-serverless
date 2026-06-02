# SSM Parameter Store Example

Deploy with a pre-existing GitHub App, reading credentials from SSM Parameter
Store.

Store the GitHub App credentials in SSM Parameter Store (as `SecureString`) and
reference them by ARN. The Lambda functions resolve the ARNs to their values at
runtime. This example assumes the SSM parameters already exist under
`/octo-sts/`.

## Prerequisites

Create the SSM parameters before applying, for example:

```sh
aws ssm put-parameter --type SecureString \
  --name /octo-sts/GITHUB_APP_ID --value 123456

aws ssm put-parameter --type SecureString \
  --name /octo-sts/GITHUB_APP_PRIVATE_KEY --value "$(cat path/to/private-key.pem)"
```

## Usage

```sh
terraform init
terraform apply
```

## Inputs

| Name         | Description                          | Type     | Default       | Required |
| ------------ | ------------------------------------ | -------- | ------------- | :------: |
| `aws_region` | AWS region to deploy resources into. | `string` | `"us-east-1"` |    no    |

## Outputs

| Name                   | Description                              |
| ---------------------- | ---------------------------------------- |
| `api_gateway_endpoint` | Base URL of the API Gateway.             |
| `webhook_url`          | Webhook URL for the GitHub App settings. |
| `sts_url`              | STS token exchange URL.                  |
| `healthz_url`          | Health check endpoint URL.               |
