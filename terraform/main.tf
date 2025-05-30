resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubSelfHosted-Lambda-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::819340487192:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/9B6AC733B65C2F4C67E19A0E959C1A42"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "oidc.eks.us-east-1.amazonaws.com/id/9B6AC733B65C2F4C67E19A0E959C1A42:sub" = "system:serviceaccount:arc-runners:github-runner"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_full_access" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}
