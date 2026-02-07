variable "resource_group_name" {
  default = "NEW_PC"
}

variable "location" {
  default = "East US"
}

variable "docker_image" {
  description = "Docker Hub image: elleziasuleiman/protochicken-modern:v1"
  type        = string
}

variable "admin_username" {
  default = "azureuser"
}

variable "ssh_public_key_path" {
  description = "The absolute local path to the SSH public key"
  type        = string
  default     = "C:/Users/Nurellezia/.ssh/id_rsa.pub"
}