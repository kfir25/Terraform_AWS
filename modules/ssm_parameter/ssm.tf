
resource "aws_ssm_parameter" "microservice_token" {
  name  =  var.name #"/microservice/token"
  type  = "SecureString"
  value = var.microservice_token
}