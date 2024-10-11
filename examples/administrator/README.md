<!-- BEGIN_TF_DOCS -->
# Meraki Organization Administrator Example

Set environment variables with the Meraki Dashboard API key:

```bash
export MERAKI_DASHBOARD_API_KEY=ABC123
```

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

#### `organizations_admins.yaml`

```yaml
meraki:
  domains:
    - name: EMEA
      administrator:
        name: Dev CX Provider Admin
      organizations:
        - name: Dev
          admins:
            - name: Dev CX Provider Admin
              email: devadmincxprovider@foobar.com
              authentication_method: Email
              org_access: full
```

#### `main.tf`

```hcl
module "meraki" {
  source  = "netascode/nac-meraki/meraki"
  version = ">= 0.1.0"

  yaml_files = ["organizations_admins.yaml"]
}
```
<!-- END_TF_DOCS -->