output "id" {
  description = "ID of the bucket."
  value       = try(minio_s3_bucket.this[0].id, null)
}

output "bucket" {
  description = "Name of the bucket."
  value       = try(minio_s3_bucket.this[0].bucket, null)
}

output "arn" {
  description = "ARN of the bucket."
  value       = try(minio_s3_bucket.this[0].arn, null)
}

output "bucket_domain_name" {
  description = "Domain name of the bucket as reported by the provider."
  value       = try(minio_s3_bucket.this[0].bucket_domain_name, null)
}

output "versioning_status" {
  description = "Versioning status of the bucket (Enabled), or null when versioning is not managed."
  value       = try(minio_s3_bucket_versioning.this[0].versioning_configuration[0].status, null)
}
