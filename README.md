# Hetzner Object Storage Module

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.10-blueviolet)](https://www.terraform.io/)
[![License: MPL-2.0](https://img.shields.io/badge/License-MPL--2.0-blue.svg)](https://opensource.org/licenses/MPL-2.0)
[![CI](https://github.com/terraform-hc-modules/terraform-hcloud-object-storage/actions/workflows/ci.yml/badge.svg)](https://github.com/terraform-hc-modules/terraform-hcloud-object-storage/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/terraform-hc-modules/terraform-hcloud-object-storage)](https://github.com/terraform-hc-modules/terraform-hcloud-object-storage/releases)

Terraform module for Hetzner Object Storage buckets (S3 compatible) using the MinIO provider.

The `hetznercloud/hcloud` provider does not manage Object Storage, so this module uses
[`aminueza/minio`](https://registry.terraform.io/providers/aminueza/minio/latest), as in the
[official Hetzner guide](https://docs.hetzner.com/storage/object-storage/getting-started/creating-a-bucket-minio-terraform/).

The module does not configure the provider. Configure it in your root module. S3 credentials can only be
created in the Hetzner Console, so pass them in as variables.

## Usage

```hcl
provider "minio" {
  minio_server   = "fsn1.your-objectstorage.com"
  minio_user     = var.access_key
  minio_password = var.secret_key
  minio_region   = "fsn1"
  minio_ssl      = true
}

module "object_storage" {
  source  = "terraform-hc-modules/object-storage/hcloud"
  version = "~> 0.1"

  bucket = "my-bucket"
}
```

Available locations: `fsn1`, `nbg1`, `hel1`. The bucket endpoint is
`https://<bucket>.<location>.your-objectstorage.com`.

See [examples/simple](examples/simple) and [examples/complete](examples/complete).

## Hetzner Object Storage limitations

Supported by this module:

- Bucket creation with ACL `private` or `public-read` (set at creation only).
- Object lock, which must be enabled when the bucket is created, with a default retention.
- Versioning.
- Bucket policy (the `NotAction` element is not supported and is rejected by validation).
- Lifecycle rules, limited to `NoncurrentVersionExpiration` with `NoncurrentDays`.

Not supported by Hetzner, so not exposed here: tagging, replication, logging, website hosting,
notifications, encryption configuration other than SSE-C, and ownership controls.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_minio"></a> [minio](#requirement\_minio) | >= 3.46 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_minio"></a> [minio](#provider\_minio) | >= 3.46 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [minio_ilm_policy.this](https://registry.terraform.io/providers/aminueza/minio/latest/docs/resources/ilm_policy) | resource |
| [minio_s3_bucket.this](https://registry.terraform.io/providers/aminueza/minio/latest/docs/resources/s3_bucket) | resource |
| [minio_s3_bucket_policy.this](https://registry.terraform.io/providers/aminueza/minio/latest/docs/resources/s3_bucket_policy) | resource |
| [minio_s3_bucket_retention.this](https://registry.terraform.io/providers/aminueza/minio/latest/docs/resources/s3_bucket_retention) | resource |
| [minio_s3_bucket_versioning.this](https://registry.terraform.io/providers/aminueza/minio/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_acl"></a> [acl](#input\_acl) | Canned ACL applied at bucket creation. Hetzner supports private and public-read. | `string` | `"private"` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Name of the bucket. Conflicts with bucket\_prefix; set exactly one of them. | `string` | `null` | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Prefix for a generated, unique bucket name. Conflicts with bucket. | `string` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create the bucket and its related resources. | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Delete all objects (including locked objects) when the bucket is destroyed. Objects are not recoverable. | `bool` | `false` | no |
| <a name="input_noncurrent_version_expiration_days"></a> [noncurrent\_version\_expiration\_days](#input\_noncurrent\_version\_expiration\_days) | Days after which noncurrent object versions expire. null disables the lifecycle rule. Requires versioning\_enabled. | `number` | `null` | no |
| <a name="input_object_lock_retention"></a> [object\_lock\_retention](#input\_object\_lock\_retention) | Default object lock retention for new objects. Requires object\_locking. | <pre>object({<br/>    mode            = string<br/>    unit            = string<br/>    validity_period = number<br/>  })</pre> | `null` | no |
| <a name="input_object_locking"></a> [object\_locking](#input\_object\_locking) | Enable object lock. Can only be set when the bucket is created. | `bool` | `false` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | Bucket policy as a JSON string. null means no policy. Hetzner does not support the NotAction element. | `string` | `null` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable bucket versioning. | `bool` | `false` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the bucket. |
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Name of the bucket. |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | Domain name of the bucket as reported by the provider. |
| <a name="output_id"></a> [id](#output\_id) | ID of the bucket. |
| <a name="output_versioning_status"></a> [versioning\_status](#output\_versioning\_status) | Versioning status of the bucket (Enabled), or null when versioning is not managed. |
<!-- END_TF_DOCS -->

## License

Mozilla Public License 2.0
