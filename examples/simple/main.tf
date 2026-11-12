provider "minio" {
  minio_server   = "${var.location}.your-objectstorage.com"
  minio_user     = var.access_key
  minio_password = var.secret_key
  minio_region   = var.location
  minio_ssl      = true
}

################################################################################
# Object Storage bucket
################################################################################

module "object_storage" {
  source = "../../"

  bucket_prefix = "ex-${basename(path.cwd)}-"
}
