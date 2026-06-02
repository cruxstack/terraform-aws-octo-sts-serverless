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
  ssm_prefix = "/octo-sts/prod/"
  ssm_arn    = "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_prefix}"
}

# -----------------------------------------------------------------------------
# Example: Quick start using the built-in setup wizard.
#
# This deploys the infrastructure first, then guides you through creating the
# GitHub App via a web UI. The wizard writes the resulting credentials into SSM
# Parameter Store, where the Lambda functions read them at runtime.
#
# After `terraform apply`:
#   1. Open the `setup_url` output in your browser.
#   2. Follow the wizard to create your GitHub App.
#   3. Install the GitHub App on your organization(s).
#   4. Optionally disable the installer by setting installer_config.enabled =
#      false and re-applying.
# -----------------------------------------------------------------------------

module "octo_sts" {
  source = "../../"

  name = "octo-sts"

  # The wizard creates these SSM parameters; reference them by ARN so the
  # Lambda functions resolve the values at runtime.
  github_app_config = {
    app_id         = "${local.ssm_arn}GITHUB_APP_ID"
    private_key    = "${local.ssm_arn}GITHUB_APP_PRIVATE_KEY"
    webhook_secret = "${local.ssm_arn}GITHUB_WEBHOOK_SECRET"
  }

  # Enable the setup wizard.
  installer_config = {
    enabled              = true
    ssm_parameter_prefix = local.ssm_prefix
    github_org           = var.github_org
  }

  # Grant the Lambda functions read/write access to the wizard's SSM prefix.
  ssm_parameter_arns = ["${local.ssm_arn}*"]
}
