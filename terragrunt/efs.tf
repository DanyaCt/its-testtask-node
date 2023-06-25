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

# resource "aws_security_group_rule" "node" {
#   type                  = "ingress"
#   protocol              = "tcp"
#   from_port             = 2049
#   to_port               = 2049
#   source_security_group = aws_security_group.efs_sg.id
#   description           = "Allow access from EFS security group"
# }


# resource "kubernetes_csi_driver_v1" "efs" {
#   metadata {
#     name = "efs.csi.aws.com"
#   }
#   spec {
#     attach_required        = false
#     volume_lifecycle_modes = ["Persistent"]
#   }
# }

# resource "kubernetes_storage_class" "efs" {
#   metadata {
#     name = "efs-sc"
#   }
#   storage_provisioner = kubernetes_csi_driver_v1.efs.metadata[0].name
#   reclaim_policy      = "Delete"
# }

# resource "kubernetes_persistent_volume" "efs_data" {
#   metadata {
#     name = "fsdata"

#     labels = {
#       app = "task-pv"
#     }
#   }

#   spec {
#     access_modes = ["ReadWriteMany"]

#     capacity = {
#       storage = "1Gi"
#     }

#     volume_mode                      = "Filesystem"
#     persistent_volume_reclaim_policy = "Delete"
#     storage_class_name               = kubernetes_storage_class.efs.metadata[0].name

#     persistent_volume_source {
#       csi {
#         driver        = kubernetes_csi_driver_v1.efs.metadata[0].name
#         volume_handle = aws_efs_file_system.efs.id
#         read_only     = false
#       }
#     }
#   }
# }