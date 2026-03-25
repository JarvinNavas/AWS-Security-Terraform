# 1. Creación de la VPC Principal
resource "aws_vpc" "red_segura" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "VPC-Segura-DevSecOps"
    Environment = "Laboratorio"
  }
}

# 2. Creación de una Subred Pública (Donde vivirá el Bastion Host)
resource "aws_subnet" "subred_publica" {
  vpc_id                  = aws_vpc.red_segura.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Esto permite que los recursos aquí tengan IP pública
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Subred-Publica-Bastion"
  }
}

# 3. Creación de un Internet Gateway (La puerta de salida a Internet)
resource "aws_internet_gateway" "igw_red_segura" {
  vpc_id = aws_vpc.red_segura.id

  tags = {
    Name = "IGW-VPC-Segura"
  }
}

# 4. Tabla de Enrutamiento Pública (El mapa para salir a Internet)
resource "aws_route_table" "tabla_rutas_publica" {
  vpc_id = aws_vpc.red_segura.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_red_segura.id
  }

  tags = {
    Name = "Tabla-Rutas-Publica"
  }
}

# 5. Asociación de la Tabla de Enrutamiento a la Subred Pública
resource "aws_route_table_association" "asociacion_publica" {
  subnet_id      = aws_subnet.subred_publica.id
  route_table_id = aws_route_table.tabla_rutas_publica.id
}

# 6. Creación del Firewall (Security Group) para el Bastion Host
resource "aws_security_group" "sg_bastion" {
  name        = "SG-Bastion-Host"
  description = "Permitir SSH solo desde mi IP"
  vpc_id      = aws_vpc.red_segura.id # Lo amarramos a la VPC que creaste arriba

  # Regla de Entrada (Ingress): Permitir SSH
  ingress {
    description = "SSH desde mi IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # REGLA DE ORO DE SEGURIDAD: Nunca uses 0.0.0.0/0 para SSH.
    # Por ahora, simularemos que tu IP es 203.0.113.50. 
    # (En la vida real, pondrías tu IP pública real aquí).
    cidr_blocks = [var.mi_ip_publica] # ATENCIÓN: Cambiaremos esto en un segundo.
  }

  # Regla de Salida (Egress): Permitir todo el trafico hacia afuera
  egress {
    description = "Permitir salida a Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # El -1 significa "todos los protocolos"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Bastion-Host"
  }
}