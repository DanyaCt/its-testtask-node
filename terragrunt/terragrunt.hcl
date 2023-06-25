remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "its-test-task"

    key = "terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-db"
  }
}

terraform {
  source = "./"
}

inputs = {
  ecr_name = "its-task"

  efs_name = "efs-for-eks"

  region = "eu-central-1"
  keyname = "MyKey"
  eks_name = "its-eks"
  eks_version = "1.27"
  eks_instance_type = "t3.medium"

  domain_name = "mydjangoapp-its.pp.ua"

  vpc_cidr = "10.0.0.0/16"
  public_sidr = ["10.0.1.0/24", "10.0.2.0/24"]
  private_sidr = ["10.0.4.0/24", "10.0.5.0/24"]
  private_subnet_name = "its-private-subnet"
  public_subnet_name = "its-public-subnet"
}