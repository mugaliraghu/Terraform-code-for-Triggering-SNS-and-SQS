# Terraform-code-for-Triggering-SNS-and-SQS

## What it is?
This terraform file creates several resources, including an SNS topic, an SQS queue, and an EventBridge rule 
that filters for certain events and sends those events to the SNS topic and SQS queue. The resources are defined 
using the terraform resource.

## Where it is useful?
This Terraform file  is useful for creating a serverless application on AWS that uses EventBridge to filter and route events to 
an SNS topic and an SQS queue. 

SNS (Simple Notification Service) is a fully managed messaging service provided by AWS that enables the publishing and subscribing of messages 
from various services or systems. 
SQS (Simple Queue Service) is a fully managed message queuing service that enables decoupling and scaling of microservices, 
distributed systems, and serverless applications. 
EventBridge is a serverless event bus that can be used to integrate AWS services, SaaS applications, and custom applications.

Using this file, you can define an EventBridge rule that filters for certain events and sends those events to an SNS topic and an SQS queue. 
The SNS topic can be used to send notifications to subscribers via email, SMS, or other protocols, while the SQS queue can be used to store
 and process the messages asynchronously. This can be useful for building real-time monitoring and alerting systems, as well as decoupled and 
 scalable serverless architectures.

### This Terraform file creates an EventBridge rule that filters for EC2 instance state-change notifications and sends the filtered events to an SNS topic and an SQS queue. The SNS topic has a subscription for email notifications.
```t
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
```
first navigate to file where main.tf is present and perform below command. it performs backend initialization, and plugin installation.
```t
terraform init
```
then, use need to use the below command to validate the file
```t
terraform validate
```
and terraform plan will generate execution plan, showing you what actions will be taken without actuallay performing planned actions.
```t
terraform plan
```
after perform below command to deploy the application in aws and '--auto-approve' applying changes without having to interactively type 'yes' to the plan.
```t
terraform apply --auto-approve
```
