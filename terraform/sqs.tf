resource "aws_sqs_queue" "reservas" {
  name = "${var.name_prefix}reservas"
}

resource "aws_sqs_queue" "resultados" {
  name = "${var.name_prefix}resultados"
}

resource "aws_sqs_queue" "notificaciones" {
  name = "${var.name_prefix}notificaciones"
}