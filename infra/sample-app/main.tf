# module "ecr" {
#   source = "./modules/ecr"
# }

module "lb" {
  source = "./modules/lb"
}

module "ecs" {
  source           = "./modules/ecs"
  redis_url        = var.redis_url
  target_group_arn = module.lb.lb_target_group_arn

  depends_on = [module.lb]
}
