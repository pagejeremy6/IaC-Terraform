# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint
# Create the Client VPN endpoint + auth type  + logging
resource "aws_ec2_client_vpn_endpoint" "lab" {
  description            = "terraform-clientVPN-lab"
  server_certificate_arn = aws_acm_certificate.certvpn.arn
  client_cidr_block      = var.cidr_vpn
  split_tunnel           = true
  tags                   = var.resource_tags

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.certvpn.arn
  }

  connection_log_options {
    enabled = false
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association
resource "aws_ec2_client_vpn_network_association" "vpn_association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.lab.id
  subnet_id              = aws_subnet.main_subnet.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule
# Authorization rule for connected clients
resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.lab.id
  target_network_cidr    = aws_vpc.main.cidr_block
  authorize_all_groups   = true
}