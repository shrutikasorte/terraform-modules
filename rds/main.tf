data "aws_secretsmanager_secret_version" "rds_cred"{
     secret_id = "secret"
}
locals {
     rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_cred.secret_string)
}

resource "aws_db_subnet_group" "rds_subnet_group"{
     name = "rds-subnet-group"
     subnet_ids = module.vpc.private_subnet_ids
}

resource "aws_db_instance" "rds"{
     identifier = "rds"
     allocated_storage = 20
     engine = "mysql"
     engine_version = "8.0"
     instance_class = "db.t3.micro"
     username = local.rds_credentials["username"]
     password = local.rds_credentials["password"]
     db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
     vpc_security_group_ids = [module.security_group_private.security_group_id]
     skip_final_snapshot = true
     publicly_accessible = false
     multi_az = false

}