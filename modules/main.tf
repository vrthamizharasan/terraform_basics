provider "aws" {
  region = "us-west-2"
}

module "jenkins_iam" {
  source = "./modules/iam"
  instance_profile_name_in = var.instance_profile_name
  iam_policy_name_in       = var.iam_policy_name
  role_name_in             = var.role_name
}
