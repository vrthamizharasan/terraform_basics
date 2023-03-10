data "aws_ami" "instance_ami" {
  most_recent = true
  owners    = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230115"]
  }

}


resource "aws_key_pair" "deploy_key" {
  key_name = var.key_name
  public_key = file(var.pubkey_path)
}

resource "aws_instance" "demo_instance" {
  ami = data.aws_ami.instance_ami.id
  instance_type = var.demo_instance_type
  count = var.instance_count #1
  tags = {
    Name = "demo-instance"
  }
  key_name = aws_key_pair.deploy_key.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id = var.public_subnet[count.index]
  user_data = templatefile(var.user_data_path,
     {
       nodename = "demo-instance"
       db_endpoint = var.db_endpoint
       dbusername = var.dbusername
       dbpassword = var.dbpassword
       db_name = var.db_name
     }
  )
  root_block_device {
    volume_size = var.vol_size #10
  }
}

resource "aws_lb_target_group_attachment" "alb_attach" {
  count = var.instance_count
  target_group_arn = var.target_group_arn
  target_id = aws_instance.demo_instance[count.index].id
  port = 8000
}
