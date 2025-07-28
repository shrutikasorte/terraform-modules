resource "aws_instance" "ec2"{
     ami = var.ami_id
     key_name = var.key_name
     subnet_id = var.subnet_id
     instance_type = var.instance_type
     associate_public_ip_address = var.associate_public_ip
     vpc_security_group_ids = var.security_groups_ids
     
}