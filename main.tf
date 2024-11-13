locals {
  network_templates_map = {
    for t in try(local.model.meraki.templates.networks, []) : t.template_name => { for k, v in t : k => v if k != "template_name" }
  }
  organization_templates_map = {
    for t in try(local.model.meraki.templates.organizations, []) : t.template_name => { for k, v in t : k => v if k != "template_name" }
  }
  devices_templates_map = {
    for t in try(local.model.meraki.templates.devices, []) : t.template_name => { for k, v in t : k => v if k != "template_name" }
  }
  meraki = {
    domains = [
      for d in local.model.meraki.domains : merge(
        { for k, v in d : k => v if k != "organizations" },
        { organizations = [
          for org in d.organizations : merge(
            yamldecode(provider::utils::yaml_merge(concat(
              [for t_name in try(org.apply_organization_template, []) : yamlencode(local.organization_templates_map[t_name])],
            [yamlencode({ for k, v in org : k => v if k != "networks" })]))),
            { networks = [
              for n in try(org.networks, []) : merge(
                yamldecode(provider::utils::yaml_merge(concat(
                  [for t_name in try(n.apply_network_template, []) : yamlencode(local.network_templates_map[t_name])],
                [yamlencode({ for k, v in n : k => v if k != "devices" })]))),
                { devices = [
                  for dev in try(n.devices, []) :
                  yamldecode(provider::utils::yaml_merge(concat(
                    [for t_name in try(dev.apply_device_template, []) : yamlencode(local.devices_templates_map[t_name])],
                  [yamlencode(dev)])))
                ] }
              )
              ]
            }
          )]
        }
      )
    ]
  }
}
