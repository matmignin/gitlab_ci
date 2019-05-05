# This will be testing out IaC using a stack of 
  - Terraform : Create and magane resources
  - Ansible provision EC2 instance
  - Terraform Ansile Provisioner: run ansible playbooks straight out of Terraform
  - GitLab CI: automate the execution of terraform with GitLab CI pipelines

## Project layout
  -terraform is flexible with layout, but ansible is not
  * File Structure
    * ansible-provioning
    * global
    * environments
    * modules
    * .gitlab-ci.yml
    * README.md
  - The SWS credentials will be set up as enfironment Variables
~
