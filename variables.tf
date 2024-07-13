variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Local onde o grupo de recursos será criado"
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefixo que será anexado ao nome randômico de grupo de recursos"
}

variable "username" {
  type        = string
  description = "O usuário que será usado para nos conectarmos nas VMs"
  default     = "azureadmin"
}

variable "number_resources" {
  type        = number
  default     = 1
  description = "Número de VMs que serão criadas"
}

variable "admin_password" {
  description = "Password for the admin user on the virtual machine"
  default     = "${{ secrets.VM_ADMIN_PASSWORD }}"  # Acesso à variável secreta do GitHub
}
