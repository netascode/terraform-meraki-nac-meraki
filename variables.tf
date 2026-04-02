variable "yaml_directories" {
  description = "List of paths to YAML directories."
  type        = list(string)
  default     = []
}

variable "yaml_files" {
  description = "List of paths to YAML files."
  type        = list(string)
  default     = []
}

variable "model" {
  description = "As an alternative to YAML files, a native Terraform data structure can be provided as well."
  type        = map(any)
  default     = {}
}

variable "write_default_values_file" {
  description = "Write all default values to a YAML file. Value is a path pointing to the file to be created."
  type        = string
  default     = ""
}

variable "write_model_file" {
  type        = string
  description = "Write the full model including all resolved templates to a single YAML file. Value is a path pointing to the file to be created."
  default     = ""
}

variable "meraki_api_key" {
  description = "Meraki Dashboard API key. Required for SLA policy name-to-ID resolution. Set via TF_VAR_meraki_api_key or pass directly."
  type        = string
  sensitive   = true
  default     = ""
}
