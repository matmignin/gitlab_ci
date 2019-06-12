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

output "instance_ips" {
  value = ["${aws_instance.test-instance.*.public_ip}"]
}


