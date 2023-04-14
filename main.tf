provider "aws" {
  region = "us-east-1"
}
//  For SNS
resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.sns_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.sns_topic.arn]
  }
}

resource "aws_sns_topic" "sns_topic" {
  name = "EC2StateChangeNotification"
}
resource "aws_sns_topic_subscription" "sns_target" {
  topic_arn =  aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = "raghavendra.m@zapcg.com"
}

//  For sqs

resource "aws_sqs_queue" "MySQSqueue" {
  name = "mysqsqueue"
}

data "aws_iam_policy_document" "test" {
  statement {
    sid    = "First"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.MySQSqueue.arn]

  
  }
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.MySQSqueue.id
  policy    = data.aws_iam_policy_document.test.json
}
// creating event rule:

resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "My_event_rule"
   event_pattern = jsonencode({
    source = ["aws.ec2"]
    detail-type = ["EC2 Instance State-change Notification"]
  })
}
// event rule targets:
resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  target_id = "SNStopic"
  arn       = aws_sns_topic.sns_topic.arn

  input_transformer {
    input_paths = {
      "state" = "$.detail.state",
      "instance"   = "$.detail.instance-id",
    }
    input_template = "\"The state of Instance <instance> is <state>\""
  }
}

resource "aws_cloudwatch_event_target" "sqs_target" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  target_id = "SQSqueue"
  arn       = aws_sqs_queue.MySQSqueue.arn

  input_transformer {
    input_paths = {
      "state" = "$.detail.state",
      "instance"   = "$.detail.instance-id",
    }
    input_template = "\"The state of Instance <instance> is <state>\""
  }
}