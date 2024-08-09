#!/usr/bin/env python3

###

import json, re, sys


with open("/Users/maparafi/test_meraki/schema.json") as f:
    contents = f.read()

j = json.loads(contents)

with open("/Users/maparafi/test_meraki/api_structure.json") as f:
    api_structure = json.loads(f.read())

def to_snake_case(text):
    text = re.sub(r'(?<!^)(?=[A-Z])', '_', text).lower()
    return text.replace("/", "_")

def parent_path_to_provider_name(parent_path):
    parent_path = list(filter(lambda x: x != "", parent_path))
    return "meraki_" + "_".join(list(map(to_snake_case, parent_path)))

def find_path(provider_name, api_node, parent_path):
    if parent_path_to_provider_name(parent_path) == provider_name:
        if "" in api_node:
            return parent_path + [""]
        return parent_path
    for k, v in api_node.items():
        ret = find_path(provider_name, v, parent_path+[k])
        if ret is not None:
            return ret

resource_key_mapping = {
    "routing_interface_id": "interface_id",
    "switch_access_policie_id": "access_policy_number",
    "switch_routing_multicast_rendezvous_point_id": "rendezvous_point_id",
    "routing_static_route_id": "static_route_id",
}

def generate_loop(path, depth, prev_var, path_from_networks):
    if len(path) == 1:
        ids = ""
        items_from_networks = []
        ret_resource_keys = []
        if path[0] == "":
            path_from_networks = path_from_networks[:-1]
        for p in path_from_networks:
            id_path = items_from_networks + [p]
            resource_key = to_snake_case(p)[:-1]+"_id"
            resource_key = resource_key_mapping.get(resource_key, resource_key)
            ret_resource_keys.append(resource_key)
            ids += "{spaces}{resource_key} = meraki_networks_{val}.net_{val}[\"${{domain.name}}/${{organization.name}}/${{network.name}}/{access_path}\"].{resource_key}\n".format(spaces=" "*(depth+2)*2, resource_key=resource_key, val="_".join([to_snake_case(i) for i in id_path]), access_path="/".join([to_snake_case(i)+"/${"+to_snake_case(i)[:-1]+".name}" for i in id_path]))
            items_from_networks += [p]
        return """
    {spaces}network_id = meraki_networks.networks["${{domain.name}}/${{organization.name}}/${{network.name}}"].id\n{ids}
    {spaces}data = try({prev_var}, null)""".format(spaces=" "*depth*2, prev_var=prev_var if path[0] == "" else prev_var+"."+to_snake_case(path[0]), ids=ids[:-1]), ret_resource_keys

    step = path[0]
    local_var = to_snake_case(step[:-1] if step[-1] == "s" else step)
    if len(path) == 2:
        lbrace = "{"
        rbrace = "}"
    else:
        lbrace = "["
        rbrace = "]"
    content, ret_resource_keys = generate_loop(path[1:], depth+1, local_var, path_from_networks)
    return """
    {spaces}for {local_var} in try({prev_var}.{step}, []) : {lbrace}{spaces}{content}
    {spaces}{rbrace} if try({prev_var}.{step}, null) != null""".format(local_var=local_var, prev_var=prev_var, step=to_snake_case(step), content=content, spaces=" "*depth*2, lbrace=lbrace, rbrace=rbrace), ret_resource_keys

template = """

### marcin generated
### resource name: {RESOURCE_NAME}
### values: {VALUES}

locals {{
  networks_{RESOURCE_NAME} = flatten([
    {content}
  ])
}}

resource "meraki_networks_{RESOURCE_NAME}" "net_{RESOURCE_NAME}" {{
  for_each   = {{ for i, v in local.networks_{RESOURCE_NAME} : i => v }}
  network_id = each.value.network_id
{keys_render}
{values_render}
}}
"""

read_only_values = {
    "meraki_networks_switch_access_policies": {"radius_accounting_servers_response", "radius_servers_response", "counts"},
    "meraki_networks_switch_link_aggregations": {"id"},
    "meraki_networks_switch_port_schedules": {"id"},
    "meraki_networks_switch_qos_rules_order": {"id"},
    "meraki_networks_switch_routing_multicast_rendezvous_points": {"interface_name", "serial"},
    "meraki_networks_switch_stacks": {"id"},
    "meraki_networks_switch_stp": {"stp_bridge_priority_response"},
    "meraki_networks_switch_stacks_routing_interfaces": {"ospf_v3"},
}

def generate_template(resource, values, content, ret_resource_keys):
    values_render = ""
    for v in values:
        if v not in ret_resource_keys and v not in read_only_values.get("meraki_networks_"+resource, {}):
            values_render += "  {v} = try(each.value.data.{v}, local.defaults.meraki.networks.{r}.{v}, null)\n".format(v=v, r=resource)
    keys_render = ""
    for k in ret_resource_keys:
        keys_render += "  {k} = each.value.{k}\n".format(k=k)
    return template.format(RESOURCE_NAME=resource, VALUES=values, values_render=values_render, content=content, keys_render=keys_render)

skipped_resources = [
    "meraki_networks_switch_stacks_add",
    "meraki_networks_switch_stacks_remove",
]

for k, v in j["provider_schemas"]["registry.terraform.io/cisco-open/meraki"]["resource_schemas"].items():
    if k in skipped_resources:
        continue
    if k.startswith("meraki_networks_switch"):  # use this line to filter the output
        path = find_path(k, api_structure, [])
        if path is None:
            print("# no path for {}", k)
            continue
        path = ["domains", "organizations"] + path
        path_from_networks = path[3:-1]
        content, ret_resource_keys = generate_loop(path, 0, "local.meraki", path_from_networks)
        print(generate_template(k[16:], [kk for kk, vv in v["block"]["attributes"].items() if kk != "network_id"], content, ret_resource_keys))
