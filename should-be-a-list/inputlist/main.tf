variable "arg" {
  type = "list"
}

resource "aws_elb" "test" {
  subnets = "${var.arg}"

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
