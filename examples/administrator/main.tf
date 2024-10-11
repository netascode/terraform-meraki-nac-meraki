module "meraki" {
  source  = "netascode/nac-meraki/meraki"
  version = ">= 0.1.0"

  yaml_files = ["organizations_admins.yaml"]
}
