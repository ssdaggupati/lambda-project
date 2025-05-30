resource "aws_iam_role" "github_oidc_role" {
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
            "oidc.eks.us-east-1.amazonaws.com/id/46E5864AB37FD92F0339A9D7B7EDD59C:sub" = "system:serviceaccount:default:arc-runner-set-gha-rs-no-permission"
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
