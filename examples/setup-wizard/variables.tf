variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "github_org" {
  description = "GitHub organization to create the GitHub App under. Leave empty for a personal account."
  type        = string
  default     = ""
}
