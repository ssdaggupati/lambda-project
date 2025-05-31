output "github_oidc_role_arn" {
  description = "IAM Role ARN for GitHub OIDC Actions"
  value       = aws_iam_role.github_lambda_oidc_role.arn
}

output "lambda_execution_role_arn" {
  description = "IAM Role ARN for Lambda Function Execution"
  value       = aws_iam_role.lambda_execution_role.arn
}
