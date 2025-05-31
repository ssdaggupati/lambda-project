output "github_oidc_actions_role_arn" {
  value = aws_iam_role.github_oidc_actions_role.arn
}

output "github_lambda_oidc_role_arn" {
  value = aws_iam_role.github_lambda_oidc_role.arn
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}
