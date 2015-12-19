# ansible-role-vra

Ansible playbook to automate installing and maintaining VMware vRA.

## Requirements

A vCenter server into which to deploy vRA is a fundamental requirement of this role.
The role also assumes ovftool is on the path and available to the ansible play.

Currently VRA Appliance is deployed into ESX cluster using vCenter parameters
provided in this role. In reality, one could try to install vRA into a ESXi host
directly, but that would largely be a bad idea, if not well away from best
practices.

The installation configures vRA pursuant to parameters available via the VAMi console
of the vRA appliance. This is always via REST API and XML. Single deployment settings
are Host, SSL, SSO and licensing. Distributed deployment settings are postgres Db,
messaging and cluster settings.

## Role Variables

TODO: update (there are many).

# License and Copyright
 
Copyright 2015 VMware, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

