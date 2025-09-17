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

  // store the output in a txt file
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} >> public_ip.txt"
  }

  // store the output in a txt file
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.private_ip} >> private_ip.txt"
  }
}

output "WebPublicIP" {
  description = "value of AMI ID of ubuntu instance"
  // print public ip
  value       = aws_instance.example.public_ip
}

output "WebPrivateIP" {
  description = "value of private IP of ubuntu instance"
  value       = aws_instance.example.private_ip
}