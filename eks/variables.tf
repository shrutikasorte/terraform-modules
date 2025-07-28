variable "cluster_name"{
     type = string
}
variable "private_subnet_ids"{
     type = list(string)
}
variable "node_desired_size" {
  type    = number
  
}

variable "node_min_size" {
  type    = number
  
}

variable "node_max_size" {
  type    = number
 
}

variable "node_instance_type" {
  type    = string
  
}

variable "ssh_key_name" {
  type = string
  description = "SSH key name to access worker nodes (must exist in EC2 > Key Pairs)"
}