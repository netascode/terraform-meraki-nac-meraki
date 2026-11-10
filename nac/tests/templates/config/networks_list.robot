*** Settings ***
Documentation   Verify Network Configuration
Default Tags    meraki   config   networks_list
Resource        ../meraki_common.resource

*** Test Cases ***
{% for domain in meraki.domains | default([]) %}
{% for organization in domain.organizations | default([]) %}
{% if organization.networks is defined %}

Get Networks {{ organization.name }}
    ${org_id}=   Meraki Get Organization Id   {{ organization.name }}
    ${r}=   Meraki Get   /organizations/${org_id}/networks
    Set Suite Variable   $r   ${r}

{% for network in organization.networks | default([]) %}
{% set product_types = network.product_types | default(defaults.meraki.domains.organizations.networks.product_types) | default([]) | unique | list %}
{% set tags = network.tags | default(defaults.meraki.domains.organizations.networks.tags) | default([]) | unique | list %}
Verify Network {{ network.name }} Organization {{ organization.name }}
    ${n}=   Set Variable   [?name=='{{ network.name }}'] | [0]
    Should Be Equal Value Json String   ${r}   ${n}.name   {{ network.name }}
{% if network.managed | default(defaults.meraki.domains.organizations.networks.managed) | default(true) %}
    Should Be Equal Value Json List   ${r}   ${n}.productTypes   {{ product_types or "" }}
    Should Be Equal Value Json List   ${r}   ${n}.tags   {{ tags or "" }}
    Should Be Equal Value Json String   ${r}   ${n}.timeZone   {{ network.time_zone | default(defaults.meraki.domains.organizations.networks.time_zone) | default() }}
    Should Be Equal Value Json String   ${r}   ${n}.notes   {{ network.notes | default(defaults.meraki.domains.organizations.networks.notes) | default() }}
{% endif %}

{% endfor %}
{% endif %}
{% endfor %}
{% endfor %}
