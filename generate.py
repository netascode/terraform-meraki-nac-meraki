#!/usr/bin/env python3

###

import json

template = """

### marcin generated
### resource name: {RESOURCE_NAME}
### values: {VALUES}

locals {{
  networks_{RESOURCE_NAME} = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {{
          network_id = meraki_networks.networks["${{domain.name}}/${{org.name}}/${{network.name}}"].id
          data       = network.{RESOURCE_NAME}
        }} if try(network.{RESOURCE_NAME}, null) != null
      ]
    ]
  ])
}}

resource "meraki_networks_{RESOURCE_NAME}" "net_{RESOURCE_NAME}" {{
  for_each   = {{ for data in local.networks_{RESOURCE_NAME} : data.network_id => data.data }}
  network_id = each.key
  {values_render}
}}
"""

def generate_template(resource, values):
    values_render = ""
    for v in values:
        values_render += "  {v} = try(each.value.{v}, local.defaults.meraki.networks.{r}.{v}, null)\n".format(v=v, r=resource)
    return template.format(RESOURCE_NAME=resource, VALUES=values, values_render=values_render.strip())

with open("/Users/maparafi/test_meraki/schema.json") as f:
    contents = f.read()

j = json.loads(contents)

for k, v in j["provider_schemas"]["registry.terraform.io/cisco-open/meraki"]["resource_schemas"].items():
    if k.startswith("meraki_networks"):
        print(generate_template(k[16:], [kk for kk, vv in v["block"]["attributes"].items() if kk != "network_id"]))
