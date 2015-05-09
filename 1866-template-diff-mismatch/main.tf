variable "key_name" { default = "tftest" }
variable "instance_type" { default = "t2.micro" }
variable "region" { default = "us-west-2" }


/* apply, then change this to get a diff mismatch */
variable "planet" { default = "Mars" }

module "vpc" {
  source   = "./vpc"

  name = "ssh-proxy-example"

  cidr = "10.0.0.0/16"
  private_subnets = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
  public_subnets  = "10.0.101.0/24,10.0.102.0/24,10.0.103.0/24"

  region   = "us-west-2"
  azs      = "us-west-2a,us-west-2b,us-west-2c"
}

module "ami" {
  source = "github.com/terraform-community-modules/tf_aws_ubuntu_ami/ebs"
  region = "us-west-2"
  distribution = "trusty"
  instance_type = "${var.instance_type}"
}

resource "template_file" "hello" {
  filename = "hello.tpl"
  vars {
    planet = "${var.planet}"
  }
}

resource "aws_security_group" "allow_ssh_from_world" {
  name = "sshproxy_sg_allow_ssh_from_world"
  description = "sshproxy_sg_allow_ssh_from_world"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public" {
  ami           = "${module.ami.ami_id}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  subnet_id     = "${element(split(",", module.vpc.public_subnets), count.index)}"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh_from_world.id}"]
  tags {
    Name = "1866-template-diff-mismatch"
    Hello = "${template_file.hello.rendered}"
    Planet = "${var.planet}"
  }
}

resource "consul_keys" "hello" {
  key {
    name = "hello"
    path = "world"
    value = "${aws_instance.public.tags.Hello}"
  }
}
