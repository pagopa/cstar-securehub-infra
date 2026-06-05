module "gh_runner_job" {
  source = "./.terraform/modules/__v4__/gh_runner_container_app_job_domain_setup"

  domain_name        = var.domain
  env_short          = var.env_short
  environment_name   = local.gh_runners_cae_name
  environment_rg     = local.gh_runners_cae_rg
  gh_identity_suffix = "job-01"
  gh_env             = var.env
  runner_labels      = ["self-hosted-job", "${var.env}"]
  gh_repositories    = local.github_repositories_with_self_hosted_runners
  job                = {}
  job_meta           = {}
  key_vault = {
    name        = local.idpay_kv_name
    rg          = local.idpay_kv_rg_name
    secret_name = local.gh_token_secret
  }
  kubernetes_deploy       = {}
  prefix                  = var.prefix
  resource_group_name     = local.gh_runners_cae_rg
  domain_security_rg_name = local.idpay_kv_rg_name
  tags                    = module.tag_config.tags
}
