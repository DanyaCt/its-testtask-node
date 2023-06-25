module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.eks_name
  cluster_version = var.eks_version

  eks_managed_node_groups = [
    {
      key_name             = var.keyname
      vpc_id               = module.vpc.vpc_id
      subnet_ids           = module.vpc.private_subnets
      instance_type        = var.eks_instance_type
      name                 = "node_group"
      asg_desired_capacity = 1
      launch_template_name = var.eks_name
      iam_role_additional_policies  = ["arn:aws:iam::437190670490:policy/EFSCSIControllerIAMPolicy"]
    }
  ]

  node_security_group_additional_rules = {
  ingress_allow_access_from_control_plane = {
    type                          = "ingress"
    protocol                      = "tcp"
    from_port                     = 9443
    to_port                       = 9443
    source_cluster_security_group = true
    description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
  }

  ingress_allow_efs = {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 2049
      to_port     = 2049
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow access from EFS security group"
    }
    egress_allow_efs = {
      type        = "egress"
      protocol    = "tcp"
      from_port   = 2049
      to_port     = 2049
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow egress to EFS security group"
    }
}

  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id
  
}
