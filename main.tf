terraform {
  
}

module "web_bucket" {
  source = "./modules/web_bucket"
  team = var.team 
  environment = var.environment
  web_bucket_name = var.web_bucket_name
}
