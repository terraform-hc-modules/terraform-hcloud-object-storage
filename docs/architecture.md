# Architecture

This module manages one Hetzner **Object Storage** bucket and its optional settings (versioning, lifecycle rule, object lock retention, bucket policy).

Hetzner Object Storage is S3 compatible and is managed through the `aminueza/minio` provider. The provider is configured by the caller, the module only declares resources.

## Data flow

```mermaid
flowchart TB
  U[Caller / Root module] -->|provider config + inputs| R[terraform-hcloud-object-storage]
  R --> B[minio_s3_bucket]
  B --> V[minio_s3_bucket_versioning]
  B --> L[minio_ilm_policy]
  B --> RT[minio_s3_bucket_retention]
  B --> P[minio_s3_bucket_policy]
  B --> OUT[outputs (id/bucket/arn/...)]
  OUT --> U
```

## Notes

- `acl` and `object_locking` only take effect at bucket creation. Changing them later replaces or fails on the bucket.
- The lifecycle rule only uses noncurrent version expiration, the only lifecycle action Hetzner supports. It requires versioning.
- Bucket tags, quota and other MinIO server features are not exposed because Hetzner does not support them.
