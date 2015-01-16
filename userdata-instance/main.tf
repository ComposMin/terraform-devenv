# Specify the provider and access details
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_instance" "appserva" {
  instance_type = "t2.micro"
  ami = "ami-372b400d"
  key_name = "cfegan-cdenv"

  # NB:  interpolation with ${file("userdata.sh")} failed 20150113
  user_data = "${file("userdata.sh")}"
  #user_data = "#!/bin/bash\necho ****************** user_data ************* > /tmp/terraform_user_data.txt"
  associate_public_ip_address = true
}
