data "aws_ami" "instance_ami" {
  most_recent = true
  owners    = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230115"]
  }

}

resource "aws_launch_configuration" "test" {
  name_prefix = "mtc_asg"
  image_id = data.aws_ami.instance_ami.id 
  instance_type = var.instance_type #t2.micro
  //user_data = file(var.file_path)
  security_groups = [var.public_sg]
  lifecycle {
    create_before_destroy = true 
  }
}

resource "aws_autoscaling_group" "test_asg" {
  name = var.asg_name
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  health_check_grace_period = var.health_check_grace_period
  health_check_type = var.health_check_type
  force_delete = true
  launch_configuration = aws_launch_configuration.test.name
}

