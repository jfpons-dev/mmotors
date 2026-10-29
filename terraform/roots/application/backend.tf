terraform {
  backend "s3" {
    bucket       = "mmotors-prod-terraform-state"
    key          = "application/terraform.tfstate"
    region       = "eu-west-3"
    use_lockfile = true
  }
}