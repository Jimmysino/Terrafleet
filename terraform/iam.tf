data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "buscar_equipos" {
  name = "${var.name_prefix}buscar-equipos-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role" "ver_disponibilidad" {
  name = "${var.name_prefix}ver-disponibilidad-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role" "publicar_equipo" {
  name = "${var.name_prefix}publicar-equipo-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role" "subir_foto" {
  name = "${var.name_prefix}subir-foto-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role" "crear_reserva" {
  name = "${var.name_prefix}crear-reserva-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

locals {
  lambda_roles = {
    "buscar-equipos"     = aws_iam_role.buscar_equipos.name
    "ver-disponibilidad" = aws_iam_role.ver_disponibilidad.name
    "publicar-equipo"    = aws_iam_role.publicar_equipo.name
    "subir-foto"         = aws_iam_role.subir_foto.name
    "crear-reserva"      = aws_iam_role.crear_reserva.name
  }
}

resource "aws_iam_role_policy" "lambda_logs" {
  for_each = local.lambda_roles

  name = "${var.name_prefix}${each.key}-logs"
  role = each.value

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:${data.aws_partition.current.partition}:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.name_prefix}${each.key}:log-stream:*"
      }
    ]
  })
}