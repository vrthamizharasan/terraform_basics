
resource "aws_instance" "jenkins_instance" {
    ami = "ami-0aa7d40eeae50c9a9"
    instance_type = var.instancetype
    availability_zone = var.azone
    key_name = "awslearning"
    associate_public_ip_address = "true"
    user_data = file("${path.cwd}/jenkins.sh")
    vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
}

resource "aws_security_group" "jenkins-sg" {
  name = "allows 8080"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Exposing the 8080 rules"
    from_port = 8080   
    protocol = "tcp"
    to_port = 8080
  } 
  ingress  {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Exposing the 22 rules"
    from_port = 22  
    protocol = "tcp"
    to_port = 22
  } 
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}
