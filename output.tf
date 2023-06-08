output "puclic_dns" {
  value = aws_instance.Paycell-stage-Bastion-Host.public_ip
}

output "endpoint" {
  value = aws_eks_cluster.Paycell-stage.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.Paycell-stage.certificate_authority[0].data
}
