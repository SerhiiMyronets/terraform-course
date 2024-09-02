resource "aws_ecs_task_definition" "main" {

  family             = "goals"
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = "512"
  memory             = "1024"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  #   volume {
  #     name = "data"
  #     efs_volume_configuration {
  #       file_system_id = aws_efs_file_system.mongo-efs.id
  #       root_directory = "/"
  #     }
  #   }
  container_definitions = jsonencode([

    {
      name      = "mongodb"
      image     = "mongo"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          name          = "mongod"
          containerPort = 27017
          hostPort      = 27017
          protocol      = "tcp"
          "appProtocol" : "http"
        },
      ]
      #       mountPoints = [
      #         {
      #           sourceVolume  = "data"
      #           containerPath = "/data/db"
      #           readOnly      = false
      #         }
      #       ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/example-task"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "MONGO_INITDB_ROOT_USERNAME"
          value = "max"
        },
        {
          name  = "MONGO_INITDB_ROOT_PASSWORD"
          value = "secret"
        }
      ]
      healthCheck : {
        command : [
          "CMD-SHELL",
          "mongosh --eval 'db.runCommand(\"ping\").ok' --quiet"
        ],
        interval : 10,
        timeout : 5,
        retries : 3
      },
    },
    {
      name      = "goals-backend"
      image = "serhiimyronets/multi_app"//"${var.node_backend_image}:latest"
      cpu       = 256
      memory    = 512
      essential = false
      portMappings = [
        {
          name : "node-goals-80-tcp",
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol : "http"
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/example-task"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "MONGODB_USERNAME"
          value = "max"
        },
        {
          name  = "MONGODB_PASSWORD"
          value = "secret"
        },
        {
          name  = "MONGODB_URL"
          value = "localhost"
        }
      ]
      dependsOn = [
        {
          containerName = "mongodb"
          condition     = "HEALTHY"
        }
      ]
      command : ["node", "app.js"]
    }
  ])
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution" {
  name       = "ecsTaskExecutionRole"
  roles = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy_attachment" "ecr_access" {
  name       = "ecsTaskECRAccess"
  roles = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy_attachment" {
  name       = "ecsTaskExecutionPolicyAttachment"
  roles = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_policy_attachment" "efs_access" {
  name       = "ecsTaskEFSMountAccess"
  roles = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/example-task"
  retention_in_days = 7
}


# resource "aws_efs_file_system" "mongo-efs" {
#   performance_mode = "generalPurpose"
#   tags = { Name = "goals-mongo-efs" }
# }
#
# resource "aws_efs_mount_target" "example" {
#   count = length(concat(aws_subnet.entity_public_subnets))
#   file_system_id = aws_efs_file_system.mongo-efs.id
#   subnet_id      = aws_subnet.entity_public_subnets[count.index].id
#   security_groups = [aws_security_group.efs_sg.id]
# }