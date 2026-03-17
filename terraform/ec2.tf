locals {
  server_subnets = {
    a = aws_subnet.server_a.id
    b = aws_subnet.server_b.id
    c = aws_subnet.server_c.id
  }
}

resource "aws_instance" "server" {
  for_each = local.server_subnets

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = each.value
  vpc_security_group_ids = [aws_security_group.kd-ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("${path.module}/user_data.sh", {
    app_image    = var.app_image
    nginx_image  = var.nginx_image
    ecr_registry = split("/", var.app_image)[0]
    aws_region   = var.aws_region
  })

  tags = {
    Name = "kd-whale-server-${each.key}"
  }

  depends_on = [
    aws_nat_gateway.nat_gw,
    aws_route_table_association.private_server_a_association,
    aws_route_table_association.private_server_b_association,
    aws_route_table_association.private_server_c_association,
    aws_iam_role_policy_attachment.ecr_readonly
  ]
}
