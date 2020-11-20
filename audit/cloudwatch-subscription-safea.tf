resource "aws_cloudwatch_log_subscription_filter" "lambda_audit_log_filter" {
  depends_on      = [aws_lambda_permission.allow_cloudwatch_lambda_audit]
  name            = "lambda_audit_log_filter"
  log_group_name  = "/path/to/log/group"
  filter_pattern  = "AUDIT"
  destination_arn = data.aws_lambda_function.lambda_audit.arn
}