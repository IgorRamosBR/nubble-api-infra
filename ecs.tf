# ECS CLUSTER
resource "aws_ecs_cluster" "nubble_cluster" {
  name = "nubble-cluster-${var.environment}"
}

#ECS TASK RESOURCES (SG, Role)
resource "aws_security_group" "ecs_tasks_sg" {
  name   = "nubble-ecs-task-sg-${var.environment}"
  vpc_id = aws_vpc.nubble_vpc.id

  ingress {
    protocol         = "tcp"
    from_port        = "3333"
    to_port          = "3333"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

# resource "aws_ecs_service" "nubble_api_service" {
#   name                               = "nubble-api-service-${var.environment}"
#   cluster                            = aws_ecs_cluster.nubble_cluster.id
#   task_definition                    = aws_ecs_task_definition.main.arn
#   desired_count                      = 1
#   deployment_minimum_healthy_percent = 50
#   deployment_maximum_percent         = 200
#   launch_type                        = "FARGATE"
#   scheduling_strategy                = "REPLICA"

#   network_configuration {
#     security_groups  = var.ecs_service_security_groups
#     subnets          = var.subnets.*.id
#     assign_public_ip = false
#   }

#   load_balancer {
#     target_group_arn = var.aws_alb_target_group_arn
#     container_name   = "${var.name}-container-${var.environment}"
#     container_port   = var.container_port
#   }

#   lifecycle {
#     ignore_changes = [task_definition, desired_count]
#   }
# }

