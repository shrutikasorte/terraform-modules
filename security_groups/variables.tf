variable "name"{
     type = string
}
variable "vpc_id"{
     type = string
}

variable "ingress_rules"{
     type = list(object({
          from_port = number
          to_port = number
          protocol = string
          cidr_blocks = list(string)
     }))
     default = []
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}