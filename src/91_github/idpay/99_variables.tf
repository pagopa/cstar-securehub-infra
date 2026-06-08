variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) <= 1
    )
    error_message = "Max length is 1 chars."
  }
}

variable "location_short" {
  type        = string
  description = "Location short like eg: neu, weu.."
}

variable "domain" {
  type        = string
  description = "Domain used for tags."
}

variable "datavault_service_url_for_uat" {
  type        = string
  description = "URL of the datavault service for UAT environment."
}