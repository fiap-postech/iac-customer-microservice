resource "aws_secretsmanager_secret" "aes_algorithm" {
  name                    = local.secrets.aes_algorithm_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aes_algorithm_version" {
  secret_id     = aws_secretsmanager_secret.aes_algorithm.id
  secret_string = var.aes_algorithm

  depends_on = [aws_secretsmanager_secret.aes_algorithm]
}

resource "aws_secretsmanager_secret" "aes_password" {
  name                    = local.secrets.aes_password_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aes_password_version" {
  secret_id     = aws_secretsmanager_secret.aes_password.id
  secret_string = var.aes_password

  depends_on = [aws_secretsmanager_secret.aes_password]
}

resource "aws_secretsmanager_secret" "aes_iv" {
  name                    = local.secrets.aes_iv_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aes_iv_version" {
  secret_id     = aws_secretsmanager_secret.aes_iv.id
  secret_string = var.aes_iv

  depends_on = [aws_secretsmanager_secret.aes_iv]
}