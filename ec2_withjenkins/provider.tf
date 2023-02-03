terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.53.0"
    }
  }
}

# provdier block 
provider "aws" {
    region = "us-east-1"
    profile = "default"
}
