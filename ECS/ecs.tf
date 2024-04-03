resource "aws_ecs_cluster" "terraform_cluster" {
  name = "Terraform-provisioned-cluster"
}

resource "aws_ecs_task_definition" "terraform_task_definition" {
  family                   = "server"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name : "Terraform-Container"
      image : "docker.io/alisterxavier153/pao-server:1"
      networkMode : "awsvpc"
      logConfiguration : {
        logDriver : "awslogs"
        options : {
          awslogs-group : "/ecs/testapp",
          awslogs-region : "us-east-1",
          awslogs-stream-prefix : "ecs"
        }
      },
      portMappings : [
        {
          "name" : "server-5001-tcp",
          "containerPort" : 5001,
          "hostPort" : 5001,
          "protocol" : "TCP",
          "appProtocol" : "http"
        }
      ]
      essential : true
    }
  ])
}

resource "aws_ecs_service" "terraform_service" {
  name            = "terra-service"
  count           = length(var.public_subnet_cidrs)
  cluster         = aws_ecs_cluster.terraform_cluster.id
  task_definition = aws_ecs_task_definition.terraform_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.sub-1.id, aws_subnet.sub-2.id]
    security_groups  = [aws_security_group.aws_ecs_service_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.terraform_lb_target_group.arn
    container_name   = "Terraform-Container"
    container_port   = 5001
  }
  depends_on = [aws_lb_listener.terraform_lb_listner, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_ecs_task_definition.terraform_task_definition]
}
