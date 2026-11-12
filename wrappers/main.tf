module "wrapper" {
  source   = "../"
  for_each = var.items

  create                             = try(each.value.create, true)
  bucket                             = try(each.value.bucket_prefix, null) == null ? try(each.value.bucket, each.key) : null
  bucket_prefix                      = try(each.value.bucket_prefix, null)
  acl                                = try(each.value.acl, "private")
  object_locking                     = try(each.value.object_locking, false)
  force_destroy                      = try(each.value.force_destroy, false)
  versioning_enabled                 = try(each.value.versioning_enabled, false)
  noncurrent_version_expiration_days = try(each.value.noncurrent_version_expiration_days, null)
  object_lock_retention              = try(each.value.object_lock_retention, null)
  policy                             = try(each.value.policy, null)
}

variable "items" {
  description = "Map of bucket configurations. The map key is used as the bucket name unless bucket or bucket_prefix is set."
  type        = any
  default     = {}
}

output "wrapper" {
  description = "Map of bucket outputs."
  value       = module.wrapper
}
