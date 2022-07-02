# https://stackoverflow.com/questions/63133012/upload-ssl-certs-using-terraform

resource "aws_acm_certificate" "certvpn" {
  private_key       = file("server.key")
  certificate_body  = file("server.crt")
  certificate_chain = file("ca.crt")
}