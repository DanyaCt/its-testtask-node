resource "aws_iam_policy" "eks_cluster_additional_policy" {
  name        = "eks-cluster-additional-policy"
  description = "Additional policy for EKS cluster"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowEFSAccess",
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:ClientRootAccess",
        "elasticfilesystem:ClientMount"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_cluster_additional_policy_attachment" {
  role       = module.eks.cluster_iam_role_name
  policy_arn = aws_iam_policy.eks_cluster_additional_policy.arn
}

resource "aws_iam_role_policy_attachment" "additional_policy_attachment" {
  role       = module.eks.eks_managed_node_groups[0].iam_role_name
  policy_arn = "arn:aws:iam::437190670490:policy/EFSCSIControllerIAMPolicy"
}