mock_provider "minio" {}

variables {
  bucket = "test-bucket"
}

run "invalid_acl_fails" {
  command = plan

  variables {
    acl = "public-read-write"
  }

  expect_failures = [var.acl]
}

run "bucket_and_bucket_prefix_fails" {
  command = plan

  variables {
    bucket_prefix = "test-"
  }

  expect_failures = [var.bucket]
}

run "neither_bucket_nor_bucket_prefix_fails" {
  command = plan

  variables {
    bucket = null
  }

  expect_failures = [var.bucket]
}

run "invalid_bucket_name_fails" {
  command = plan

  variables {
    bucket = "Invalid_Bucket"
  }

  expect_failures = [var.bucket]
}

run "lifecycle_without_versioning_fails" {
  command = plan

  variables {
    noncurrent_version_expiration_days = 30
  }

  expect_failures = [var.noncurrent_version_expiration_days]
}

run "retention_without_object_locking_fails" {
  command = plan

  variables {
    object_lock_retention = {
      mode            = "GOVERNANCE"
      unit            = "DAYS"
      validity_period = 7
    }
  }

  expect_failures = [var.object_lock_retention]
}

run "invalid_retention_mode_fails" {
  command = plan

  variables {
    object_locking = true
    object_lock_retention = {
      mode            = "LEGAL"
      unit            = "DAYS"
      validity_period = 7
    }
  }

  expect_failures = [var.object_lock_retention]
}

run "policy_with_not_action_fails" {
  command = plan

  variables {
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect    = "Deny"
        Principal = "*"
        NotAction = ["s3:GetObject"]
        Resource  = ["arn:aws:s3:::test-bucket/*"]
      }]
    })
  }

  expect_failures = [var.policy]
}

run "invalid_policy_json_fails" {
  command = plan

  variables {
    policy = "{not json"
  }

  expect_failures = [var.policy]
}
