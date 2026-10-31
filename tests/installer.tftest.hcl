mock_provider "aws" {
  mock_data "aws_caller_identity" { defaults = { account_id = "123456789012" } }
  mock_data "aws_region" { defaults = { region = "us-east-1", name = "us-east-1" } }
  mock_data "aws_partition" { defaults = { partition = "aws" } }
  mock_data "aws_iam_policy_document" { defaults = { json = "{}" } }
  mock_resource "aws_apigatewayv2_api" { defaults = { api_endpoint = "https://abc.execute-api.us-east-1.amazonaws.com", id = "abc", execution_arn = "arn:aws:execute-api:us-east-1:123456789012:abc" } }
  mock_resource "aws_iam_role" { defaults = { arn = "arn:aws:iam::123456789012:role/t" } }
  mock_resource "aws_cloudwatch_log_group" { defaults = { arn = "arn:aws:logs:us-east-1:123456789012:log-group:t" } }
}
mock_provider "buildkit" {
  mock_data "buildkit_context" { defaults = { digest = "sha256:0" } }
}
mock_provider "random" {}

variables {
  name = "t"
}

run "installer_enabled" {
  command = plan
  variables {
    installer_config = { enabled = true, ssm_parameter_prefix = "/octo/" }
  }
  assert {
    condition     = local.lambda_env_common.GITHUB_APP_ID == "arn:aws:ssm:us-east-1:123456789012:parameter/octo/GITHUB_APP_ID"
    error_message = "enabled: app id should come from the prefix"
  }
  assert {
    condition     = length(aws_apigatewayv2_route.setup) == 1 && length(aws_apigatewayv2_route.callback) == 1
    error_message = "enabled: setup routes should exist"
  }
  assert {
    condition     = length(random_password.webhook_secret) == 0
    error_message = "enabled: no generated webhook secret"
  }
}

run "installer_disabled_keeps_ssm_credentials" {
  command = plan
  variables {
    installer_config = { enabled = false, ssm_parameter_prefix = "/octo/" }
  }
  assert {
    condition     = local.lambda_env_common.GITHUB_APP_ID == "arn:aws:ssm:us-east-1:123456789012:parameter/octo/GITHUB_APP_ID"
    error_message = "disabled: app id should still come from the prefix"
  }
  assert {
    condition     = local.lambda_env_common.GITHUB_APP_PRIVATE_KEY == "arn:aws:ssm:us-east-1:123456789012:parameter/octo/GITHUB_APP_PRIVATE_KEY"
    error_message = "disabled: private key should still come from the prefix"
  }
  assert {
    condition     = local.lambda_env_webhook.GITHUB_WEBHOOK_SECRET == "arn:aws:ssm:us-east-1:123456789012:parameter/octo/GITHUB_WEBHOOK_SECRET"
    error_message = "disabled: webhook secret should still come from the prefix"
  }
  assert {
    condition     = local.lambda_env_webhook.GITHUB_APP_INSTALLER_ENABLED == "false" && local.lambda_env_webhook.STORAGE_MODE == ""
    error_message = "disabled: installer env should be off"
  }
  assert {
    condition     = length(aws_apigatewayv2_route.setup) == 0 && length(aws_apigatewayv2_route.setup_proxy) == 0 && length(aws_apigatewayv2_route.callback) == 0
    error_message = "disabled: setup routes should be removed"
  }
  assert {
    condition     = length(random_password.webhook_secret) == 0
    error_message = "disabled: no generated webhook secret"
  }
  assert {
    condition     = local.ssm_credentials
    error_message = "disabled: prefix credentials should be read"
  }
}

run "explicit_credentials" {
  command = plan
  variables {
    installer_config  = { enabled = false }
    github_app_config = { app_id = "42", private_key = "arn:aws:ssm:us-east-1:123456789012:parameter/key" }
  }
  assert {
    condition     = local.lambda_env_common.GITHUB_APP_ID == "42" && !local.ssm_credentials
    error_message = "explicit: app id should be the literal"
  }
  assert {
    condition     = length(random_password.webhook_secret) == 1
    error_message = "explicit: webhook secret should be generated"
  }
}
