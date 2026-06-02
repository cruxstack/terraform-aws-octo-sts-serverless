output "api_gateway_endpoint" {
  description = "Base URL of the API Gateway."
  value       = module.octo_sts.api_gateway_endpoint
}

output "webhook_url" {
  description = "Webhook URL to configure in the GitHub App settings."
  value       = module.octo_sts.webhook_url
}

output "sts_url" {
  description = "STS token exchange URL."
  value       = module.octo_sts.sts_url
}

output "webhook_secret" {
  description = "Webhook secret to configure in the GitHub App (auto-generated if not provided)."
  value       = module.octo_sts.webhook_secret
  sensitive   = true
}

output "healthz_url" {
  description = "Health check endpoint URL."
  value       = module.octo_sts.healthz_url
}
