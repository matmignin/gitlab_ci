# AWS Provider
provider "aws" {}


resource "aws_instance" "test-instance" {
  count = 3
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  #key_name = "iac-test"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get install -y python",
    ]
    connection {
        type = "ssh"
        user = "ubuntu"
    }
  }
  tags {
    Name = "test-${count.index}"
  }
}


#           ____________________  Load Balancer stuff _____________

resource "aws_elb" "test-lb" {
  name    = "test-lb"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  instances       = ["${aws_instance.ants-instance.*.id}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
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
  value = ["${aws_instance.test-instance.*.public_ip}"]
}


