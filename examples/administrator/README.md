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

#### `organization.yaml`

```yaml
meraki:
  organizations:
    - name: MyOrg1
      administrators:
        - name: Admin1
          email: admin@cisco.com
          networks:
            - name: MyNet1
```

#### `main.tf`

```hcl
module "meraki" {
  source  = "netascode/nac-meraki/meraki"
  version = ">= 0.1.0"

  yaml_files = ["organization.yaml"]
}
```
<!-- END_TF_DOCS -->