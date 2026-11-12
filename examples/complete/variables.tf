variable "location" {
  description = "Hetzner Object Storage location."
  type        = string
  default     = "fsn1"

  validation {
    condition     = contains(["fsn1", "nbg1", "hel1"], var.location)
    error_message = "location must be one of: fsn1, nbg1, hel1."
  }
}

variable "access_key" {
  description = "S3 access key, created in the Hetzner Console."
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "S3 secret key, created in the Hetzner Console."
  type        = string
  sensitive   = true
}
