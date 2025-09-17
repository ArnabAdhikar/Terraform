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
  availability_zone      = "us-west-1a" // Change this to match your provider region

  tags = {
    Name    = "Dove-web"
    Project = "Dove"
  }
}

resource "aws_ec2_instance_state" "example-state" {
  instance_id = aws_instance.example.id
  state       = "running"
}