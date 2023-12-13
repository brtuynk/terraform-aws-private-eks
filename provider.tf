terraform {
  required_version = "~> 1.0"
  
  backend "s3" {
    bucket = var.bucket_name
    key    = "env/stage/tf-remote-backend.tfstate"
    region = "eu-central-1"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}

provider "aws" {
  region = var.region
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
  ## profile = "my-profile"
}
