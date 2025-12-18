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
  domains:
    - name: EMEA
      administrator:
        name: Dev Admin
      organizations:
        - name: Dev
          admins:
            - name: Dev Admin
              email: devadmin@foobar.com
              authentication_method: Email
              org_access: full
```

#### `main.tf`

```hcl
module "meraki" {
  source  = "netascode/nac-meraki/meraki"
  version = ">= 0.1.0"

  yaml_files = ["organizations_admins.yaml"]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_meraki"></a> [meraki](#requirement\_meraki) | >= 1.8.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | As an alternative to YAML files, a native Terraform data structure can be provided as well. | `map(any)` | `{}` | no |
| <a name="input_write_default_values_file"></a> [write\_default\_values\_file](#input\_write\_default\_values\_file) | Write all default values to a YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
| <a name="input_write_model_file"></a> [write\_model\_file](#input\_write\_model\_file) | Write the full model including all resolved templates to a single YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
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
| [meraki_appliance_connectivity_monitoring_destinations.networks_appliance_connectivity_monitoring_destinations](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_connectivity_monitoring_destinations) | resource |
| [meraki_appliance_content_filtering.networks_appliance_content_filtering](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_content_filtering) | resource |
| [meraki_appliance_firewall_settings.networks_appliance_firewall_settings_spoofing_protection_ip_source_guard_mode](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_firewall_settings) | resource |
| [meraki_appliance_firewalled_service.networks_appliance_firewall_firewalled_services](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_firewalled_service) | resource |
| [meraki_appliance_inbound_cellular_firewall_rules.networks_appliance_firewall_inbound_cellular_firewall_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_inbound_cellular_firewall_rules) | resource |
| [meraki_appliance_inbound_firewall_rules.networks_appliance_firewall_inbound_firewall_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_inbound_firewall_rules) | resource |
| [meraki_appliance_l3_firewall_rules.networks_appliance_firewall_l3_firewall_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_l3_firewall_rules) | resource |
| [meraki_appliance_l7_firewall_rules.networks_appliance_firewall_l7_firewall_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_l7_firewall_rules) | resource |
| [meraki_appliance_network_security_intrusion.networks_appliance_security_intrusion](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_network_security_intrusion) | resource |
| [meraki_appliance_one_to_many_nat_rules.networks_appliance_firewall_one_to_many_nat_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_one_to_many_nat_rules) | resource |
| [meraki_appliance_one_to_one_nat_rules.networks_appliance_firewall_one_to_one_nat_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_one_to_one_nat_rules) | resource |
| [meraki_appliance_organization_security_intrusion.organizations_appliance_security_intrusion_allowed_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_organization_security_intrusion) | resource |
| [meraki_appliance_port_forwarding_rules.networks_appliance_firewall_port_forwarding_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_port_forwarding_rules) | resource |
| [meraki_appliance_ports.networks_appliance_ports](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_ports) | resource |
| [meraki_appliance_radio_settings.devices_appliance_radio_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_radio_settings) | resource |
| [meraki_appliance_rf_profile.networks_appliance_rf_profiles](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_rf_profile) | resource |
| [meraki_appliance_sdwan_internet_policies.networks_appliance_sdwan_internet_policies](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_sdwan_internet_policies) | resource |
| [meraki_appliance_security_malware.networks_appliance_security_malware](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_security_malware) | resource |
| [meraki_appliance_settings.networks_appliance_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_settings) | resource |
| [meraki_appliance_single_lan.networks_appliance_single_lan](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_single_lan) | resource |
| [meraki_appliance_site_to_site_vpn.networks_appliance_vpn_site_to_site_vpn](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_site_to_site_vpn) | resource |
| [meraki_appliance_ssid.networks_appliance_ssids](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_ssid) | resource |
| [meraki_appliance_static_route.networks_appliance_static_routes](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_static_route) | resource |
| [meraki_appliance_third_party_vpn_peers.organizations_appliance_third_party_vpn_peers](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_third_party_vpn_peers) | resource |
| [meraki_appliance_traffic_shaping.networks_appliance_traffic_shaping](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_traffic_shaping) | resource |
| [meraki_appliance_traffic_shaping_custom_performance_class.networks_appliance_traffic_shaping_custom_performance_classes](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_traffic_shaping_custom_performance_class) | resource |
| [meraki_appliance_traffic_shaping_rules.networks_appliance_traffic_shaping_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_traffic_shaping_rules) | resource |
| [meraki_appliance_traffic_shaping_uplink_bandwidth.networks_appliance_traffic_shaping_uplink_bandwidth_limits](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_traffic_shaping_uplink_bandwidth) | resource |
| [meraki_appliance_traffic_shaping_uplink_selection.networks_appliance_traffic_shaping_uplink_selection](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_traffic_shaping_uplink_selection) | resource |
| [meraki_appliance_traffic_shaping_vpn_exclusions.networks_appliance_traffic_shaping_vpn_exclusions](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_traffic_shaping_vpn_exclusions) | resource |
| [meraki_appliance_uplinks_settings.devices_appliance_uplinks_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_uplinks_settings) | resource |
| [meraki_appliance_vlan.networks_appliance_vlans](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_vlan) | resource |
| [meraki_appliance_vlan_dhcp.networks_appliance_vlans_dhcp](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_vlan_dhcp) | resource |
| [meraki_appliance_vlans_settings.networks_appliance_vlans_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_vlans_settings) | resource |
| [meraki_appliance_vpn_bgp.networks_appliance_vpn_bgp](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_vpn_bgp) | resource |
| [meraki_appliance_vpn_firewall_rules.organizations_appliance_vpn_firewall_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_vpn_firewall_rules) | resource |
| [meraki_appliance_warm_spare.networks_appliance_warm_spare](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/appliance_warm_spare) | resource |
| [meraki_cellular_gateway_connectivity_monitoring_destinations.networks_cellular_gateway_connectivity_monitoring_destinations](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/cellular_gateway_connectivity_monitoring_destinations) | resource |
| [meraki_cellular_gateway_dhcp.networks_cellular_gateway_dhcp](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/cellular_gateway_dhcp) | resource |
| [meraki_cellular_gateway_lan.devices_cellular_gateway_lan](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/cellular_gateway_lan) | resource |
| [meraki_cellular_gateway_port_forwarding_rules.devices_cellular_gateway_port_forwarding_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/cellular_gateway_port_forwarding_rules) | resource |
| [meraki_cellular_gateway_subnet_pool.networks_cellular_gateway_subnet_pool](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/cellular_gateway_subnet_pool) | resource |
| [meraki_cellular_gateway_uplink.networks_cellular_gateway_uplink_bandwidth_limits](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/cellular_gateway_uplink) | resource |
| [meraki_device.devices](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/device) | resource |
| [meraki_device_cellular_sims.devices_cellular_sims](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/device_cellular_sims) | resource |
| [meraki_device_management_interface.devices_management_interface](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/device_management_interface) | resource |
| [meraki_network.organizations_networks](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/network) | resource |
| [meraki_network_device_claim.networks_devices_claim](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/network_device_claim) | resource |
| [meraki_network_floor_plan.networks_floor_plans](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/network_floor_plan) | resource |
| [meraki_network_group_policy.networks_group_policies](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/network_group_policy) | resource |
| [meraki_network_netflow.networks_netflow](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/network_netflow) | resource |
| [meraki_network_settings.networks_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/network_settings) | resource |
| [meraki_network_snmp.networks_snmp](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/network_snmp) | resource |
| [meraki_network_syslog_servers.networks_syslog_servers](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/network_syslog_servers) | resource |
| [meraki_network_vlan_profile.networks_vlan_profiles](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/network_vlan_profile) | resource |
| [meraki_organization.organizations](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization) | resource |
| [meraki_organization_adaptive_policy.organizations_adaptive_policy_policies](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_adaptive_policy) | resource |
| [meraki_organization_adaptive_policy_acl.organizations_adaptive_policy_acls](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_adaptive_policy_acl) | resource |
| [meraki_organization_adaptive_policy_group.organizations_adaptive_policy_groups](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_adaptive_policy_group) | resource |
| [meraki_organization_adaptive_policy_settings.organizations_adaptive_policy_settings_enabled_networks](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_adaptive_policy_settings) | resource |
| [meraki_organization_admin.organizations_admins](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_admin) | resource |
| [meraki_organization_early_access_features_opt_in.organizations_early_access_features_opt_ins](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_early_access_features_opt_in) | resource |
| [meraki_organization_inventory_claim.organizations_inventory](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_inventory_claim) | resource |
| [meraki_organization_login_security.organizations_login_security](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_login_security) | resource |
| [meraki_organization_policy_object.organizations_policy_objects](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_policy_object) | resource |
| [meraki_organization_policy_object_group.organizations_policy_objects_groups](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_policy_object_group) | resource |
| [meraki_organization_snmp.organizations_snmp](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/organization_snmp) | resource |
| [meraki_switch_access_control_lists.networks_switch_access_control_lists_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_access_control_lists) | resource |
| [meraki_switch_access_policy.networks_switch_access_policies](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_access_policy) | resource |
| [meraki_switch_alternate_management_interface.networks_switch_alternate_management_interface](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_alternate_management_interface) | resource |
| [meraki_switch_dhcp_server_policy.networks_switch_dhcp_server_policy](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_dhcp_server_policy) | resource |
| [meraki_switch_dhcp_server_policy_arp_inspection_trusted_server.networks_switch_dhcp_server_policy_arp_inspection_trusted_servers](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_dhcp_server_policy_arp_inspection_trusted_server) | resource |
| [meraki_switch_dscp_to_cos_mappings.networks_switch_dscp_to_cos_mappings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_dscp_to_cos_mappings) | resource |
| [meraki_switch_link_aggregation.networks_switch_link_aggregations](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_link_aggregation) | resource |
| [meraki_switch_mtu.networks_switch_mtu](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_mtu) | resource |
| [meraki_switch_port_schedule.networks_switch_port_schedules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_port_schedule) | resource |
| [meraki_switch_ports.devices_switch_ports](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_ports) | resource |
| [meraki_switch_qos_rule.networks_switch_qos_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_qos_rule) | resource |
| [meraki_switch_qos_rule_order.networks_switch_qos_rules_order](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_qos_rule_order) | resource |
| [meraki_switch_routing_interface.devices_switch_routing_interfaces](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_routing_interface) | resource |
| [meraki_switch_routing_interface_dhcp.devices_switch_routing_interfaces_dhcp](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_routing_interface_dhcp) | resource |
| [meraki_switch_routing_multicast.networks_switch_routing_multicast](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_routing_multicast) | resource |
| [meraki_switch_routing_multicast_rendezvous_point.networks_switch_routing_multicast_rendezvous_points](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_routing_multicast_rendezvous_point) | resource |
| [meraki_switch_routing_ospf.networks_switch_routing_ospf](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_routing_ospf) | resource |
| [meraki_switch_routing_static_route.devices_switch_routing_static_routes](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_routing_static_route) | resource |
| [meraki_switch_settings.networks_switch_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_settings) | resource |
| [meraki_switch_stack.networks_switch_stacks](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_stack) | resource |
| [meraki_switch_stack_routing_interface.networks_switch_stacks_routing_interfaces_first](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_stack_routing_interface) | resource |
| [meraki_switch_stack_routing_interface.networks_switch_stacks_routing_interfaces_not_first](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_stack_routing_interface) | resource |
| [meraki_switch_stack_routing_interface_dhcp.networks_switch_stacks_routing_interfaces_dhcp](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_stack_routing_interface_dhcp) | resource |
| [meraki_switch_stack_routing_static_route.networks_switch_stacks_routing_static_routes](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_stack_routing_static_route) | resource |
| [meraki_switch_storm_control.networks_switch_storm_control](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_storm_control) | resource |
| [meraki_switch_stp.networks_switch_stp](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/switch_stp) | resource |
| [meraki_wireless_alternate_management_interface.networks_wireless_alternate_management_interface](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_alternate_management_interface) | resource |
| [meraki_wireless_device_bluetooth_settings.devices_wireless_bluetooth_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_device_bluetooth_settings) | resource |
| [meraki_wireless_network_bluetooth_settings.networks_wireless_bluetooth_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_network_bluetooth_settings) | resource |
| [meraki_wireless_radio_settings.devices_wireless_radio_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_radio_settings) | resource |
| [meraki_wireless_rf_profile.networks_wireless_rf_profiles](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_rf_profile) | resource |
| [meraki_wireless_settings.networks_wireless_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_settings) | resource |
| [meraki_wireless_ssid.networks_wireless_ssids](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid) | resource |
| [meraki_wireless_ssid_bonjour_forwarding.networks_wireless_ssids_bonjour_forwarding](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid_bonjour_forwarding) | resource |
| [meraki_wireless_ssid_device_type_group_policies.networks_wireless_ssids_device_type_group_policies](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid_device_type_group_policies) | resource |
| [meraki_wireless_ssid_eap_override.networks_wireless_ssids_eap_override](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid_eap_override) | resource |
| [meraki_wireless_ssid_hotspot_20.networks_wireless_ssids_hotspot20](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid_hotspot_20) | resource |
| [meraki_wireless_ssid_identity_psk.networks_wireless_ssids_identity_psks](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid_identity_psk) | resource |
| [meraki_wireless_ssid_l3_firewall_rules.networks_wireless_ssids_firewall_l3_firewall_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid_l3_firewall_rules) | resource |
| [meraki_wireless_ssid_l7_firewall_rules.networks_wireless_ssids_firewall_l7_firewall_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid_l7_firewall_rules) | resource |
| [meraki_wireless_ssid_schedules.networks_wireless_ssids_unavailability_schedules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid_schedules) | resource |
| [meraki_wireless_ssid_splash_settings.networks_wireless_ssids_splash_settings](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid_splash_settings) | resource |
| [meraki_wireless_ssid_traffic_shaping_rules.networks_wireless_ssids_traffic_shaping_rules](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/resources/wireless_ssid_traffic_shaping_rules) | resource |
| [meraki_network.organizations_networks](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/data-sources/network) | data source |
| [meraki_organization.organizations](https://registry.terraform.io/providers/CiscoDevNet/meraki/latest/docs/data-sources/organization) | data source |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_model"></a> [model](#module\_model) | ./modules/model | n/a |
<!-- END_TF_DOCS -->