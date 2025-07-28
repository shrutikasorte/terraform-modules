resource "aws_iam_role" "eks_cluster_role"{
     name = "${var.cluster_name}-eks-cluster-role"

     assume_role_policy = jsonencode({
          Version = "2012-10-17"
          Statement = [
               {
                    Action = "sts:AssumeRole",
                    Effect = "Allow",
                    Principal = {
                         Service = "eks.amazonaws.com"
                    }
               }
          ]
     })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy"{
     policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
     role = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "eks_cluster"{
     name = var.cluster.name
     role_arn = aws_iam_role.eks_cluster_role.arn
     
     vpc_config {
          subnet_ids = var.private_subnet_ids
          endpoint_private_access = true
          endpoint_public_access  = false
     }

     depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]
}


resource "aws_iam_role" "eks_node_role" {
     name = "${var.cluster_name}-node-role"

     assume_role_policy = jsondecode({
          Version = "2012-10-17"
          Statement = [{
               Effect = "Allow"
               Principal = {
                    Service = "ec2.amazonaws.com"
               }
          }]
     })
  
}
resource "aws_iam_role_policy_attachment" "eks_worker_node_policies" {
     for_each = toset([
     "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
     ])

     role = aws_iam_role.eks_node_role.name
     policy_arn = each.value
}

resource "aws_eks_node_group" "eks_nodes"{
     cluster_name = aws_eks_cluster.eks_cluster.name
     node_group_name = "${var.cluster_name}-node-group"
     node_role_arn = aws_iam_role.eks_node_role.arn
     subnet_ids = var.private_subnet_ids

     scaling_config {
       desired_size = var.node_desired_size
       min_size = var.node_min_size
       max_size = var.node_max_size
     }

     instance_types = [var.node_instance_type]
     remote_access {
       ec2_ssh_key = var.ssh_key_name
     }

     depends_on = [ aws_iam_policy_attachment.eks_worker_node_policies,
     aws_eks_cluster.eks_cluster
      ]
}