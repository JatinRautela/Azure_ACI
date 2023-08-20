variable "location" {
  description = "The location to create the resources in."
  type        = string
  default     = "northeurope"
}

variable "pname" {
  description = "Project name to be used in the locals."
  type        = string
  default     = "pname"
}

variable "env" {
  description = "Environment name to be used in the locals."
  type        = string
  default     = "env"
}