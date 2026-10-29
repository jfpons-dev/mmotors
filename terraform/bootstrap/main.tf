resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "mmotors-prod-terraform-state"
  # Terraform cannot destroy the bucket if it is not empty
  force_destroy = false

  # Prevent accidental deletion of the bucket by Terraform destroy
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "mmotors-prod-terraform-state"
  }
}

# Version permits to preserve the history of the bucket and files versions
resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "terraform_state_bucket_public_access_block" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# SSE-S3 (AES-256) is intentionally preferred over SSE-KMS to reduce complexity and costs
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_bucket_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
