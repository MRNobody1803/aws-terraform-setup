output "webserver" {
  value = aws_instance.app-server.public_ip
}