# ๐ EC2 ์ฉ SSH ํค ํ์ด ์ ์
resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = file("~/.ssh/web_admin.pub")
}

# ๐ SSH ์ ์ ํ์ฉ์ ์ํ ์ํ๋ฆฌํฐ ๊ทธ๋ฃน
resource "aws_security_group" "ssh" {
  name = "allow_ssh_from_all"
  description = "Allow SSH Port From All"
  ingress { # ์ธ๋ฐ์ด๋ ํธ๋ํฝ์ ์ ์ํ๋ ์์ฑ
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ๐ EC2 ์ธ์คํด์ค ์ ์
# ๊ธฐ๋ณธ Security Group ๋ถ๋ฌ์ค๊ธฐ - data๋ก ๋ถ๋ฌ์ค๊ธฐ
data "aws_security_group" "default" {
  name = "default"
  id = "sg-0060fbfb8a401dc14"
}

resource "aws_instance" "web" {
  ami = "ami-0a93a08544874b3b7" # amzn2-ami-hvm-2.0.20200207.1-x86_64-gp2
  instance_type = "t3.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    aws_security_group.ssh.id,  # SSH ํ์ฉ ์ํ๋ฆฌํฐ ๊ทธ๋ฃน
    data.aws_security_group.default.id  # Default VPC ์ํ๋ฆฌํฐ ๊ทธ๋ฃน
  ]
}


