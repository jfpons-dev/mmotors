terraform {
  backend "s3" {
    bucket       = "mmotors-prod-terraform-state"
    key          = "developer-workstation/terraform.tfstate"
    region       = "eu-west-3"
    use_lockfile = true
  }
}
