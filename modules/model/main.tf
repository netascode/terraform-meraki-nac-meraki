locals {
  templates_networks = [
    for template in try(local.model.meraki.templates.networks, []) : {
      name : template.name,
      type : template.type,
      configuration : template.type == "model" ? replace(yamlencode(template.configuration), "/\"([$%]{.*})\"/", "$1") : "${path.root}/${template.file}"
    }
  ]
  templates_devices = [
    for template in try(local.model.meraki.templates.devices, []) : {
      name : template.name,
      type : template.type,
      configuration : template.type == "model" ? replace(yamlencode(template.configuration), "/\"([$%]{.*})\"/", "$1") : "${path.root}/${template.file}"
    }
  ]
  networks_templated = {
    meraki = {
      domains = [
        for domain in try(local.model.meraki.domains, []) : merge(
          { for k, v in domain : k => v if k != "organizations" },
          try(domain.organizations, null) == null ? {} : {
            organizations = [
              for organization in domain.organizations : merge(
                { for k, v in organization : k => v if k != "networks" },
                try(organization.networks, null) == null ? {} : {
                  networks = [
                    for network in organization.networks :
                    yamldecode(provider::utils::yaml_merge(concat(
                      [for t in try(network.templates, []) : [for template in local.templates_networks : (template.type == "model" ? templatestring(template.configuration, try(network.variables, {})) : templatefile(template.configuration, try(network.variables, {}))) if template.name == t][0]],
                      [yamlencode(network)]
                    )))
                  ]
                }
              )
            ]
          }
        )
      ]
    }
  }
  meraki = {
    meraki = {
      domains = [
        for domain in try(local.networks_templated.meraki.domains, []) : merge(
          { for k, v in domain : k => v if k != "organizations" },
          try(domain.organizations, null) == null ? {} : {
            organizations = [
              for organization in domain.organizations : merge(
                { for k, v in organization : k => v if k != "networks" },
                try(organization.networks, null) == null ? {} : {
                  networks = [
                    for network in organization.networks : merge(
                      { for k, v in network : k => v if k != "devices" },
                      try(network.devices, null) == null ? {} : {
                        devices = [
                          for device in network.devices :
                          yamldecode(provider::utils::yaml_merge(concat(
                            [for t in try(device.templates, []) : [for template in local.templates_devices : (template.type == "model" ? templatestring(template.configuration, try(device.variables, {})) : templatefile(template.configuration, try(device.variables, {}))) if template.name == t][0]],
                            [yamlencode(device)]
                          )))
                        ]
                      }
                    )
                  ]
                }
              )
            ]
          }
        )
      ]
    }
  }
}
