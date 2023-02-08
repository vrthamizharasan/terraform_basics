resource "aws_lb" "public_lb" {
    name = "public-lb"
    load_balancer_type = "application"
    internal = false
    subnets = var.publicsubnet
    security_groups = [var.public_sg]
    idle_timeout = 400  
}

resource "aws_alb_target_group" "target_group" {
  name = "my-tg-${substr(uuid(),0 ,3)}"
  port = var.tg_port #80
  protocol = var.tg_protocol #"HTTP"
  vpc_id = var.vpc_id
  health_check {
    healthy_threshold = var.tg_heathythold #2
    unhealthy_threshold = var.tg_unhealthythold #2
    interval = var.tg_interval #2
    timeout = var.tg_timeout #30
  }
}
