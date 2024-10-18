# Rocky 8 CIS

VMware LPS CIS Gudieline -- https://onevmw-my.sharepoint.com/:x:/r/personal/maniyarm_vmware_com/_layouts/15/Doc.aspx?sourcedoc=%7B4A5487AC-CF68-4011-8A6F-5C9CC4FE7D14%7D&file=CIS_Rocky_Linux_8_Benchmark_v1.0.0.xlsx&action=default&mobileredirect=true 

Vmware LPS Template confluence page -- https://confluence.eng.vmware.com/display/LPSTEAM/Linux+OS+Templates

Configure RHEL/Rocky/AlmaLinux machine to be [CIS](https://www.cisecurity.org/cis-benchmarks/) compliant

Based on [CIS Rocky/RedHat Enterprise Linux 8 Benchmark v2.0.0 - 02-23-2022 ](https://www.cisecurity.org/cis-benchmarks/)


### Running level1 or level2 only

While the defaults/main.yml has the options this is used for auditing purposes.
In order to run level(1|2)-server level(1|2)-workstation  This is carried out via tags.

e.g.

``` shell
ansible-playbook -l test-server -i test_inv site.yml -t level1-server

```

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************************************************
rocky8                     : ok=259  changed=114  unreachable=0    failed=1    skipped=233  rescued=0    ignored=0



## Auditing (new)

This can be turned on or off within the defaults/main.yml file with the variable rhel8cis_run_audit. The value is false by default, please refer to the wiki for more details.

This is a much quicker, very lightweight, checking (where possible) config compliance and live/running settings.

A new form of auditing has been developed, by using a small (12MB) go binary called [goss](https://github.com/aelsabbahy/goss) along with the relevant configurations to check. Without the need for infrastructure or other tooling.
This audit will not only check the config has the correct setting but aims to capture if it is running with that configuration also trying to remove [false positives](https://www.mindpointgroup.com/blog/is-compliance-scanning-still-relevant/) in the process.

## General

- Basic knowledge of Ansible, below are some links to the Ansible documentation to help get started if you are unfamiliar with Ansible
  - [Main Ansible documentation page](https://docs.ansible.com)
  - [Ansible Getting Started](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html)
  - [Tower User Guide](https://docs.ansible.com/ansible-tower/latest/html/userguide/index.html)
  - [Ansible Community Info](https://docs.ansible.com/ansible/latest/community/index.html)
- Functioning Ansible and/or Tower Installed, configured, and running. This includes all of the base Ansible/Tower configurations, needed packages installed, and infrastructure setup.
- Please read through the tasks in this role to gain an understanding of what each control is doing. Some of the tasks are disruptive and can have unintended consiquences in a live production system. Also familiarize yourself with the variables in the defaults/main.yml file or the [Main Variables Wiki Page](https://github.com/ansible-lockdown/RHEL8-CIS/wiki/Main-Variables).

## Dependencies

- Python3
- Ansible 2.9+
- python-def (should be included in RHEL 8)
- libselinux-python

- devel branch
  - Staging area for bug fixes PRs and new benchmarks.

## Pipeline Testing

uses:

- ansible-core 2.12
- ansible collections - pulls in the latest version based on requirements file
- runs the audit using the devel branch
- This is an automated test that occurs on pull requests into devel


