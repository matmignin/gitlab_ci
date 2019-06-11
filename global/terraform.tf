# TerraForm Backend
terraform {
  backend "s3" {
    bucket = "[...]"
    key = "[...]"
    region = "[...]"
  }
}

# AWS Provider
provider "aws" {}

# Import State "global" From Remote S3 Bucket
data “terraform_remote_state” “global” {
  backend = “s3”
  config {
    region = "[...]"
    bucket = "[...]"
    key = "[...]"
  }
}

resource "null_resource" "default_provisioner" {
  triggers {
    default_instance_id = "${aws_instance.default.id}"
  }
  
  connection {
    host = "${aws_instance.default.public_ip}"
    type = "ssh"
    user = "terraform"   # as created in 'user_data'
    private_key = "${file("/root/.ssh/id_rsa_terraform")}"
  }
  # wait for the instance to become available
  provisioner "remote-exec" {
    inline = [
      "echo 'ready'"
    ]
  }
  # ansible provisioner
  provisioner "ansible" {
    plays {
      playbook = {
        file_path = "${path.module}/ansible/playbook/main.yml"
        roles_path = [
          "${path.module}/../../../../../ansible-provisioning/roles",
        ]
      }
    hosts = ["${aws_instance.default.public_ip}"]
    become = true
    become_method = "sudo"
    become_user = "root"
    
    extra_vars = {
      ...
      ansible_become_pass = "${file("/etc/ansible/become_pass")}"
    }
    
    vault_password_file = "/etc/ansible/vault_password_file"
  }  
}
