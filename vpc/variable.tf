variable "aws_region" {
  default = "us-east-1"
}

variable "accessip" {
    type = string
    default = "0.0.0.0/0"  
}

variable "dbusername" {
  type = string
}

variable "dbpassword" {
  type = string
  sensitive = true
}

variable "db_name" {
  type = string
  sensitive = true 
}
