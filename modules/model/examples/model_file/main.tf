module "model" {
  source  = "netascode/nac-meraki/meraki//modules/model"
  version = ">= 0.3.0"

  yaml_directories = ["data/"]
  write_model_file = "model.yaml"
}