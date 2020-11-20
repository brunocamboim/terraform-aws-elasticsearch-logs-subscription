data "aws_security_group" "sg-elasticsearch" {
  vpc_id      = data.aws_vpc.main-vpc.id

  tags = {
    Name  = "Elasticsearch"
  }
}

data "archive_file" "lambda_zip_subscription" {
  type        = "zip"
  output_path = "./tmp/lambda_zip_subscription.zip"
  source {
    content  = file("files/lambda-subscription.js")
    filename = "index.js"
  }
}

resource "aws_iam_role" "iam_for_lambda_audit" {
  name = "iam_for_lambda_audit"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_exec_role_vpc" {
  role = aws_iam_role.iam_for_lambda_audit.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "lambda_elasticsearch_execution" {
  name = "lambda_elasticsearch_execution"
  role = aws_iam_role.iam_for_lambda_audit.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "es:ESHttpPost"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:es:*:*:*"
      }
    ]
  }
  EOF
}

resource "aws_lambda_function" "LogsToElasticsearch_audit" {
  depends_on = [aws_iam_role_policy_attachment.lambda_exec_role_vpc]

  filename         = data.archive_file.lambda_zip_subscription.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_subscription.output_path)

  function_name = var.lambda_audit_function_name
  role          = aws_iam_role.iam_for_lambda_audit.arn
  handler       = "index.handler"

  runtime = "nodejs12.x"

  vpc_config {
    subnet_ids          = [for s in data.aws_subnet.private : s.id]
    security_group_ids  = [data.aws_security_group.sg-elasticsearch.id]
  }

  environment {
    variables = {
      AWS_ES_VPC_ENDPOINT = var.AWS_ES_VPC_ENDPOINT
    }
  }
}