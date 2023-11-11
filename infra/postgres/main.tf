module "security_groups" {
  source = "./modules/security-groups"
}

module "rds" {
  source            = "./modules/rds"
  security_group_id = module.security_groups.sample_app_postgres_security_group_id

  depends_on = [module.security_groups]
}


