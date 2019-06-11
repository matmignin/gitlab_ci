resource "aws_instance" "default" {
   ...
   user_data = "${data.terraform_remote_state.global.user_data}" 
   ...
   associate_public_ip_address = true
   key_name = "${data.terraform_remote_state.global.ssh_pubkey}"

   # ignore user_data updates, as this will require a new resource!
   lifecycle {
     ignore_changes = [
       "user_data",
     ]
   }
}
