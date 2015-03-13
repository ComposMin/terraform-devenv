# Specify the provider and access details
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "hackday" {
    cidr_block = "192.168.1.0/24"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags {
        Name = "hackday"
    }
}

resource "aws_subnet" "hackday_subnet_a" {
    vpc_id = "${aws_vpc.hackday.id}"
    cidr_block = "192.168.1.0/25"
    availability_zone = "ap-southeast-2a"
    map_public_ip_on_launch = true

    tags {
        Name = "hackday_subnet_a"
    }
}

resource "aws_internet_gateway" "hackday_eip" {
    vpc_id = "${aws_vpc.hackday.id}"
}

resource "aws_route_table" "hackday_routes" {
    vpc_id = "${aws_vpc.hackday.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.hackday_eip.id}"
    }
    tags {
        Name = "hackday_routes"
    }
}

resource "aws_route_table_association" "routeassoctop" {
    subnet_id = "${aws_subnet.hackday_subnet_a.id}"
    route_table_id = "${aws_route_table.hackday_routes.id}"
}

resource "aws_route53_record" "hackday_dns" {
   zone_id = "Z2KQQ9G95L92Q3"   # TODO: make an input variable
   name = "hackday.composmin.net"
   type = "A"
   ttl = "60"
   records = ["${aws_instance.appserva.public_ip}"]
}

resource "aws_security_group" "wideopen" {
  name = "wideopen"
  description = "Allow any protocol on any port"
  vpc_id = "${aws_vpc.hackday.id}"

  ingress {
      from_port = 0
      to_port = 65535
      protocol = "-1"    #Any protocol
      cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "appserva" {
  instance_type = "t2.micro"
  ami = "ami-372b400d"
  key_name = "${var.ssh_key_name}"
  security_groups = ["${aws_security_group.wideopen.id}"]
  subnet_id = "${aws_subnet.hackday_subnet_a.id}"
  private_ip = "192.168.1.10"
  associate_public_ip_address = true
}
