resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubSelfHosted-Lambda-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::819340487192:oidc-provider/token.actions.githubusercontent.com"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:ssdaggupati/lambda-project:*"
        }
      }
    }]
  })

# Custom IAM Policy with minimum permissions required for Lambda deployment
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
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "iam:PassRole"
        ],
        Resource = "*"
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

# Attach the custom Lambda deployment policy to the role
resource "aws_iam_role_policy_attachment" "lambda_custom_policy_attach" {
  policy_arn = aws_iam_policy.lambda_custom_policy.arn
  role       = aws_iam_role.github_oidc_role.name
}

resource "aws_iam_role_policy_attachment" "s3_readonly_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.github_oidc_role.name
}
