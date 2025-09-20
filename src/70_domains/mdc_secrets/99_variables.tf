variable "prefix" {
  type = string
  validation {
    condition     = length(var.prefix) <= 6
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "env_short" {
  type = string
  validation {
    condition     = length(var.env_short) <= 1
    error_message = "Max length is 1 chars."
  }
}

variable "domain" {
  type = string
  validation {
    condition     = length(var.domain) <= 12
    error_message = "Max length is 12 chars."
  }
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "location_short" {
  type        = string
  description = "Location short like eg: itn, weu.."
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "input_file" {
  type        = string
  description = "secret json file"
}

