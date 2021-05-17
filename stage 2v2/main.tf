provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

resource "aws_instance" "Ubuntu" {
    ami = var.ami
    instance_type = "t3.micro"
    key_name      = "mysshkey"
    vpc_security_group_ids = [aws_security_group.nameubuntusecurity.id]
    tags = {
      "Name" = "MyUbuntuserver"
      "Owner" = "Egor Kozak"
      "Project" = "Stage 2"
    }
}

resource "null_resource" "remote-data" {

    connection {
      type = "ssh"
      host = aws_instance.Ubuntu.public_ip
      user = "ubuntu"
      private_key = file("mysshkey.pem")
    }

   provisioner "remote-exec" {
    inline = [
      "sudo apt -y update",
      "sudo apt -y install apache2",
      
    ]
  }
  depends_on = [ aws_instance.Ubuntu ]
  }


resource "aws_security_group" "nameubuntusecurity" {
    name = "WebServer sec. group"
    description = "sec. group"

    ingress {
      from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 

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

resource "null_resource" "example" {
  triggers = {
    content = "1.1"
  }
  connection {
      type = "ssh"
      host = aws_instance.Ubuntu.public_ip
      user = "ubuntu"
      private_key = file("mysshkey.pem")
    }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod -R 777 /var/www/html/",
      "sudo echo '<html><head><meta charset='utf-8'><title>Этап 2</title></head><body><p>Тестовый веб сервер для второго этапа2222!</p></body></html>' > /var/www/html/index.html",
    ]
  }
  depends_on = [ null_resource.remote-data ]
}