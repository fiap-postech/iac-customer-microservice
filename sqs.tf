### REMOVE-CUSTOMER-DATA-QUEUE
resource "aws_sqs_queue" "remove_customer_data_queue" {
  name                       = local.sqs.remove_customer_data.name
  delay_seconds              = local.sqs.delay_seconds
  max_message_size           = local.sqs.max_message_size
  message_retention_seconds  = local.sqs.message_retention_seconds
  receive_wait_time_seconds  = local.sqs.receive_wait_time_seconds
  visibility_timeout_seconds = local.sqs.visibility_timeout_seconds
  sqs_managed_sse_enabled    = local.sqs.sqs_managed_sse_enabled

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.remove_customer_data_dlq.arn,
    maxReceiveCount     = 3
  })

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["${aws_sqs_queue.remove_customer_data_dlq.arn}"]
  })

  depends_on = [
    aws_sqs_queue.remove_customer_data_dlq
  ]
}

resource "aws_sqs_queue" "remove_customer_data_dlq" {
  name                       = "${local.sqs.remove_customer_data.name}-dlq"
  delay_seconds              = local.sqs.delay_seconds
  max_message_size           = local.sqs.max_message_size
  message_retention_seconds  = local.sqs.message_retention_seconds
  receive_wait_time_seconds  = local.sqs.receive_wait_time_seconds
  visibility_timeout_seconds = local.sqs.visibility_timeout_seconds
  sqs_managed_sse_enabled    = local.sqs.sqs_managed_sse_enabled
}

resource "aws_sns_topic_subscription" "get_customer_remove_events" {
  topic_arn            = aws_sns_topic.customer_data_removal_topic.arn
  protocol             = local.subscription.through_queue.protocol
  endpoint             = aws_sqs_queue.remove_customer_data_queue.arn
  raw_message_delivery = local.subscription.through_queue.raw_message_delivery

  depends_on = [
    aws_sqs_queue.remove_customer_data_queue,
    aws_sns_topic.customer_data_removal_topic
  ]
}

resource "aws_sqs_queue_policy" "customer_event_to_process_subscription" {
  queue_url = aws_sqs_queue.remove_customer_data_queue.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Action : [
          "sqs:SendMessage"
        ],
        Resource = [
          aws_sqs_queue.remove_customer_data_queue.arn
        ],
        Condition = {
          ArnEquals = {
            "aws:SourceArn" : aws_sns_topic.customer_data_removal_topic.arn
          }
        }
      }
    ]
  })
}

### CUSTOMER-REMOVED-DATA-RESPONSE
resource "aws_sqs_queue" "removed_customer_data_queue" {
  name                       = local.sqs.removed_customer_data.name
  delay_seconds              = local.sqs.delay_seconds
  max_message_size           = local.sqs.max_message_size
  message_retention_seconds  = local.sqs.message_retention_seconds
  receive_wait_time_seconds  = local.sqs.receive_wait_time_seconds
  visibility_timeout_seconds = local.sqs.visibility_timeout_seconds
  sqs_managed_sse_enabled    = local.sqs.sqs_managed_sse_enabled

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.removed_customer_data_dlq.arn,
    maxReceiveCount     = 3
  })

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["${aws_sqs_queue.removed_customer_data_dlq.arn}"]
  })

  depends_on = [
    aws_sqs_queue.removed_customer_data_dlq
  ]
}

resource "aws_sqs_queue" "removed_customer_data_dlq" {
  name                       = "${local.sqs.removed_customer_data.name}-dlq"
  delay_seconds              = local.sqs.delay_seconds
  max_message_size           = local.sqs.max_message_size
  message_retention_seconds  = local.sqs.message_retention_seconds
  receive_wait_time_seconds  = local.sqs.receive_wait_time_seconds
  visibility_timeout_seconds = local.sqs.visibility_timeout_seconds
  sqs_managed_sse_enabled    = local.sqs.sqs_managed_sse_enabled
}