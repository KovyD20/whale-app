resource "aws_ecr_repository" "kd-whale_app" {
  name = "kd-whale_app"
}

resource "aws_ecr_repository" "kd-whale_nginx" {
  name = "kd-whale_nginx"
}
