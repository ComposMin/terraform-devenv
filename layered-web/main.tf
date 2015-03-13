# Specify the provider and access details
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "vpctop" {
    cidr_block = "10.1.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags {
        Name = "vpctop"
    }
}

resource "aws_subnet" "subnetA" {
    vpc_id = "${aws_vpc.vpctop.id}"
    cidr_block = "10.1.1.0/24"
    availability_zone = "ap-southeast-2a"
    map_public_ip_on_launch = true

    tags {
        Name = "subnetA"
    }
}

resource "aws_internet_gateway" "igwtop" {
    vpc_id = "${aws_vpc.vpctop.id}"
}

resource "aws_route_table" "routetabletop" {
    vpc_id = "${aws_vpc.vpctop.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igwtop.id}"
    }
}

resource "aws_route_table_association" "routeassoctop" {
    subnet_id = "${aws_subnet.subnetA.id}"
    route_table_id = "${aws_route_table.routetabletop.id}"
}

resource "aws_route53_record" "wwwtop" {
   zone_id = "Z2KQQ9G95L92Q3"   # TODO: make an input variable
   name = "www-dev2.composmin.net"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_elb.lbtop.dns_name}"]
}


resource "aws_elb" "lbtop" {
  name = "www-dev2-lb"
  # Attaching subnets determines which VPC the ELB ends up in. Do it! Or it ends up in the default VPC
  subnets = ["${aws_subnet.subnetA.id}"]
  security_groups = ["${aws_security_group.sgdevenv.id}"]
  listener {
    instance_port = 8082
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 4
    unhealthy_threshold = 2
    timeout = 2
    target = "HTTP:8082/hotels"
    interval = 5
  }
  instances = ["${aws_instance.appserva.id}"]
}

resource "aws_security_group" "sgdevenv" {
  name = "dev_env"
  description = "Allow any protocol"
  vpc_id = "${aws_vpc.vpctop.id}"

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
  security_groups = ["${aws_security_group.sgdevenv.id}"]
  subnet_id = "${aws_subnet.subnetA.id}"
  private_ip = "10.1.1.5"
  associate_public_ip_address = true
}
