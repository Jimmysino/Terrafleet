resource "aws_lambda_function" "buscar_equipos" {
  function_name = "${var.name_prefix}buscar-equipos"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  handler = "index.handler"
  runtime = "nodejs22.x"
  role    = aws_iam_role.buscar_equipos.arn

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy.lambda_logs
  ]
}

resource "aws_lambda_function" "ver_disponibilidad" {
  function_name = "${var.name_prefix}ver-disponibilidad"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  handler = "index.handler"
  runtime = "nodejs22.x"
  role    = aws_iam_role.ver_disponibilidad.arn

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy.lambda_logs
  ]
}

resource "aws_lambda_function" "publicar_equipo" {
  function_name = "${var.name_prefix}publicar-equipo"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  handler = "index.handler"
  runtime = "nodejs22.x"
  role    = aws_iam_role.publicar_equipo.arn

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy.lambda_logs
  ]
}

resource "aws_lambda_function" "subir_foto" {
  function_name = "${var.name_prefix}subir-foto"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  handler = "index.handler"
  runtime = "nodejs22.x"
  role    = aws_iam_role.subir_foto.arn

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy.lambda_logs
  ]
}

resource "aws_lambda_function" "crear_reserva" {
  function_name = "${var.name_prefix}crear-reserva"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  handler = "index.handler"
  runtime = "nodejs22.x"
  role    = aws_iam_role.crear_reserva.arn

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy.lambda_logs
  ]
}