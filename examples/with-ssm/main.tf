terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  ssm_prefix = "/octo-sts/"
  ssm_arn    = "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_prefix}"
}

# -----------------------------------------------------------------------------
# Example: Deploy with a pre-existing GitHub App, reading credentials from SSM.
#
# Store the GitHub App credentials in SSM Parameter Store (as SecureString) and
# reference them by ARN. The Lambda functions resolve the ARNs to their values
# at runtime. This example assumes the SSM parameters already exist.
# -----------------------------------------------------------------------------

module "octo_sts" {
  source = "../../"

  name = "octo-sts"

  github_app_config = {
    app_id      = "${local.ssm_arn}GITHUB_APP_ID"
    private_key = "${local.ssm_arn}GITHUB_APP_PRIVATE_KEY"
    # webhook_secret is auto-generated if not provided.
  }

  # Grant the Lambda functions read access to the SSM parameters above.
  ssm_parameter_arns = ["${local.ssm_arn}*"]
}
