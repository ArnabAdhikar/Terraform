data "aws_ami" "amiID" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "example" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t3.micro"
  key_name               = "dove-key"
  vpc_security_group_ids = [aws_security_group.dove-sg.id]
  availability_zone      = var.zone1 // Change this to match your provider region

  tags = {
    Name    = "Dove-web"
    Project = "Dove"
  }

  # push the file
  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  # ssh to the instance
  connection {
    type        = "ssh"
    user        = var.webusers
    private_key = file("/run/media/arnaba/Nigga/Terraform/Exercise4/dovekey")
    host        = self.public_ip
  }

  # execution
  provisioner "remote-exec"{
    inline = [ 
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
     ]
  }
}