module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "main"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.private_sidr
  public_subnets  = var.public_sidr

  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/its-eks" = "shared"
  }

  private_subnet_tags = {
    Name = var.private_subnet_name
    "kubernetes.io/cluster/its-eks"          = "shared"
    "kubernetes.io/cluster/role/internal-elb" = 1
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/task-eks" = "shared"
    "kubernetes.io/cluster/role/elb" = 1
  }
}

resource "aws_ec2_tag" "public_subnet_tag1" {
  resource_id    = module.vpc.public_subnets[0]
  key            = "Name"
  value          = "its-public-subnet1"
}

resource "aws_ec2_tag" "public_subnet_tag2" {
  resource_id    = module.vpc.public_subnets[1]
  key            = "Name"
  value          = "its-public-subnet2"
}