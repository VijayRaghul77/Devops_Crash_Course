variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-devops-cicd-demo"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
