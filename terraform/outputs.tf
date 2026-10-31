output "api_url" {
  description = "URL base del API Gateway"
  value       = "https://${aws_api_gateway_rest_api.terrafleet.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}"
}

output "sqs_reservas_url" {
  description = "URL de la cola SQS de reservas"
  value       = aws_sqs_queue.reservas.url
}

output "sqs_resultados_url" {
  description = "URL de la cola SQS de resultados"
  value       = aws_sqs_queue.resultados.url
}

output "sqs_notificaciones_url" {
  description = "URL de la cola SQS de notificaciones"
  value       = aws_sqs_queue.notificaciones.url
}