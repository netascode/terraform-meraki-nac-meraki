## 0.1.0

- Initial release

## 0.3.0

Features:

- Support Unmanaged Organizations (https://github.com/netascode/terraform-meraki-nac-meraki/pull/48)
- Add Support for Templates (https://github.com/netascode/terraform-meraki-nac-meraki/pull/46, https://github.com/netascode/terraform-meraki-nac-meraki/pull/62)

Add Resources:

- `networks_appliance_connectivity_monitoring_destinations`
- `organizations_appliance_security_intrusion_allowed_rules`
- `devices_appliance_radio_settings`
- `networks_appliance_rf_profiles`
- `networks_appliance_sdwan_internet_policies`
- `networks_appliance_ssids`
- `networks_appliance_static_routes`
- `networks_appliance_traffic_shaping`
- `networks_appliance_traffic_shaping_custom_performance_classes`
- `networks_appliance_traffic_shaping_rules`
- `networks_appliance_traffic_shaping_uplink_bandwidth_limits`
- `networks_appliance_traffic_shaping_uplink_selection`
- `networks_appliance_traffic_shaping_vpn_exclusions`
- `networks_cellular_gateway_connectivity_monitoring_destinations`
- `networks_cellular_gateway_dhcp`
- `devices_cellular_gateway_lan`
- `devices_cellular_gateway_port_forwarding_rules`
- `networks_cellular_gateway_subnet_pool`
- `networks_cellular_gateway_uplink_bandwidth_limits`
- `devices_cellular_sims`
- `organizations_early_access_features_opt_ins`

Enhancements:

- `networks_appliance_firewall_l7_firewall_rules`
    - Added value_countries
- `networks_wireless_rf_profiles`
    - Fixed error if `per_ssid_settings` is missing
- `devices_switch_ports` 
    - Fix access policy name mapping device switch port to policy number
- `organizations_appliance_third_party_vpn_peers`
    - Add missing public_hostname and ipsec_policies_preset (https://github.com/netascode/terraform-meraki-nac-meraki/pull/56/commits/4ec3fb61963f34038949dfec439acd2a1b486b03)
- `networks_appliance_vpn_site_to_site_vpn` 
    - Add missing subnet_nat_is_allowed field (https://github.com/netascode/terraform-meraki-nac-meraki/pull/56/commits/43d3e6a00e917a3d0b3084e4fcb6b87e73a5ebe2)
- `networks_appliance_vlans_settings`
   - Create the resource if anything under appliance is configured (https://github.com/netascode/terraform-meraki-nac-meraki/pull/56/commits/d1a6b220dca2e092c2bdef88d981ac654c7b4a67)

Breaking Changes:

- `organizations_inventory` Use "serials" instead of `devices` (https://github.com/netascode/terraform-meraki-nac-meraki/commit/b3eca5bf802d9310ee9aa81955a0b1aec4433f8f)

- Update for schema 1.56

    (https://github.com/netascode/terraform-meraki-nac-meraki/pull/41, https://github.com/netascode/terraform-meraki-nac-meraki/pull/43, https://github.com/netascode/terraform-meraki-nac-meraki/pull/44)

- Refactor resource keys, names and apply defaults consistently

     (https://github.com/netascode/terraform-meraki-nac-meraki/pull/47, https://github.com/netascode/terraform-meraki-nac-meraki/pull/53, https://github.com/netascode/terraform-meraki-nac-meraki/pull/52)



## 0.3.1

Enhancements:

- `devices_switch_ports`
    - Added dependancy on Adaptive Policy Org Networks to fix issue with ports assigning adaptive policy prior to creation of the policy. (https://github.com/netascode/terraform-meraki-nac-meraki/pull/79)

- `organizations_adaptive_policy_settings_enabled_networks`
    - Added dependancy on device claim, to ensure at least one appliance is claimed and in place prior to adding adaptive policy settings to enabled networks. (https://github.com/netascode/terraform-meraki-nac-meraki/pull/79)

## 0.3.2

Enhancements:

Add support for dhcp_relay_server_ips in networks_appliance_vlans_settings

## 0.3.3

Enhancements:

- Defaults updates and configuration improvements

## 0.3.4

Enhancements:

- `meraki_appliance_inbound_firewall_rules` and `meraki_appliance_l3_firewall_rules`
  - Added VLAN dependencies to ensure proper resource ordering (https://github.com/netascode/terraform-meraki-nac-meraki/pull/94)

Breaking Changes:

- Reverted device-claim batching functionality (https://github.com/netascode/terraform-meraki-nac-meraki/pull/95)
  - Removed the added defaults
