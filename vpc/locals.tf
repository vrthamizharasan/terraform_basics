locals {
  vpc_cidr = "10.0.0.0/16"
}

locals {
  security_group = {
    public = {
      name        = "public-sg"
      description = "sg-for the public access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.accessip]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        nginx = {
           from = 8000
           to = 8000
           protocol = "tcp"
           cidr_blocks = ["0.0.0.0/0"]
         }
      }
    }
    rds = {
      name        = "rds-sg"
      description = "sg-for the rds access"
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }

  }
}
