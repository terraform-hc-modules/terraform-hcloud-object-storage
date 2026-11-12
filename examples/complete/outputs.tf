output "bucket" {
  description = "Name of the bucket."
  value       = module.object_storage.bucket
}

output "endpoint" {
  description = "Virtual hosted style endpoint of the bucket."
  value       = "https://${module.object_storage.bucket}.${var.location}.your-objectstorage.com"
}

output "versioning_status" {
  description = "Versioning status of the bucket."
  value       = module.object_storage.versioning_status
}
