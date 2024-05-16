<!-- BEGIN_TF_DOCS -->
# Terraform Network-as-Code Cisco Meraki Module

A Terraform module to configure Cisco Meraki.

## Usage

This module supports an inventory driven approach, where a complete Meraki configuration or parts of it are either modeled in one or more YAML files or natively using Terraform variables.

## Examples

Configuring an organization administrator using YAML:

#### `organization.yaml`

```yaml
meraki:
  organizations:
    - name: MyOrg1
      administrators:
        - name: Admin1
          email: admin@cisco.com
          networks:
            - name: MyNet1
```

#### `main.tf`

```hcl
module "meraki" {
  source  = "netascode/nac-meraki/meraki"
  version = ">= 0.1.0"

  yaml_files = ["organization.yaml"]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.3.0 |
| <a name="requirement_meraki"></a> [meraki](#requirement\_meraki) | 0.2.0-alpha |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.2.5 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | As an alternative to YAML files, a native Terraform data structure can be provided as well. | `map(any)` | `{}` | no |
| <a name="input_write_default_values_file"></a> [write\_default\_values\_file](#input\_write\_default\_values\_file) | Write all default values to a YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
| <a name="input_yaml_directories"></a> [yaml\_directories](#input\_yaml\_directories) | List of paths to YAML directories. | `list(string)` | `[]` | no |
| <a name="input_yaml_files"></a> [yaml\_files](#input\_yaml\_files) | List of paths to YAML files. | `list(string)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_values"></a> [default\_values](#output\_default\_values) | All default values. |
| <a name="output_model"></a> [model](#output\_model) | Full model. |
## Resources

| Name | Type |
|------|------|
| [local_sensitive_file.defaults](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [meraki_networks.networks](https://registry.terraform.io/providers/cisco-open/meraki/0.2.0-alpha/docs/resources/networks) | resource |
| [meraki_organizations_admins.organizations_admins](https://registry.terraform.io/providers/cisco-open/meraki/0.2.0-alpha/docs/resources/organizations_admins) | resource |
| [meraki_organizations.organizations](https://registry.terraform.io/providers/cisco-open/meraki/0.2.0-alpha/docs/data-sources/organizations) | data source |
| [utils_yaml_merge.defaults](https://registry.terraform.io/providers/netascode/utils/latest/docs/data-sources/yaml_merge) | data source |
| [utils_yaml_merge.model](https://registry.terraform.io/providers/netascode/utils/latest/docs/data-sources/yaml_merge) | data source |
## Modules

No modules.
<!-- END_TF_DOCS -->