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

  validation {
    condition     = length(var.yaml_directories) != 0 || length(var.yaml_files) != 0 || length(keys(var.model)) != 0
    error_message = "Either `yaml_directories`,`yaml_files` or a non-empty `model` value must be provided."
  }
}

variable "write_default_values_file" {
  description = "Write all default values to a YAML file. Value is a path pointing to the file to be created."
  type        = string
  default     = ""
}

variable "write_model_file" {
  description = "Write the merged data model with all network and device templates applied to a single YAML file, e.g. for validation, testing and troubleshooting. `!env` tags are written as is, without their environment variable values. Value is a path relative to the root module. Set to an empty string to disable."
  type        = string
  default     = "model.yaml"
}
