output "address" {
    value = aws_db_instance.prod-example.address
    description = "Connect to the prod database at this endpoint"
}

output "port" {
    value = aws_db_instance.prod-example.port
    description = "The port the database is listening on"
}