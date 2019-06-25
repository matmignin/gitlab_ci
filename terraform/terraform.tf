


# TerraForm Backend
terraform {
  backend "s3" {
    bucket = "iac-bucket2"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
}


# AWS Provider
provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "iac-instance" {
  count         = 2
  ami           = "ami-0f65671a86f061fcd"
  instance_type = "t2.micro"
  key_name = "iac-test"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq",
      "sudo apt-get install -y python",
      "sudo mkdir foldasz",
    ]
    connection {
      host = coalesce(self.public_ip, self.private_ip)
      type = "ssh"
      user = "ubuntu"
    }
  }
  tags = {
    Name = "iac-${count.index}"
  }
}


#   __________________  Load Balancer stuff _____________

resource "aws_elb" "iac-lb" {
  name               = "iac-lb"
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
  instances          = aws_instance.iac-instance.*.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 4
}

output "instance_ips" {
  value = [aws_instance.iac-instance.*.public_ip]
}

output "address" {
  value = aws_elb.iac-lb.dns_name
}


