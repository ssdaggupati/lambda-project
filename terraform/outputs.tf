output "iam_role_arn" {
  description = "IAM Role ARN for GitHub self-hosted runner to deploy Lambda"
  value       = aws_iam_role.github_oidc_role.arn
}
