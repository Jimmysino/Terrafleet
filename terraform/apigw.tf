resource "aws_api_gateway_rest_api" "terrafleet" {
  name        = "${var.name_prefix}terrafleet-api"
  description = "API REST del laboratorio TerraFleet."

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "equipos" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  parent_id   = aws_api_gateway_rest_api.terrafleet.root_resource_id
  path_part   = "equipos"
}

resource "aws_api_gateway_resource" "equipo_id" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  parent_id   = aws_api_gateway_resource.equipos.id
  path_part   = "{id}"
}

resource "aws_api_gateway_resource" "equipo_foto" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  parent_id   = aws_api_gateway_resource.equipo_id.id
  path_part   = "foto"
}

resource "aws_api_gateway_resource" "disponibilidad" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  parent_id   = aws_api_gateway_rest_api.terrafleet.root_resource_id
  path_part   = "disponibilidad"
}

resource "aws_api_gateway_resource" "disponibilidad_id" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  parent_id   = aws_api_gateway_resource.disponibilidad.id
  path_part   = "{id}"
}

resource "aws_api_gateway_resource" "reservas" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  parent_id   = aws_api_gateway_rest_api.terrafleet.root_resource_id
  path_part   = "reservas"
}

resource "aws_api_gateway_method" "buscar_equipos" {
  rest_api_id   = aws_api_gateway_rest_api.terrafleet.id
  resource_id   = aws_api_gateway_resource.equipos.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "buscar_equipos" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  resource_id = aws_api_gateway_resource.equipos.id
  http_method = aws_api_gateway_method.buscar_equipos.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.buscar_equipos.invoke_arn
}

resource "aws_lambda_permission" "buscar_equipos" {
  statement_id  = "AllowAPIGatewayBuscarEquipos"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.buscar_equipos.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.terrafleet.execution_arn}/dev/GET/equipos"
}

resource "aws_api_gateway_method" "ver_disponibilidad" {
  rest_api_id   = aws_api_gateway_rest_api.terrafleet.id
  resource_id   = aws_api_gateway_resource.disponibilidad_id.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "ver_disponibilidad" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  resource_id = aws_api_gateway_resource.disponibilidad_id.id
  http_method = aws_api_gateway_method.ver_disponibilidad.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.ver_disponibilidad.invoke_arn
}

resource "aws_lambda_permission" "ver_disponibilidad" {
  statement_id  = "AllowAPIGatewayVerDisponibilidad"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ver_disponibilidad.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.terrafleet.execution_arn}/dev/GET/disponibilidad/*"
}

resource "aws_api_gateway_method" "publicar_equipo" {
  rest_api_id   = aws_api_gateway_rest_api.terrafleet.id
  resource_id   = aws_api_gateway_resource.equipos.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "publicar_equipo" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  resource_id = aws_api_gateway_resource.equipos.id
  http_method = aws_api_gateway_method.publicar_equipo.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.publicar_equipo.invoke_arn
}

resource "aws_lambda_permission" "publicar_equipo" {
  statement_id  = "AllowAPIGatewayPublicarEquipo"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.publicar_equipo.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.terrafleet.execution_arn}/dev/POST/equipos"
}

resource "aws_api_gateway_method" "subir_foto" {
  rest_api_id   = aws_api_gateway_rest_api.terrafleet.id
  resource_id   = aws_api_gateway_resource.equipo_foto.id
  http_method   = "POST"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "subir_foto" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  resource_id = aws_api_gateway_resource.equipo_foto.id
  http_method = aws_api_gateway_method.subir_foto.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.subir_foto.invoke_arn
}

resource "aws_lambda_permission" "subir_foto" {
  statement_id  = "AllowAPIGatewaySubirFoto"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.subir_foto.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.terrafleet.execution_arn}/dev/POST/equipos/*/foto"
}

resource "aws_api_gateway_method" "crear_reserva" {
  rest_api_id   = aws_api_gateway_rest_api.terrafleet.id
  resource_id   = aws_api_gateway_resource.reservas.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "crear_reserva" {
  rest_api_id = aws_api_gateway_rest_api.terrafleet.id
  resource_id = aws_api_gateway_resource.reservas.id
  http_method = aws_api_gateway_method.crear_reserva.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.crear_reserva.invoke_arn
}

resource "aws_lambda_permission" "crear_reserva" {
  statement_id  = "AllowAPIGatewayCrearReserva"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.crear_reserva.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.terrafleet.execution_arn}/dev/POST/reservas"
}