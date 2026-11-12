mock_provider "minio" {}

run "defaults_create_private_bucket_only" {
  variables {
    bucket = "test-bucket"
  }

  assert {
    condition     = minio_s3_bucket.this[0].bucket == "test-bucket"
    error_message = "Bucket name should be passed through."
  }

  assert {
    condition     = minio_s3_bucket.this[0].acl == "private"
    error_message = "Default ACL should be private."
  }

  assert {
    condition     = length(minio_s3_bucket_versioning.this) == 0 && length(minio_ilm_policy.this) == 0 && length(minio_s3_bucket_retention.this) == 0 && length(minio_s3_bucket_policy.this) == 0
    error_message = "Optional resources should not be created by default."
  }

  assert {
    condition     = output.versioning_status == null
    error_message = "versioning_status should be null when versioning is not managed."
  }
}

run "bucket_prefix_is_accepted" {
  variables {
    bucket_prefix = "test-"
  }

  assert {
    condition     = minio_s3_bucket.this[0].bucket_prefix == "test-"
    error_message = "bucket_prefix should be passed through."
  }
}

run "complete_creates_all_resources" {
  variables {
    bucket                             = "test-bucket"
    acl                                = "public-read"
    object_locking                     = true
    versioning_enabled                 = true
    noncurrent_version_expiration_days = 30
    object_lock_retention = {
      mode            = "COMPLIANCE"
      unit            = "YEARS"
      validity_period = 1
    }
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["arn:aws:s3:::test-bucket/*"]
      }]
    })
  }

  assert {
    condition     = output.versioning_status == "Enabled"
    error_message = "Versioning should be enabled."
  }

  assert {
    condition     = minio_ilm_policy.this[0].rule[0].noncurrent_expiration[0].days == "30d"
    error_message = "Lifecycle rule should expire noncurrent versions after 30d."
  }

  assert {
    condition     = minio_s3_bucket_retention.this[0].mode == "COMPLIANCE" && minio_s3_bucket_retention.this[0].validity_period == 1
    error_message = "Retention should match the input."
  }

  assert {
    condition     = length(minio_s3_bucket_policy.this) == 1
    error_message = "Bucket policy should be created."
  }
}

run "create_false_creates_nothing" {
  variables {
    create             = false
    bucket             = "test-bucket"
    versioning_enabled = true
  }

  assert {
    condition     = length(minio_s3_bucket.this) == 0 && length(minio_s3_bucket_versioning.this) == 0
    error_message = "No resources should be created when create is false."
  }

  assert {
    condition     = output.bucket == null
    error_message = "bucket output should be null when create is false."
  }
}
