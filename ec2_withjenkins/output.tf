output "pubilcip" {
    value = join(":",[aws_instance.jenkins_instance.public_ip , 8080] )
    description = "Public ip address"
}
