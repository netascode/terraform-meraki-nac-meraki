#!/usr/bin/env python3

###

import json, re, sys, copy

def to_snake_case(text):
    text = re.sub(r'(?<!^)(?=[A-Z])', '_', text).lower()
    return text.replace("/", "_")

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
            ids += "{spaces}{resource_key} = meraki_network_{val}.net_{val}[\"${{domain.name}}/${{organization.name}}/${{network.name}}/{access_path}\"].{resource_key}\n".format(spaces=" "*(depth+2)*2, resource_key=resource_key, val="_".join([to_snake_case(i) for i in id_path]), access_path="/".join([to_snake_case(i)+"/${"+to_snake_case(i)[:-1]+".name}" for i in id_path]))
            items_from_networks += [p]
        return """
    {spaces}network_id = meraki_network.network["${{domain.name}}/${{organization.name}}/${{network.name}}"].id\n{ids}
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

resource "meraki_{RESOURCE_NAME}" "net_{RESOURCE_NAME}" {{
  for_each   = {{ for i, v in local.networks_{RESOURCE_NAME} : i => v }}
  network_id = each.value.network_id
{keys_render}
{values_render}
}}
"""

def generate_template(resource, values, content, ret_resource_keys):
    values_render = ""
    for v in values:
        v_terra = "_".join([to_snake_case(x) for x in v])
        v_dots = ".".join([to_snake_case(x) for x in v])
        if v_terra not in ret_resource_keys:
            values_render += "  {v_terra} = try(each.value.data.{v_dots}, local.defaults.meraki.networks.{r}.{v_dots}, null)\n".format(v_terra=v_terra, v_dots=v_dots, r=resource)
    keys_render = ""
    for k in ret_resource_keys:
        keys_render += "  {k} = each.value.{k}\n".format(k=k)
    return template.format(RESOURCE_NAME=resource, VALUES=values, values_render=values_render, content=content, keys_render=keys_render)

with open("/Users/maparafi/openapi/openapi/spec3.json") as f:
    j = json.loads(f.read())
    
URL = sys.argv[1]

res = {}
spec_url = ""

def fields(d, p):
    ret = []
    if d["type"] == "object":
        if "properties" not in d:
            # ret.append(copy.deepcopy(p))
            return ret
        for prop, propValue in d["properties"].items():
           propRet = fields(propValue, p+[prop])
           ret += propRet
    else:
        ret.append(copy.deepcopy(p))
    return ret

METHOD = "put"

for k, v in j["paths"].items():
    path = [to_snake_case(x) for x in k.split("/") if not x.startswith("{")][1:]
    if URL == "_".join(path) and METHOD in v:
        res = v
        spec_url = k

path = [x.split("}")[-1].strip("/").replace("/", "_") for x in spec_url.split("{")]
res_name = "_".join([to_snake_case(x) for x in spec_url.split("/") if not x.startswith("{")][1:])
path = ["domains", "organizations"] + path
path_from_networks = path[3:-1]
print(path_from_networks)
res_fields = fields(res[METHOD]["requestBody"]["content"]["application/json"]["schema"], [])
content, ret_resource_keys = generate_loop(path, 0, "local.meraki", path_from_networks)
print(generate_template(res_name, res_fields, content, ret_resource_keys))
