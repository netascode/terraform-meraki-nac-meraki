from nac_validate import RuleBase, Violation


class Rule(RuleBase):
    id = "302"
    description = "Verify group policy references point to defined group policies"
    severity = "HIGH"

    title = "UNDEFINED GROUP POLICY"
    affected_items_label = "References to undefined group policies"
    explanation = """\
Appliance VLANs, identity PSKs and SSID device type policies reference a
group policy of their network by name. A name that matches no group policy
of the network is silently ignored: the deployment succeeds, but no group
policy is applied."""
    recommendation = """\
Define the group policy in the same network, or fix the name:

  meraki:
    domains:
      - name: EMEA
        organizations:
          - name: Org1
            networks:
              - name: Branch1
                group_policies:
                  - name: Guests
                appliance:
                  vlans:
                    - vlan_id: 20
                      name: Guest
                      group_policy_name: Guests"""

    @staticmethod
    def _references(network):
        """Yield (relative path, group policy name) of all references."""
        for vlan in (network.get("appliance") or {}).get("vlans") or []:
            if vlan.get("group_policy_name") is not None:
                yield (
                    f"appliance.vlans[vlan_id={vlan.get('vlan_id')}].group_policy_name",
                    vlan["group_policy_name"],
                )
        for ssid in (network.get("wireless") or {}).get("ssids") or []:
            ssid_path = f"wireless.ssids[name={ssid.get('name')}]"
            for psk in ssid.get("identity_psks") or []:
                if psk.get("group_policy_name") is not None:
                    yield (
                        f"{ssid_path}.identity_psks[name={psk.get('name')}].group_policy_name",
                        psk["group_policy_name"],
                    )
            device_type = ssid.get("device_type_group_policies") or {}
            for policy in device_type.get("device_type_policies") or []:
                if policy.get("group_policy_name") is not None:
                    yield (
                        f"{ssid_path}.device_type_group_policies"
                        f".device_type_policies[device_type={policy.get('device_type')}]"
                        ".group_policy_name",
                        policy["group_policy_name"],
                    )

    @staticmethod
    def _group_policies(configuration):
        return {
            str(policy["name"])
            for policy in configuration.get("group_policies") or []
            if policy.get("name") is not None
        }

    @classmethod
    def match(cls, inventory):
        meraki = inventory.get("meraki") or {}
        # Rendering applies the templates and drops the `templates` section,
        # but keeps each network's `templates` list: without the section,
        # the networks are already complete.
        rendered = "templates" not in meraki
        model_templates = {
            template.get("name"): template.get("configuration") or {}
            for template in (meraki.get("templates") or {}).get("networks") or []
            if template.get("type") == "model"
        }

        violations = []
        reported = set()
        for domain in meraki.get("domains") or []:
            for organization in domain.get("organizations") or []:
                for network in organization.get("networks") or []:
                    context = {
                        "domain": domain.get("name"),
                        "organization": organization.get("name"),
                        "network": network.get("name"),
                    }
                    network_path = (
                        f"meraki.domains[name={context['domain']}]"
                        f".organizations[name={context['organization']}]"
                        f".networks[name={context['network']}]"
                    )
                    template_names = [] if rendered else network.get("templates") or []
                    # File templates are only known once rendered
                    if any(name not in model_templates for name in template_names):
                        continue

                    # The network and its model templates are merged when rendered,
                    # so a reference may point to a group policy of either
                    sources = [(network_path, {}, network)] + [
                        (
                            f"meraki.templates.networks[name={name}].configuration",
                            {"template": name},
                            model_templates[name],
                        )
                        for name in template_names
                    ]
                    defined = set()
                    for _, _, configuration in sources:
                        defined |= cls._group_policies(configuration)
                    # Template variables are resolved when the templates are rendered
                    if any("${" in name for name in defined):
                        continue

                    for path, extra, configuration in sources:
                        for relative_path, name in cls._references(configuration):
                            name = str(name)
                            if name in defined or "${" in name:
                                continue
                            key = (f"{path}.{relative_path}", name)
                            if extra and key in reported:
                                continue
                            reported.add(key)
                            violations.append(
                                Violation(
                                    message=f"group policy '{name}' is not defined in the network",
                                    path=key[0],
                                    details={
                                        **context,
                                        **extra,
                                        "group_policy": name,
                                    },
                                )
                            )
        return violations
