output "instance_name" {
  value = "${aws_instance.appserva.public_dns}"
}

