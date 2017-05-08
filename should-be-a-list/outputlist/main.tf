module "deeplist" {
  source = "./child"
}

output "alist" {
  value = "${module.deeplist.deeplist}"
}
