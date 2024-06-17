locals {
  github_organization_management = {
    infra_repository = {
      team_members = [
        {
          username    = "infra_user"
          email       = "infra_user@example.com"
          description = "Infrastructure team member"
        }
      ]
    }
    applications_repositories = {
      mms = {
        name = "mms"
        type = "backend"
        team_members = [
          {
            username    = "mms_user"
            email       = "mms_user@example.com"
            description = "MMS team member"
          }
        ]
      }
      "mms-backend" = {
        name = "mms-backend"
        type = "backend"
        team_members = [
          {
            username    = "mms_backend_user"
            email       = "mms_backend_user@example.com"
            description = "MMS backend team member"
          }
        ]
      }
    }
  }
}

# Template repository for backend applications
resource "github_repository" "template_backend" {
  name                   = "template-app-backend"
  description            = "Template repository for backend applications"
  visibility             = "private"
  auto_init              = true
  is_template            = true
  has_issues             = true
  has_projects           = false
  has_discussions        = true
  delete_branch_on_merge = true
  allow_squash_merge     = true
  allow_auto_merge       = false
}

# Template repository for frontend applications
resource "github_repository" "template_frontend" {
  name                   = "template-app-frontend"
  description            = "Template repository for frontend applications"
  visibility             = "private"
  auto_init              = true
  is_template            = true
  has_issues             = true
  has_projects           = false
  has_discussions        = true
  delete_branch_on_merge = false
  allow_squash_merge     = true
  allow_auto_merge       = false
}

# Set default branch for template repositories
resource "github_branch_default" "backend_default" {
  repository = github_repository.template_backend.name
  branch     = "main"
}

resource "github_branch_default" "frontend_default" {
  repository = github_repository.template_frontend.name
  branch     = "main"
}

# Create development branch for template repositories
resource "github_branch" "backend_development" {
  repository = github_repository.template_backend.name
  branch     = "development"
}

resource "github_branch" "frontend_development" {
  repository = github_repository.template_frontend.name
  branch     = "development"
}

# Create repositories based on the template
resource "github_repository" "repo" {
  for_each = local.github_organization_management.applications_repositories

  name                   = each.value.name
  description            = "${each.value.name} repository."
  visibility             = "private"
  auto_init              = true
  has_issues             = true
  has_projects           = false
  has_discussions        = true
  delete_branch_on_merge = false
  allow_squash_merge     = true
  allow_auto_merge       = false

  template {
    owner                = "AGL-ocean-bridge"
    repository           = each.value.type == "frontend" ? github_repository.template_frontend.name : github_repository.template_backend.name
    include_all_branches = false
  }

  lifecycle {
    prevent_destroy = false
  }
}
