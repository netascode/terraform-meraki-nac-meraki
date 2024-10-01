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
  source = "CiscoDevNet/meraki"
  version = ">= 0.1.0"

  yaml_files = ["organization.yaml"]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.5.1 |
| <a name="requirement_meraki"></a> [meraki](#requirement\_meraki) | >= 0.1.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.2.5 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_url"></a> [base\_url](#input\_base\_url) | Base URL | `string` | `"https://api.meraki.com/"` | no |
| <a name="input_model"></a> [model](#input\_model) | As an alternative to YAML files, a native Terraform data structure can be provided as well. | `map(any)` | `{}` | no |
| <a name="input_write_default_values_file"></a> [write\_default\_values\_file](#input\_write\_default\_values\_file) | Write all default values to a YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
| <a name="input_yaml_directories"></a> [yaml\_directories](#input\_yaml\_directories) | List of paths to YAML directories. | `list(string)` | `[]` | no |
| <a name="input_yaml_files"></a> [yaml\_files](#input\_yaml\_files) | List of paths to YAML files. | `list(string)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_CX_DEBUG"></a> [CX\_DEBUG](#output\_CX\_DEBUG) | n/a |
| <a name="output_default_values"></a> [default\_values](#output\_default\_values) | All default values. |
| <a name="output_domains"></a> [domains](#output\_domains) | n/a |
| <a name="output_marcin_debug"></a> [marcin\_debug](#output\_marcin\_debug) | n/a |
| <a name="output_model"></a> [model](#output\_model) | Full model. |
| <a name="output_organization_map"></a> [organization\_map](#output\_organization\_map) | Output the organization map |
| <a name="output_test"></a> [test](#output\_test) | n/a |
## Resources

| Name | Type |
|------|------|
| [local_sensitive_file.defaults](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [meraki_networks.networks](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks) | resource |
| [meraki_networks_group_policies.net_group_policies](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_group_policies) | resource |
| [meraki_networks_settings.net_settings](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_settings) | resource |
| [meraki_networks_switch_access_control_lists.net_switch_access_control_lists](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_access_control_lists) | resource |
| [meraki_networks_switch_access_policies.net_switch_access_policies](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_access_policies) | resource |
| [meraki_networks_switch_alternate_management_interface.net_switch_alternate_management_interface](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_alternate_management_interface) | resource |
| [meraki_networks_switch_dhcp_server_policy.net_switch_dhcp_server_policy](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_dhcp_server_policy) | resource |
| [meraki_networks_switch_dhcp_server_policy_arp_inspection_trusted_servers.net_switch_dhcp_server_policy_arp_inspection_trusted_servers](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_dhcp_server_policy_arp_inspection_trusted_servers) | resource |
| [meraki_networks_switch_dscp_to_cos_mappings.net_switch_dscp_to_cos_mappings](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_dscp_to_cos_mappings) | resource |
| [meraki_networks_switch_link_aggregations.net_switch_link_aggregations](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_link_aggregations) | resource |
| [meraki_networks_switch_mtu.net_switch_mtu](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_mtu) | resource |
| [meraki_networks_switch_port_schedules.net_switch_port_schedules](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_port_schedules) | resource |
| [meraki_networks_switch_qos_rules_order.net_switch_qos_rules_order](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_qos_rules_order) | resource |
| [meraki_networks_switch_routing_multicast.net_switch_routing_multicast](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_routing_multicast) | resource |
| [meraki_networks_switch_routing_multicast_rendezvous_points.net_switch_routing_multicast_rendezvous_points](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_routing_multicast_rendezvous_points) | resource |
| [meraki_networks_switch_routing_ospf.net_switch_routing_ospf](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_routing_ospf) | resource |
| [meraki_networks_switch_settings.net_switch_settings](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_settings) | resource |
| [meraki_networks_switch_stacks.net_switch_stacks](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_stacks) | resource |
| [meraki_networks_switch_stacks_routing_interfaces.net_switch_stacks_routing_interfaces](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_stacks_routing_interfaces) | resource |
| [meraki_networks_switch_stacks_routing_static_routes.net_switch_stacks_routing_static_routes](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_stacks_routing_static_routes) | resource |
| [meraki_networks_switch_storm_control.net_switch_storm_control](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_storm_control) | resource |
| [meraki_networks_switch_stp.net_switch_stp](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_switch_stp) | resource |
| [meraki_networks_syslog_servers.net_syslog_servers](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_syslog_servers) | resource |
| [meraki_networks_vlan_profiles.net_vlan_profiles](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_vlan_profiles) | resource |
| [meraki_networks_wireless_rf_profiles.net_wireless_rf_profiles](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_wireless_rf_profiles) | resource |
| [meraki_networks_wireless_settings.net_wireless_settings](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_wireless_settings) | resource |
| [meraki_networks_wireless_ssids.net_wireless_ssids](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/networks_wireless_ssids) | resource |
| [meraki_organizations_admins.organizations_admins](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/organizations_admins) | resource |
| [meraki_organizations_login_security.login_security](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/organizations_login_security) | resource |
| [meraki_organizations_snmp.snmp](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/resources/organizations_snmp) | resource |
| [meraki_networks_switch_routing_multicast_rendezvous_points.data_rendezvous_points](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/data-sources/networks_switch_routing_multicast_rendezvous_points) | data source |
| [meraki_networks_switch_stacks.data_switch_stacks](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/data-sources/networks_switch_stacks) | data source |
| [meraki_organizations.organizations](https://registry.terraform.io/providers/cisco-open/meraki/0.2.9-alpha/docs/data-sources/organizations) | data source |
| [utils_yaml_merge.defaults](https://registry.terraform.io/providers/netascode/utils/latest/docs/data-sources/yaml_merge) | data source |
| [utils_yaml_merge.model](https://registry.terraform.io/providers/netascode/utils/latest/docs/data-sources/yaml_merge) | data source |
## Modules

No modules.
<!-- END_TF_DOCS -->
