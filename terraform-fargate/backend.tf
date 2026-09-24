terraform {
  backend "s3" {
    bucket         = "cb-app-terraform-state-tobymidas"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cb-app-terraform-lock"
    encrypt        = true
  }
}