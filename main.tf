
locals {
  stage = terraform.workspace
  tags  = merge(var.project_tags, { STAGE = local.stage })
}


resource "aws_lambda_function" "this" {
  function_name    = "hermes-error-handler"
  filename         = var.lambda_source_code
  handler          = "handler.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda.arn
  timeout          = 60
  source_code_hash = filebase64sha256("lambda_source_code.zip")
  layers           = [aws_lambda_layer_version.this.arn]


  environment {
    variables = {
      rds_host    = ""
      db_username = ""
      db_password = ""
      db_name     = ""
    }
  }

  tags = local.tags
}


resource "aws_lambda_layer_version" "this" {
  filename   = "lambda_pymsql_layer.zip"
  layer_name = "pmysql2"

  compatible_runtimes = ["python3.8"]
}

resource "aws_lambda_event_source_mapping" "kinesis_lambda_event_mapping" {
  event_source_arn               = aws_kinesis_stream.this.arn
  function_name                  = aws_lambda_function.this.arn
  starting_position              = "LATEST"
  bisect_batch_on_function_error = true
  #   maximum_retry_attempts         = 1
  destination_config {
    on_failure {
      destination_arn = aws_sqs_queue.this.arn
    }
  }
}

resource "aws_kinesis_stream" "this" {
  name        = "${var.project_name}-hermes-kinesis"
  shard_count = 1
  tags        = local.tags
}


resource "aws_sqs_queue" "this" {
  name = "${var.project_name}-sqs"
  tags = local.tags
}


module "rds" {
  source      = "./modules/rds"
  username    = "postgres"
  db_name     = "hermes"
  db_password = var.db_password
}