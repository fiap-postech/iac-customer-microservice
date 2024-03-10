locals {
  default_region = "us-east-1"
  project_name   = "customer-service"
  context_name   = "Customer"

  vpc_name = "tc-vpc"

  s3 = {
    bucket_name = "customer-data-removal"
  }

  secrets = {
    aes_algorithm_name = "service/${local.context_name}/AES/Algorithm"
    aes_password_name  = "service/${local.context_name}/AES/Password"
    aes_iv_name        = "service/${local.context_name}/AES/IV"
  }
}