terraform{
     required_providers{
          aws = {
          source = "hashicorp/aws"
          version = "~>5.2"
}
     }
}

provider "aws"{
     region = var.region
}

resource "aws_vpc" "vpc"{
     cidr_block = "10.0.0.0/24"

     tags={
          Name = var.vpc_name
     }
}
resource "aws_subnet" "public_subnet"{
     vpc_id = aws_vpc.vpc.id
     count = length(var.vpc_subnet)
     cidr_block = var.vpc_subnet[count.index]
     availability_zone = var.az[count.index]

     tags={
          Name = "public-subnet-${count.index + 1}"
     }
}

resource "aws_subnet" "private_subnet"{
     vpc_id = aws_vpc.vpc.id
     count = length(var.vpc_private_subnet)
     cidr_block = var.vpc_private_subnet[count.index]
     availability_zone = var.az[count.index]

     tags= {
          Name = "private-subnet ${count.index + 1}"
     }
}

resource "aws_internet_gateway" "igt"{
     vpc_id = aws_vpc.vpc.id

     tags={
          Name = "internet-gt"
     }
}

resource "aws_eip" "ip"{
     domain = "vpc"
}
resource "aws_nat_gateway" "nt"{
     allocation_id = aws_eip.ip.id
     subnet_id = aws_subnet.public_subnet[0].id
     depends_on = [ aws_internet_gateway.igt]
}

resource "aws_route_table" "public-rt"{
     vpc_id = aws_vpc.vpc.id

     route {
          gateway_id = aws_internet_gateway.igt.id
          cidr_block = "0.0.0.0/0"
     }
}
resource "aws_route_table_association" "public-rta"{
     count = length(var.vpc_subnet)
     subnet_id = aws_subnet.public_subnet[count.index].id
     route_table_id = aws_route_table.public-rt.id
}


resource "aws_route_table" "private-rt"{
     vpc_id = aws_vpc.vpc.id
     count = length(var.vpc_private_subnet)

     dynamic "route"{
          for_each = count.index == 0 ? [1] :[]
          content{
               cidr_block = "0.0.0.0/0"
               nat_gateway_id = aws_nat_gateway.nt.id
          }
     }

     tags={
          Name = "private-rt - ${count.index +1 }"
     }
}

resource "aws_route_table_association" "private-rta"{
     count = length(var.vpc_private_subnet)
     route_table_id = aws_route_table.private-rt[count.index].id
     subnet_id = aws_subnet.private_subnet[count.index].id

}

