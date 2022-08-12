provider "aws" {
  region = "eu-west-2"
}

resource "aws_db_instance" "prod-example" {
    identifier_prefix = "prod-terraform-mysql-first"
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    name = "prod_example_database"
    username = "admin"
    password = var.prod_db_password
}

terraform  {
    backend "s3" {
        bucket = "s3-terraform-bucket-first"
        key = "prod/data-stores/mysql/terraform.tfstate"
        region = "eu-west-2"

        dynamodb_table = "s3-terraform-bucket-first-locks"
        encrypt = true
    }
}