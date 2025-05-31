# --- GitHub OIDC Provider (one-time setup per AWS account) ---
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# --- IAM Role for GitHub Actions (hosted runners) ---
resource "aws_iam_role" "github_oidc_actions_role" {
  name = "GitHubOIDC-Actions-Lambda-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:ssdaggupati/lambda-project:*"
          }
        }
      }
    ]
  })
}

# --- IAM Role for EKS Self-hosted Runner ---
resource "aws_iam_role" "github_lambda_oidc_role" {
  name = "GitHubSelfHosted-Lambda-Role"

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

# --- Shared Lambda Deployment Policy ---
resource "aws_iam_policy" "lambda_deploy_policy" {
  name = "GitHubLambdaDeployPolicy"

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

# --- Attach Lambda Policy to GitHub Hosted Actions Role ---
resource "aws_iam_role_policy_attachment" "attach_policy_to_actions_role" {
  policy_arn = aws_iam_policy.lambda_deploy_policy.arn
  role       = aws_iam_role.github_oidc_actions_role.name
}

# --- Attach Lambda Policy to Self-hosted EKS Runner Role ---
resource "aws_iam_role_policy_attachment" "attach_policy_to_eks_runner" {
  policy_arn = aws_iam_policy.lambda_deploy_policy.arn
  role       = aws_iam_role.github_lambda_oidc_role.name
}

# --- Lambda Execution Role ---
resource "aws_iam_role" "lambda_execution_role" {
  name = "LambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}
