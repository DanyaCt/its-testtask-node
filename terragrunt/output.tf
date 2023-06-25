output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}

output "ecr_repository_name" {
  value = aws_ecr_repository.ecr.name
}

output "ecr_repository_registry_id" {
  value = aws_ecr_repository.ecr.registry_id
}

output "certificate_arn" {
  value = aws_acm_certificate.my_certificate.arn
}

output "efs_id" {
  value = aws_efs_file_system.efs.id
}