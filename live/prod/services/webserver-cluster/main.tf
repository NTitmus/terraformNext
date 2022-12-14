provider "aws" {
    region = "eu-west-2"
}

module "webserver_cluster" {
    #source = "../../../../modules/services/webserver-cluster"
    source = "git@github.com:NTitmus/terraformModules.git//services/webserver-cluster?ref=v0.0.1"

    cluster_name = "webservers-prod"
    db_remote_state_bucket = "s3-terraform-bucket-first"
    db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"

    instance_type = "t2.micro"
    min_size = 3
    max_size = 8
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
    scheduled_action_name = "scale-out-during-business-hours"
    min_size = 3
    max_size = 10
    desired_capacity = 4
    recurrence = "0 9 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
    scheduled_action_name = "scale-in-at-night"
    min_size = 2
    max_size = 10
    desired_capacity = 2
    recurrence = "0 17 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}