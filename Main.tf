provider "aws" {
        region = "ap-south-1"
}

resource "aws_instance" "example" {
        ami = "ami-efa5fe80"
        instance_type = "t2.micro"
        key_name = "jai_terraform"
                subnet_id = "subnet-18008455"
        security_groups = ["sg-74f26f1f"]
                associate_public_ip_address = "true"
        tags {
         Name = "jai-tera-form"

        }
        user_data = "${file("./apache.sh")}"

}
resource "aws_elb" "example" {
  name               = "terra-elb"
  subnets = ["subnet-18008455"]
  security_groups = ["sg-74f26f1f"]



  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }



  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${aws_instance.example.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  
  tags {
    Name = "example-terraform-elb"
  }
}

