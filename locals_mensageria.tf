locals {
  sns = {
    min_delay_target               = 20
    max_delay_target               = 20
    num_retries                    = 3
    num_max_delay_retries          = 0
    num_no_delay_retries           = 0
    num_min_delay_retries          = 0
    disable_subscription_overrides = false
    max_receives_per_second        = 10
    kms_master_key_id              = "alias/aws/sns"
    customer_data_removal = {
      name = "prd-customer-remove-data-topic"
    }
  }

  subscription = {
    through_queue = {
      protocol             = "sqs"
      raw_message_delivery = true
    }
  }

  sqs = {
    delay_seconds              = 0
    max_message_size           = 262144
    message_retention_seconds  = 86400
    receive_wait_time_seconds  = 0
    visibility_timeout_seconds = 60
    sqs_managed_sse_enabled    = true
    removed_customer_data = {
      name = "prd-customer-remove-data-response-queue"
    }
    remove_customer_data = {
      name = "prd-customer-remove-customer-data-queue"
    }
  }
}