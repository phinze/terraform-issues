module "outputlist" {
  source = "./outputlist"
}

module "inputlist" {
  source = "./inputlist"
  arg = "${module.outputlist.alist}"
}
