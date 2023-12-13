variable "region" {
  default = "eu-central-1"

}
variable "vpc_cidr_block" {
  default = "20.0.0.0/16"
}

variable "public_subnet_1_cidr_block" {
  default = "20.0.1.0/24"
}

variable "public_subnet_2_cidr_block" {
  default = "20.0.2.0/24"
}

variable "public_subnet_3_cidr_block" {
  default = "20.0.3.0/24"
}

variable "private_subnet_1_cidr_block" {
  default = "20.0.5.0/24"
}

variable "private_subnet_2_cidr_block" {
  default = "20.0.6.0/24"
}

variable "private_subnet_3_cidr_block" {
  default = "20.0.7.0/24"
}

variable "ec2_name" {
  default = "Bastion-Host-Stage"
}

variable "ec2_type" {
  default = "t2.micro"
}

variable "ec2_ami" {
  default = "ami-04e601abe3e1a910f"
}

variable "key_name" {
  default = "Bastion"
}

variable "access_key" {
  default = "xxxx"
}

variable "secret_access_key" {
  default = "xxxx"
}

variable "desired_size" {
  default = "2"
}

variable "max_size" {
  default = "4"
}

variable "min_size" {
  default = "2"
}

variable "cluster_name" {
  default = "xxxx"
}

variable "cluster_instance_types" {
  default = "t3.large"
}

variable "bucket_name" {
  default = "xxxxx"
}