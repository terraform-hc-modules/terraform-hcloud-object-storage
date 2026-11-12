provider "minio" {
  minio_server   = "${var.location}.your-objectstorage.com"
  minio_user     = var.access_key
  minio_password = var.secret_key
  minio_region   = var.location
  minio_ssl      = true
}

locals {
  name = "ex-${basename(path.cwd)}"
}

################################################################################
# Object Storage bucket - Complete
################################################################################

module "object_storage" {
  source = "../../"

  bucket = local.name
  acl    = "private"

  object_locking = true
  object_lock_retention = {
    mode            = "GOVERNANCE"
    unit            = "DAYS"
    validity_period = 30
  }

  versioning_enabled                 = true
  noncurrent_version_expiration_days = 90

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadPublicPrefix"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["arn:aws:s3:::${local.name}/public/*"]
      }
    ]
  })
}
