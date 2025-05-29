provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "github_runner_role" {
  name = "GitHubSelfHosted-Lambda-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::819340487192:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/15B6386F423450DC0C76753344777FD7"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "oidc.eks.us-east-1.amazonaws.com/id/15B6386F423450DC0C76753344777FD7:sub" = "system:serviceaccount:arc-runners:github-runner"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_permissions" {
  name = "LambdaUpdatePolicy"
  role = aws_iam_role.github_runner_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:GetFunction",
          "sts:GetCallerIdentity"
        ],
        Resource = "*"
      }
    ]
  })
}
