variable "instance_profile_name" {
  type    = string
  default = "example-instance-profile"
}

variable "iam_policy_name" {
  type    = string
  default = "example-policy"
}

variable "role_name" {
  type    = string
  default = "example-role"
}

variablee "vpc_id" {
  type = string
  default = "vpc-00507d09184a16a8d"

}

variable "subnet_ids" {
  type = list(string)
  default = ["subnet-044e085d0a093b23b" , "subnet-088da092dca0a3a40","subnet-01bd559b6e269130c","subnet-09dfbd49b87c17058"]
}
