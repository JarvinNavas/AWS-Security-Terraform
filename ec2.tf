# 1. Bloque DATA: Buscar el Sistema Operativo automáticamente
data "aws_ami" "ubuntu" {
  most_recent = true           # Trae la versión más nueva
  owners      = ["099720109477"] # El ID oficial de la empresa Canonical (creadores de Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] # Buscamos Ubuntu 22.04
  }
}

# 2. Bloque RESOURCE: Crear el Servidor
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id # Usamos el ID que encontró el bloque data arriba
  instance_type          = "t3.micro"             # Usamos la capa 100% gratuita
  subnet_id              = aws_subnet.subred_publica.id # Lo metemos en la subred que creaste ayer
  vpc_security_group_ids = [aws_security_group.sg_bastion.id] # Le ponemos tu firewall de ayer

  tags = {
    Name = "Bastion-Host-Seguro"
  }
}