locals {
  lambda_names = [
    "buscar-equipos",
    "ver-disponibilidad",
    "publicar-equipo",
    "subir-foto",
    "crear-reserva",
  ]
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../lambda_src/index.js"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_cloudwatch_log_group" "lambda" {
  for_each          = toset(local.lambda_names)
  name              = "/aws/lambda/${var.name_prefix}${each.key}"
  retention_in_days = 7
}

resource "aws_lambda_function" "buscar_equipos" {
  function_name    = "${var.name_prefix}buscar-equipos"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  role             = aws_iam_role.buscar_equipos.arn

  depends_on = [aws_cloudwatch_log_group.lambda]
}

resource "aws_lambda_function" "ver_disponibilidad" {
  function_name    = "${var.name_prefix}ver-disponibilidad"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  role             = aws_iam_role.ver_disponibilidad.arn

  depends_on = [aws_cloudwatch_log_group.lambda]
}

resource "aws_lambda_function" "publicar_equipo" {
  function_name    = "${var.name_prefix}publicar-equipo"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  role             = aws_iam_role.publicar_equipo.arn

  depends_on = [aws_cloudwatch_log_group.lambda]
}

resource "aws_lambda_function" "subir_foto" {
  function_name    = "${var.name_prefix}subir-foto"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  role             = aws_iam_role.subir_foto.arn

  depends_on = [aws_cloudwatch_log_group.lambda]
}

resource "aws_lambda_function" "crear_reserva" {
  function_name    = "${var.name_prefix}crear-reserva"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  role             = aws_iam_role.crear_reserva.arn

  depends_on = [aws_cloudwatch_log_group.lambda]
}
