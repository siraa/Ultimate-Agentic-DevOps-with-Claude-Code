variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name, used for naming resources"
  type        = string
  default     = "portfolio-site"
}

variable "environment" {
  description = "Environment name (e.g., production, staging)"
  type        = string
  default     = "production"
}

variable "domain_name" {
  description = "Custom domain name (optional, for CNAME alias)"
  type        = string
  default     = ""
}
