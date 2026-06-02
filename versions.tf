terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
    buildkit = {
      source  = "cruxstack/buildkit"
      version = ">= 0.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}
