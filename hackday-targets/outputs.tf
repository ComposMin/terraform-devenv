output "dns" {
  value = "${aws_instance.appserva.public_ip}"
}

