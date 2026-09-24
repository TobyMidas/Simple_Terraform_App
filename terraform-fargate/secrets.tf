resource "aws_secretsmanager_secret" "app_secret" {
  name = "cb-app-${terraform.workspace}-secret"
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  secret_id     = aws_secretsmanager_secret.app_secret.id
  secret_string = var.app_secret_value
}