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
 
Copyright 2015 VMware, Inc.  All rights reserved.

SPDX-License-Identifier: Apache-2.0 OR GPL-3.0-only

[This code is Dual Licensed Apache-2.0 or GPLv3](LICENSE)
