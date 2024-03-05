provider "aws" {
  region  = var.region          # Replace with your region
}

resource "aws_instance" "example" {
  ami  = "ami-0d940f23d527c3ab1"
  instance_type = "t2.micro"     # Free-tier eligible instance type
  tags = {
    Name = "example"
  }
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id] # Created SecGroup
  key_name      = aws_key_pair.tf_ec2_key.key_name

}

resource "null_resource" "copy_file_on_vm" {
  depends_on = [
    aws_instance.example
  ]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/tf_ec2_key.pem")
    host        = aws_instance.example.public_dns
  }
  provisioner "file" {
    source      = "${path.module}/init.sh"
    destination = "/tmp/init.sh"
  }
}

# EC2 instance Security Group
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Allow SSH inbound traffic"

  # Allow SSH inbound for allowed IP addressess
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP port 80 for HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP port 443 for HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound HTTP to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound HTTPS to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
