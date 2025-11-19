
## 0.5.1

Bug Fixes:

- Fix `neighbors[]` paths in appliance VPN BGP configuration
- Fix defaults path for `organizations_policy_objects`
- Fix defaults path for `networks_appliance_security_intrusion`
- Fix `band_steering` path for `networks_wireless_rf_profiles` (missed during schema 1.56 changes)
- Fix `named_vlans_pool_dhcp_monitoring` path for `networks_wireless_settings` (missed during schema 1.56 changes)
- Fix `local_radius` path for `networks_wireless_ssids` (missed during schema 1.56 changes)
- Fix checks for non-flattened firewall rule resources
- Don't create `networks_appliance_vlans_dhcp` if no fields specified (https://github.com/netascode/terraform-meraki-nac-meraki/pull/117)

Enhancements:

- Reduce differences with generated modules for better maintainability (https://github.com/netascode/terraform-meraki-nac-meraki/pull/123)
  - Unify `try()` usage in loops for `networks_switch_stp`
  - Standardize loop variable names across resources
  - Reorder fields in `meraki_appliance` for consistency
  - Unify loop formatting in `organizations_admins`
  - Unify `for_each` variable naming conventions
  - Unify `depends_on` formatting
  - Remove redundant `depends_on` declarations
  - Unify checks for flattened rules resources in `meraki_appliance`
- Add `ipv6_prefix_assignments[].disabled` support for `networks_appliance_vlans` (https://github.com/netascode/terraform-meraki-nac-meraki/pull/116)
- Move PUT-only attributes from `networks_appliance_vlans` to `networks_appliance_vlans_dhcp` (https://github.com/netascode/terraform-meraki-nac-meraki/pull/115)
- Update provider version to `CiscoDevNet/meraki` 1.8.0 (https://github.com/netascode/terraform-meraki-nac-meraki/pull/125)

## 0.5.0

New features:
-  Add support for unmanaged networks (https://github.com/netascode/terraform-meraki-nac-meraki/pull/87)

## 0.4.0

Breaking Changes:

- `networks_wireless_ssids_schedules` renamed to `networks_wireless_ssids_unavailability_schedules` (https://github.com/netascode/terraform-meraki-nac-meraki/pull/96)
- Port configuration refactoring to support ranges instead of individual ports (https://github.com/netascode/terraform-meraki-nac-meraki/pull/78)
  - Switch from `port_id` to `port_id_ranges` for appliance ports
  - Switch from `port_id` to `port_id_ranges` for switch ports
  - Enables action batches for port configurations

New Features:

- Add `networks_wireless_ssids_firewall_l7_firewall_rules` resource for Layer 7 wireless firewall rules (https://github.com/netascode/terraform-meraki-nac-meraki/pull/77)

Enhancements:

- Improved dependency management for switch ports and appliance ports (https://github.com/netascode/terraform-meraki-nac-meraki/pull/85, https://github.com/netascode/terraform-meraki-nac-meraki/pull/86)
- Map device names to serials for `stp_bridge_priority` configuration (https://github.com/netascode/terraform-meraki-nac-meraki/pull/91)
- Add support for port ranges in switch and appliance port configurations (https://github.com/netascode/terraform-meraki-nac-meraki/pull/78)
  - Optimized logic to build single list for all ports per switch/appliance
  - Supports batch operations for improved performance
- Map `group_policy_id` from `group_policy_name` for wireless and appliance configurations (https://github.com/netascode/terraform-meraki-nac-meraki/pull/111)

## 0.3.4

Enhancements:

- `networks_appliance_firewall_inbound_firewall_rules` and `networks_appliance_firewall_l3_firewall_rules`
  - Added VLAN dependencies to ensure proper resource ordering (https://github.com/netascode/terraform-meraki-nac-meraki/pull/94)
- `organizations_networks`
    - Some hardcoded defaults were missed when refactoring defaults handling in #47. https://github.com/netascode/terraform-meraki-nac-meraki/pull/101
    - Added `networks` `product_types` values to defaults file

Breaking Changes:

- Reverted device-claim batching functionality (https://github.com/netascode/terraform-meraki-nac-meraki/pull/95)
  - Removed the added defaults

## 0.3.3

Enhancements:

- Defaults updates and configuration improvements

## 0.3.2

Enhancements:

Add support for dhcp_relay_server_ips in networks_appliance_vlans_settings

## 0.3.1

Enhancements:

- `devices_switch_ports`
    - Added dependancy on Adaptive Policy Org Networks to fix issue with ports assigning adaptive policy prior to creation of the policy. (https://github.com/netascode/terraform-meraki-nac-meraki/pull/79)

- `organizations_adaptive_policy_settings_enabled_networks`
    - Added dependancy on device claim, to ensure at least one appliance is claimed and in place prior to adding adaptive policy settings to enabled networks. (https://github.com/netascode/terraform-meraki-nac-meraki/pull/79)


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


## 0.1.0

- Initial release
