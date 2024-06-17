terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.10.0"  # Replace with the appropriate version
    }
  }
}

provider "github" {
  token = var.github_token
}
