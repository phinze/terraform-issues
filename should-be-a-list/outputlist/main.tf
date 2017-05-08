resource "aws_vpc" "genlist" {
  count = 2
  cidr_block = "10.0.1.0/24"
}

# computed output will repro
output "alist" {
  value = ["${aws_vpc.genlist.*.id}"]
}

# static output will not repro
# output "alist" {
#   value = ["one", "two"]
# }
