resource "aws_eks_cluster" "Paycell-stage" {
  name     = "Paycell-stage"
  role_arn = aws_iam_role.Paycell-stage.arn

  vpc_config {
    subnet_ids = [aws_subnet.Paycell-stage-Private-Subnet-1.id, aws_subnet.Paycell-stage-Private-Subnet-2.id, aws_subnet.Paycell-stage-Private-Subnet-3.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.Paycell-stage-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.Paycell-stage-AmazonEKSVPCResourceController,
  ]
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "Paycell-stage" {
  name               = "eks-cluster-Paycell-stage"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "Paycell-stage-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.Paycell-stage.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "Paycell-stage-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.Paycell-stage.name
}




resource "aws_eks_node_group" "Paycell-stage-EKS-Node-Group" {
  cluster_name    = aws_eks_cluster.Paycell-stage.name
  node_group_name = "Paycell-stage-EKS-Node-Group"
  node_role_arn   = aws_iam_role.Paycell-stage-EKS-Node-Group.arn
  subnet_ids      = [aws_subnet.Paycell-stage-Private-Subnet-1.id, aws_subnet.Paycell-stage-Private-Subnet-2.id, aws_subnet.Paycell-stage-Private-Subnet-3.id]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  instance_types = ["t3.large"]

  update_config {
    max_unavailable = 1
  }

  #   Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  #   Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.Paycell-stage-EKS-Node-Group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.Paycell-stage-EKS-Node-Group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.Paycell-stage-EKS-Node-Group-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "Paycell-stage-EKS-Node-Group" {
  name = "EKS-Paycell-stage-EKS-Node-Group"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "Paycell-stage-EKS-Node-Group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.Paycell-stage-EKS-Node-Group.name
}

resource "aws_iam_role_policy_attachment" "Paycell-stage-EKS-Node-Group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.Paycell-stage-EKS-Node-Group.name
}

resource "aws_iam_role_policy_attachment" "Paycell-stage-EKS-Node-Group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.Paycell-stage-EKS-Node-Group.name
}
