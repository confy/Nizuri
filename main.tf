provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

terraform {
  backend "remote" {
    organization = "confy"
    workspaces {
      name = "Nizuri"
    }
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "nizuri-cluster"
}
resource "aws_vpc" "aws-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "nizuri-admin"

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
  name = "nizuri-admin-task"

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

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "task_s3" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_ecs_task_definition" "definition" {
  family                = "nizuri-task-definition"
  network_mode          = "awsvpc"
  memory                = "1024"
  container_definitions = <<DEFINITION
  [
    {
      "image": "${var.account}.dkr.ecr.eu-west-1.amazonaws.com/nizuri:latest",
      "name": "nizuri-container"
      }
    
  ]
  DEFINITION
}