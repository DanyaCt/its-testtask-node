# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "its-test-task"
    dynamodb_table = "terraform-state-db"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "eu-central-1"
  }
}