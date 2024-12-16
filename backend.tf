/* 
# S3 Backend to store state file

terraform {
  backend "s3" {
    bucket = "my-ansible-storage"
    key    = "env/ans/terraform.tfstate"
    region = "eu-west-2"
  }
}



 */