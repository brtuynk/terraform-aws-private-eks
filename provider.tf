terraform {
  required_version = "~> 1.0"
  
  backend "s3" {
    bucket = "covenlabs-stage-tf"
    key    = "env/stage/tf-remote-backend.tfstate"
    region = "eu-central-1"
    access_key = "AKIAZ3E242FNZ2CBM54L"
    secret_key = "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"
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
