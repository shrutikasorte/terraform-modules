variable "ami_id"{
     type = string
}

variable "instance_type"{
     type = string
}
variable "subnet_id"{
     type = string
}

variable "key_name"{
     type = string
}
variable "security_groups_ids"{
     type = list(string)
}
variable "associate_public_ip"{
     type = bool
}