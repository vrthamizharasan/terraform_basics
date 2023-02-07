terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
   }

  }
}

provider "aws" {
  region = var.aws_region
}



provider "random" {
  # Configuration options
}
