module "gh_runner_job" {
  source = "./.terraform/modules/__v4__/gh_runner_container_app_job_domain_setup"

  domain_name = var.domain
  env_short   = var.env_short

  environment_name = local.github_cae_name
  environment_rg   = local.github_cae_rg

  gh_identity_suffix = "job-01"
  runner_labels      = ["self-hosted-job", var.env]
  gh_env             = var.env
  gh_repositories = [
    {
      name : "rtp-platform-qa",
      short_name : "platform-qa"
    }
  ]
  job = {
    name = var.domain
  }
  job_meta = {}

  key_vault = {
    name        = "${local.product}-cicd-kv"        # Name of the KeyVault which stores PAT as secret
    rg          = "${local.product}-core-sec-rg"    # Resource group of the KeyVault which stores PAT as secret
    secret_name = "${var.domain}-gh-runner-job-pat" # Data of the KeyVault which stores PAT as secret
  }

  location                = var.location
  prefix                  = var.prefix
  resource_group_name     = "${local.product}-platform-compute-rg"
  domain_security_rg_name = "${local.project}-security-rg"

  identity_rg_name = local.identities_rg
  identity_role    = "ci"

  tags = module.tag_config.tags
}
