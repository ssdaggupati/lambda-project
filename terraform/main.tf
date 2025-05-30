# IAM roles and policies for EKS and GitHub Actions Runner
resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubSelfHosted-Lambda-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::819340487192:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/50B91596F352A8C2877D012F1BC352FB"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "oidc.eks.us-east-1.amazonaws.com/id/50B91596F352A8C2877D012F1BC352FB:sub" = "system:serviceaccount:arc-runners:github-runner"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_readonly_access" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess"
  role       = aws_iam_role.github_oidc_role.name
}

resource "aws_iam_role_policy_attachment" "s3_readonly_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.github_oidc_role.name
}
