variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "github_app_id" {
  description = "GitHub App ID."
  type        = string
}

variable "github_app_private_key" {
  description = "GitHub App private key in PEM format."
  type        = string
  sensitive   = true
}
