provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}
resource "aws_instance" "Ubuntu" {
    ami = var.ami
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.nameubuntusecurity.id]
    user_data = file("mydata.sh")
    tags = {
      "Name" = "MyUbuntuserver"
      "Owner" = "Egor Kozak"
      "Project" = "Stage 2"
    }
}

resource "aws_security_group" "nameubuntusecurity" {
    name = "WebServer sec. group"
    description = "sec. group"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }  
  
}