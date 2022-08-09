provider "aws" {
    region = "eu-west-2"
}

resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-mysql-first"
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    name = "example_database_mysql"
    username = "admin"
    password = var.db_password
}

terraform {
  backend "s3" {
    bucket = "s3-terraform-bucket-first"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "eu-west-2"

    dynamodb_table = "s3-terraform-bucket-first-locks"
    encrypt = true
  }
}