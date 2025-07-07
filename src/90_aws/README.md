To use Terraform in this folder, you need to configure the file at `$HOME/.aws/config` as follows:
```
[profile cstar-ENV]
sso_start_url = SSO_START_URL
sso_region = SSO_REGION
sso_account_id = ACCOUNT_ID
sso_role_name = ROLE_NAME
region = REGION
output = json
```
The profile name (`cstar-ENV`) must match the one defined in the environment's `.tfvars` file.
