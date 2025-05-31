output "iam_role_arn" {
  value = aws_iam_role.github_lambda_oidc_role.arn
}
