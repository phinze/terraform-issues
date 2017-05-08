resource "aws_vpc" "genlist" {
  count = 2
  cidr_block = "10.0.1.0/24"
}

# computed output will repro
output "deeplist" {
  value = ["${aws_vpc.genlist.*.id}"]
}

# static output will not repro
# output "deeplist" {
#   value = ["one", "two"]
# }
