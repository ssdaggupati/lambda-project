resource "aws_iam_role" "github_lambda_oidc_role" {
  name = "GitHubSelfHosted-Lambda-Role-v2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::819340487192:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/46E5864AB37FD92F0339A9D7B7EDD59C"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "oidc.eks.us-east-1.amazonaws.com/id/46E5864AB37FD92F0339A9D7B7EDD59C:sub" = "system:serviceaccount:arc-runners:github-runner"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_lambda_deploy_policy" {
  name = "GitHubLambdaDeployPolicy-v2"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:GetFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration"
        ],
        Resource = "arn:aws:lambda:us-east-1:819340487192:function:test_lambda"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_lambda_deploy_policy_attach" {
  policy_arn = aws_iam_policy.github_lambda_deploy_policy.arn
  role       = aws_iam_role.github_lambda_oidc_role.name
}
