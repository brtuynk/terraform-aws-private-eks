output "puclic_dns" {
  value = aws_instance.Bastion-Host.public_ip
}

output "endpoint" {
  value = aws_eks_cluster.EksCluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.EksCluster.certificate_authority[0].data
}
