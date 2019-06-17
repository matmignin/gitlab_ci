# This will be testing out IaC using a stack of 
  - Terraform : Create and magane resources
  - Ansible provision EC2 instance
  - Terraform Ansile Provisioner: run ansible playbooks straight out of Terraform
  - GitLab CI: automate the execution of terraform with GitLab CI pipelines
  - docker

## Project layout                                    
### File Structure
├── ansible-provisioning *stores ansible roldes that are module independent*
│ └── roles
│   └── my-global-role
│     └── ...
│
├── global   *components that apply to all environments*(ssh_key_name, user_data.sh)
│   ├── files
│   │ └── user_data.sh  *installs python and creats a new user and deletes the old one and copies public ssh key to authorized_keys file*
│   └── {main|outputs|vars}.tf
│   └── terraform.tf  *define terraform backend and aws provider and import terraform_remote_states*

│
├── environments  *for files that define our environment spacific resources*(VPC,PGW,subnets)
│ ├── dev
│ │ └── {main|outputs|terraform|vars}.tf
│ ├── stage
│ │ └── {main|outputs|terraform|vars}.tf
│ └── prod
│   └── {main|outputs|terraform|vars}.tf
│
├── modules    *contains repeatitivly needed resources*
  └── my_module
    ├── ansible
    │ └── playbook
    │   └── roles
    │   | └── my-module-specific-role
    │   |   └── tasks
    │   |     └── main.yml
    │   └── group_vars
    │   | └── all
    │   |   └── vault   *stores encrypted Ansible variables*
    │   └── main.yml
    │
    └──{main|outputs|terraform|vars}.tf
│
├── .gitlab-ci.yml  *defines gitlab pipeline*
└── README.md

- terraform is flexible with layout, but ansible is not
  - The SWS credentials will be set up as enfironment Variables
~
