
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface
resource "aws_network_interface" "int" {
  subnet_id = aws_subnet.main_subnet.id
  # Dynamic ?
  private_ips = ["10.0.0.10"]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "ami" {
  ami           = "ami-07140ec01fc325690"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.int.id
    device_index         = 0
  }
}