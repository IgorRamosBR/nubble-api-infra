resource "aws_iam_policy" "nubble_api_task_policy" {
  name        = "nubble-api-task-policy"
  description = "Policy that allows access to S3"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
               "s3:Get*",
               "s3:Put*"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}

resource "aws_ecs_task_definition" "nubble_api_task_definition" {
  family = "nubble-api-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "nubble-api-container-${var.environment}"
    image     = "igorramos/nubble-api:production"
    essential = true
    environment = [
      {
        name  = "HOST"
        value = "0.0.0.0"
      },
      {
        name  = "PORT"
        value = "3333"
      },
      {
        name  = "NODE_ENV"
        value = "production"
      },
      {
        name  = "APP_KEY"
        value = "z4psKzLyKSIBDS9q1LdXDrfonUZZEfUlcP2"
      },
      {
        name  = "APP_NAME"
        value = "Nubble"
      },
      {
        name  = "DRIVE_DISK"
        value = "s3"
      },
      {
        name  = "S3_BUCKET"
        value = "${aws_s3_bucket.nubble_bucket.id}"
      },
      {
        name  = "S3_REGION"
        value = "${var.region}"
      },
      {
        name  = "JWT_PUBLIC_KEY"
        value = "-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA665H8bgqK87AyJ0c0c0K\nEIPAUQQ5S+fl4+CG2N1xWOMWqZ77+DrQX8TdG/pXYtK+mLsFK8sSFvzOS11X3vVq\nwFRUApVZhSkt6VlgK4oMzF2VfR+NCLiya4i5j8ngFKueu1VFT4sNhu/4Xs11lPkA\npGOn9ff8MWd8Z60G4uE/16F2N4kQHpIkvH3JHYD7bavig733BRtA3HUbf2WdNqg8\nAh4SYbYC1iP3695KouJDJ+haMr4l2RTSOIPhPb5S9iwDr8i5s7HK5F2jLybFqEEJ\nwLb+V3jJtFrqSxoucz9pr8RTejQZD0F2dx1B02rtLzuuXqI3zBgl8WiSunBDENUA\nVQLMb3RGVvCoz7/7oWhlAZ6J7110NO1qnpbWSboUOAnAMcNV7I6rD4clJCd0l2xR\ntdk3OP54WBnBMr1TpvJfG9kqi6GzmJLcPbZmINzVlHPIgkCzZnx0Zsl3k4Uwuj7f\ni+ksy4ZqQhvK6UVsol58P9bscwSRRkbASzimAgxyikqnk4pJrgiqc38engaD+x2N\nr6rzyLAFVManDN1tSMbyoNYFToa8ICLHAUTr3Mot0Y0XTVdw+u2HGyw5YlyDNj3w\nH/wW0xbHIRTTphtd31eAsWac4+bscxoPPBJ1Ea9N+hM6Z+tU3SEnXRv1M9j2eVjQ\ngkeyaEKpweyp6pgzM+n1Gl0CAwEAAQ==\n-----END PUBLIC KEY-----\n"
      },
      {
        name  = "JWT_PRIVATE_KEY"
        value = "-----BEGIN PRIVATE KEY-----\n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\nhKxBf8j9orG+JuwrKrBB5zlg943Z\n-----END PRIVATE KEY-----\n"
      },
      {
        name  = "TOKES_EXPIRES_IN"
        value = "30m"
      },
      {
        name  = "REFRESH_TOKEN_EXPIRES_IN"
        value = "30d"
      },
      {
        name  = "PG_HOST"
        value = "${aws_db_instance.nubble_rds.address}"
      },
      {
        name  = "PG_PORT"
        value = "5432"
      },
      {
        name  = "PG_USER"
        value = "${var.rds_database_db_username}"
      },
      {
        name  = "PG_PASSWORD"
        value = "rds_database_db_password"
      },
      {
        name  = "PG_DB_NAME"
        value = "rds_database_name"
      },
    ]
    portMappings = [{
      protocol      = "tcp"
      containerPort = 3333
      hostPort      = 3333
    }]
  }])
}
