variable "location" {
  default = "Canada Central"
}

variable "resource_group_name" {
  default = "rg-devops-demo"
}

variable "vm_name" {
  default = "devops-vm-01"
}

variable "admin_username" {
  default = "azureuser"
}
variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}
variable "alert_email" {
  description = "Email for alerts"
  type        = string
}

variable "public_ip" {
  description = "Public IP of VM"
  type        = string
}
