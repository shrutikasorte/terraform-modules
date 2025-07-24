variable "region"{
     type = string
     default = ""
}

variable "vpc_name"{
     type = string
     default ="project-vpc"
}

variable "vpc_subnet"{
     type = list(string)
     default = [
          "10.0.0.0/27",
          "10.0.0.32/27",
          "10.0.0.64/27"
     ]
}
variable "az"{
     type = list(string)
     default = [
          "ap-south-1a",
          "ap-south-1b",
          "ap-south-1c"
     ]
}
variable "vpc_private_subnet"{
     type = list(string)
     default = [
          "10.0.0.96/27",
          "10.0.0.128/27",
          "10.0.0.160/27"
     ]
}