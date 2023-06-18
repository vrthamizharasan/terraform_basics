terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.53.0"
    }
  }
  backend "s3" {
    bucket = "terraformstatevr"
    key = "dev/terraform.statefile"
    region = "us-east-1"
    dynamodb_table = "terraform-dev-statefiletable"

}

# provdier block 
provider "aws" {
    region = "us-east-1"
    profile = "default"
}
