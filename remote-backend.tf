terraform {
  backend "s3" {
    bucket         = "usecase-4-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-store"
    use_lockfile = true
    encrypt = true
  }
}