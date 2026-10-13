# Copilot instructions for cstar-securehub-infra

## Repository model

This repository provisions the CSTAR multi-tenant platform with Terraform. Each
directory under `src/` is an independently initialized Terraform root with its
own state and environment configuration:

- `0_entra` establishes Entra resources. Azure foundations then progress through
  networking, shared Key Vault/SOPS setup, core services, AKS, platform
  services, and Grafana configuration.
- `70_domains/<domain>_{common,security,app}` separates domain infrastructure:
  `common` provisions shared domain services, `security` creates Key Vaults and
  imports encrypted secrets, and `app` configures workload-facing components.
  Domains include `idpay`, `srtp`, `mdc`, and `shared`.
- `90_aws` is a separate AWS estate: `01_init` bootstraps it, `02_core` owns
  shared AWS resources, and domain stacks consume core outputs through explicit
  S3 remote-state data sources. Do not move a resource between these state roots
  without planning the required state migration/import.
- `91_github` configures PagoPA GitHub repositories, environments, variables,
  secrets, and rulesets; it reads required credentials from Azure Key Vault.

Azure stacks use an `azurerm` backend; AWS stacks use an S3 backend. Environment
inputs always live in `env/<environment>/`: `backend.ini` selects the Azure
subscription for the wrapper, `backend.tfvars` configures the state backend,
and `terraform.tfvars` supplies stack variables. Azure environments are
normally `itn-dev`, `itn-uat`, and `itn-prod`; AWS environments are
`central-dev`, `central-uat`, and `central-prod`.

Run dependent stacks in the order encoded by `scripts/terraform_run_all.sh`.
In particular, domain stacks consume infrastructure created by the foundational
stacks rather than recreating it; favor data sources for those dependencies.

## Terraform workflow

Terraform CLI version is pinned in `.terraform-version` (currently `1.12.2`);
use `tfenv install` if it is available. Authenticate with Azure CLI before
using an Azure stack. Run the linked `terraform.sh` from the Terraform root,
not from the repository root:

```sh
cd src/70_domains/idpay_common
./terraform.sh plan itn-dev
```

The wrapper reads `env/<environment>/backend.ini`, selects its subscription,
initializes with that environment's backend, and passes its
`terraform.tfvars`. It supports ordinary Terraform actions plus `summ` (plan
plus `tf-summarize`), `tflist`, and `tlock`. Production applies are audited,
interactive, and reject `-auto-approve`.

There is no application unit-test suite. Validate one Terraform root—the
equivalent of a single targeted test—with:

```sh
cd src/70_domains/idpay_common
./terraform.sh validate itn-dev
```

Run a targeted formatting check or the complete repository checks with:

```sh
pre-commit run terraform_fmt --files src/70_domains/idpay_common/03_postgres.tf
pre-commit run --all-files
# Equivalent containerized check used by contributors:
./scripts/pre-commit.sh
```

The pre-commit configuration runs `terraform_fmt`, `terraform_docs`, and
`terraform_validate`; it also regenerates the `BEGIN_TF_DOCS`/`END_TF_DOCS`
sections in per-stack `README.md` files. After changing providers, run
`./scripts/terraform_lock.sh` to update locks for the repository's supported
macOS and Linux architectures. Preserve multi-platform provider checksums.

## Terraform conventions

- Keep provider/backend declarations and the shared
  `terraform-azurerm-v4` module pin in each stack's `99_main.tf`. Root pins
  intentionally differ by stack; do not align them incidentally, because a pin
  can affect multiple child modules.
- Use `module "tag_config"` from `src/tag_config` for standard Azure tags and
  apply the resulting tags to resources. AWS stacks use `local.tags` through
  the AWS provider's `default_tags`.
- Match the local file organization: `00_data.tf` reads pre-existing
  infrastructure, numbered files declare a resource family, `99_locals.tf`
  derives naming values, and `99_main.tf` owns Terraform/provider setup.
- Preserve `env/` triples when adding an environment or a new root. Backend
  keys are state ownership boundaries, not interchangeable configuration.
- AKS, Helm, Argo CD, Keycloak, and Grafana provider configuration is
  stack-local and derives credentials or kubeconfig paths from locals/data
  sources. Do not copy provider blocks into unrelated stacks.

## Encrypted secrets

Security stacks decrypt SOPS files through `data.external.terrasops` and create
one Key Vault secret for every top-level JSON key. The encrypted input is
selected by `secrets/<vault>/<location>-<environment>/secret.ini`; do not
hard-code decrypted values in Terraform or tfvars.

`scripts/terrasops.sh` is an external-data protocol: its standard output must
remain a single JSON result. Send diagnostics only to standard error, and retain
its `jq`/`sops` prerequisite checks. Domain security roots link this script as
`terrasops.sh` and link the SOPS helper as `sops.sh`.
