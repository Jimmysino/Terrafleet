variable "aws_region" {
  description = "Región de AWS para los recursos de TerraFleet."
  type        = string
  default     = "us-east-2"
}

variable "name_prefix" {
  description = "Prefijo para identificar los recursos del laboratorio."
  type        = string
  default     = "lab09-"

  validation {
    condition     = startswith(var.name_prefix, "lab09-")
    error_message = "El prefijo debe comenzar con lab09-."
  }
}