variable "create" {
  description = "Whether to create the bucket and its related resources."
  type        = bool
  default     = true
}

variable "bucket" {
  description = "Name of the bucket. Conflicts with bucket_prefix; set exactly one of them."
  type        = string
  default     = null

  validation {
    condition     = (var.bucket == null) != (var.bucket_prefix == null)
    error_message = "Set exactly one of bucket or bucket_prefix."
  }

  validation {
    condition     = var.bucket == null || can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket))
    error_message = "bucket must be 3 to 63 characters of lowercase letters, numbers, dots and hyphens, and start and end with a letter or number."
  }
}

variable "bucket_prefix" {
  description = "Prefix for a generated, unique bucket name. Conflicts with bucket."
  type        = string
  default     = null

  validation {
    condition     = var.bucket_prefix == null || can(regex("^[a-z0-9][a-z0-9.-]{0,36}$", var.bucket_prefix))
    error_message = "bucket_prefix must be 1 to 37 characters of lowercase letters, numbers, dots and hyphens, and start with a letter or number."
  }
}

variable "acl" {
  description = "Canned ACL applied at bucket creation. Hetzner supports private and public-read."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "public-read"], var.acl)
    error_message = "acl must be one of: private, public-read."
  }
}

variable "object_locking" {
  description = "Enable object lock. Can only be set when the bucket is created."
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Delete all objects (including locked objects) when the bucket is destroyed. Objects are not recoverable."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable bucket versioning."
  type        = bool
  default     = false
}

variable "noncurrent_version_expiration_days" {
  description = "Days after which noncurrent object versions expire. null disables the lifecycle rule. Requires versioning_enabled."
  type        = number
  default     = null

  validation {
    condition     = var.noncurrent_version_expiration_days == null || var.versioning_enabled
    error_message = "noncurrent_version_expiration_days requires versioning_enabled = true."
  }

  validation {
    condition     = var.noncurrent_version_expiration_days == null || try(var.noncurrent_version_expiration_days >= 1 && floor(var.noncurrent_version_expiration_days) == var.noncurrent_version_expiration_days, false)
    error_message = "noncurrent_version_expiration_days must be a whole number of at least 1."
  }
}

variable "object_lock_retention" {
  description = "Default object lock retention for new objects. Requires object_locking."
  type = object({
    mode            = string
    unit            = string
    validity_period = number
  })
  default = null

  validation {
    condition     = var.object_lock_retention == null || var.object_locking
    error_message = "object_lock_retention requires object_locking = true."
  }

  validation {
    condition = var.object_lock_retention == null || try(
      contains(["GOVERNANCE", "COMPLIANCE"], var.object_lock_retention.mode) &&
      contains(["DAYS", "YEARS"], var.object_lock_retention.unit) &&
      var.object_lock_retention.validity_period >= 1 &&
      floor(var.object_lock_retention.validity_period) == var.object_lock_retention.validity_period,
      false
    )
    error_message = "object_lock_retention needs mode GOVERNANCE or COMPLIANCE, unit DAYS or YEARS, and a whole validity_period of at least 1."
  }
}

variable "policy" {
  description = "Bucket policy as a JSON string. null means no policy. Hetzner does not support the NotAction element."
  type        = string
  default     = null

  validation {
    condition     = var.policy == null || can(jsondecode(var.policy))
    error_message = "policy must be valid JSON."
  }

  validation {
    condition     = var.policy == null || !strcontains(coalesce(var.policy, "{}"), "NotAction")
    error_message = "policy must not use the NotAction element, Hetzner Object Storage does not support it."
  }
}
