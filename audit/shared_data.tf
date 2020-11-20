data "aws_vpc" "main-vpc" {
  tags = {
    Name = "main-vpc"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.main-vpc.id

  tags = {
    Tier = "private"
  }
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_lambda_function" "lambda_audit" {
  function_name = "LogsToElasticsearch_audit"
}