resource "aws_vpc" "Aitbubu_VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Aitbubu_VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.Aitbubu_VPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTPS from anywhere
  }
}


resource "aws_instance" "EC2-1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = var.Name

    depends_on = [ aws_instance.web ]

}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  provider      = aws.ayimdar  
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = var.Name

}
