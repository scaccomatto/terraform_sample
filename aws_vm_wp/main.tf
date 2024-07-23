provider "aws" {
  region = var.region # Replace with your region
}


resource "aws_instance" "example" {
  ami           = "ami-0d940f23d527c3ab1"
  instance_type = "t2.micro" # Free-tier eligible instance type
  tags = {
    Name = "example"
  }
  vpc_security_group_ids = [aws_security_group.example_security_group.id] # Created SecGroup
  key_name               = aws_key_pair.tf_ec2_key.key_name
  provisioner "file" {
    source      = "${path.module}/files/init.sh"
    destination = "/home/ubuntu/init.sh"
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key =  local_file.tf_ec2_key.filename
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 755 /home/ubuntu/init.sh",
      "/home/ubuntu/init.sh"
    ]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = local_file.tf_ec2_key.filename
    }
  }
  depends_on = [local_file.tf_ec2_key]
}

