# Hetzner Object Storage is S3 compatible but only implements part of the S3 API.
# Only resources and arguments that Hetzner supports are used here.
# https://docs.hetzner.com/storage/object-storage/supported-actions

resource "minio_s3_bucket" "this" {
  count = var.create ? 1 : 0

  bucket         = var.bucket
  bucket_prefix  = var.bucket_prefix
  acl            = var.acl
  object_locking = var.object_locking
  force_destroy  = var.force_destroy
}

resource "minio_s3_bucket_versioning" "this" {
  count = var.create && var.versioning_enabled ? 1 : 0

  bucket = minio_s3_bucket.this[0].bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Hetzner lifecycle support is limited to NoncurrentVersionExpiration.
resource "minio_ilm_policy" "this" {
  count = var.create && var.noncurrent_version_expiration_days != null ? 1 : 0

  bucket = minio_s3_bucket.this[0].bucket

  rule {
    id = "noncurrent-version-expiration"

    noncurrent_expiration {
      days = "${var.noncurrent_version_expiration_days}d"
    }
  }

  depends_on = [minio_s3_bucket_versioning.this]
}

resource "minio_s3_bucket_retention" "this" {
  count = var.create && var.object_lock_retention != null ? 1 : 0

  bucket          = minio_s3_bucket.this[0].bucket
  mode            = var.object_lock_retention.mode
  unit            = var.object_lock_retention.unit
  validity_period = var.object_lock_retention.validity_period
}

resource "minio_s3_bucket_policy" "this" {
  count = var.create && var.policy != null ? 1 : 0

  bucket = minio_s3_bucket.this[0].bucket
  policy = var.policy
}
