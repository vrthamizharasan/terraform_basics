resource "aws_lb" "public_lb" {
    name = "public-lb"
    load_balancer_type = "application"
    internal = false
    subnets = var.publicsubnet
    security_groups = [var.public_sg]
    idle_timeout = 400  
}
