resource "aws_efs_file_system" "efs" {
  creation_token = "my-efs"

  tags = {
    Name = var.efs_name
  }
}

resource "aws_efs_mount_target" "efs-target" {
  count           = 2
  subnet_id       = module.vpc.public_subnets[count.index]
  file_system_id  = aws_efs_file_system.efs.id
  security_groups = [module.eks.cluster_security_group_id, aws_security_group.efs_sg.id]
}

resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "Allow NFS traffic for EFS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

