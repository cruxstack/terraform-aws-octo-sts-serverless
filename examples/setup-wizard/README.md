# Setup Wizard Example

Quick start using the built-in setup wizard (recommended for first-time setup).

This deploys the infrastructure first, then guides you through creating the
GitHub App via a web UI. The wizard writes the resulting credentials into SSM
Parameter Store, where the Lambda functions read them at runtime.

> **Note:** This example is essentially identical to the
> [`with-ssm`](../with-ssm) example — both read GitHub App credentials from SSM
> Parameter Store by ARN. The only difference is that this example enables the
> setup wizard (`installer_config.enabled = true`) to *create* those SSM
> parameters for you via a web UI. Once setup is complete, the running
> configuration is equivalent to `with-ssm`.

## Usage

```sh
terraform init
terraform apply
```

After `terraform apply`:

1. Open the `setup_url` output in your browser.
2. Follow the wizard to create your GitHub App.
3. Install the GitHub App on your organization(s).
4. Optionally disable the installer by setting
   `installer_config.enabled = false` and re-applying.

## Inputs

| Name         | Description                                                     | Type     | Default       |
| ------------ | --------------------------------------------------------------- | -------- | ------------- |
| `aws_region` | AWS region to deploy resources into.                            | `string` | `"us-east-1"` |
| `github_org` | GitHub organization to create the App under (empty = personal). | `string` | `""`          |

## Outputs

| Name                   | Description                                 |
| ---------------------- | ------------------------------------------- |
| `setup_url`            | URL to open in your browser for the wizard. |
| `api_gateway_endpoint` | Base URL of the API Gateway.                |
| `webhook_url`          | Webhook URL for the GitHub App settings.    |
| `sts_url`              | STS token exchange URL.                     |
| `healthz_url`          | Health check endpoint URL.                  |
