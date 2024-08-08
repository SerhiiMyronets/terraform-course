# Create IAM role for Jenkins
resource "aws_iam_instance_profile" "jenkins_profile_devops_en" {
  name = "jenkins_profile_devops_en"
  role = aws_iam_role.jenkins_profile_devops_en.name
}

resource "aws_iam_role" "jenkins_profile_devops_en" {
  name = "jenkins_profile_devops_en"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "jenkins_profile_devops_en" {
  name = "jenkins_profile_devops_en"
  role = aws_iam_role.jenkins_profile_devops_en.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "s3:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "iam:PassRole",
          "iam:ListRoles"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
