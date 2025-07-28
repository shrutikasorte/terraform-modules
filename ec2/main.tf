resource "aws_instance" "ec2"{
     ami = var.ami_id
     key_name = var.key_name
     subnet_id = var.subnet_id
     instance_type = var.instance_type
     
     
}