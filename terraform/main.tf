
resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubSelfHosted-Lambda-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
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
    }]
  })
}

resource "aws_iam_policy" "lambda_custom_policy" {
  name        = "GitHubLambdaDeployPolicy"
  description = "Minimum permissions to deploy and manage Lambda functions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:GetFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",        
        ],
        Resource = "*"
      },      
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_custom_policy_attach" {
  policy_arn = aws_iam_policy.lambda_custom_policy.arn
  role       = aws_iam_role.github_oidc_role.name
}

resource "aws_iam_role_policy_attachment" "s3_readonly_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.github_oidc_role.name
}
