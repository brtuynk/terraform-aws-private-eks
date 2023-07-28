data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "template_file" "Bastion" {
  template = file("${abspath(path.module)}/bastion.sh")
  vars = {
    region            = var.region
    access_key        = var.access_key
    secret_access_key = var.secret_access_key
  }
}

resource "aws_instance" "Bastion-Host" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  subnet_id              = aws_subnet.Public-Subnet-1.id
  vpc_security_group_ids = [aws_security_group.Bastion-Host-Sec-Gr.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2connectprofile.name
  user_data              = data.template_file.Bastion.rendered
  tags = {
    "Name" = var.ec2_name
  }
  depends_on = [aws_eks_cluster.EksCluster]
}


resource "aws_iam_instance_profile" "ec2connectprofile" {
  name = "${var.cluster_name}-ec2connectprofile"
  role = aws_iam_role.ec2connectcli.name
}

resource "aws_iam_role" "ec2connectcli" {
  name = "${var.cluster_name}-ec2connectcli"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Effect" : "Allow",
          "Action" : "ec2-instance-connect:SendSSHPublicKey",
          "Resource" : "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
          "Condition" : {
            "StringEquals" : {
              "ec2:osuser" : "ubuntu"
            }
          }
        },
        {
          "Effect" : "Allow",
          "Action" : "ec2:DescribeInstances",
          "Resource" : "*"
        }
      ]
    })
  }
}

resource "aws_security_group" "Bastion-Host-Sec-Gr" {
  name   = "${var.cluster_name}-Bastion-Host-Sec-Gr"
  vpc_id = aws_vpc.Eks-VPC.id
  tags = {
    "Name" = "${var.cluster_name}-Bastion-Host-Sec-Gr"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

