resource "aws_lambda_permission" "allow_cloudwatch_lambda_audit" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_audit_function_name
  principal     = "logs.${var.region}.amazonaws.com"
}