locals {
  meraki = {
    domains = [
      for domain in try(local.model.meraki.domains, []) : merge(
        { for k, v in domain : k => v if k != "organizations" },
        {
          organizations = [
            for organization in try(domain.organizations, []) : merge(
              { for k, v in organization : k => v if k != "networks" },
              {
                networks = [
                  for network in try(organization.networks, []) :
                  yamldecode(provider::utils::yaml_merge(concat(
                    [for t in try(network.templates, []) : [for template in try(local.model.meraki.template.networks, []) : yamlencode(templatestring(network.variables, template)) if template.name == t][0]],
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
