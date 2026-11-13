# Changelog

## [0.1.0](https://github.com/terraform-hc-modules/terraform-hcloud-object-storage/releases/tag/v0.1.0) (2026-11-13)

### Features

* first release: Hetzner Object Storage buckets through the S3 compatible API with the `aminueza/minio` provider
* bucket ACL (`private` or `public-read`, set at creation), versioning, object lock with default retention, noncurrent version expiration and bucket policies
* wrappers, examples and `terraform test` coverage
