# ansible-role-elasticsearch

Ansible playbook to automate installing and maintaining VMware VRA.

## Requirements
Able to deploy VRA Appliance usng ovf tool and vcenter. Currently VRA Appliance is deployed into ESX cluster using vcenter parameters. Do we aslo need to support deployment of the VRA appliance into the host directly? 
Able to configure VRA settings  found in VAMi console  of vra appliance using REST Api and XML. Single deployment settings are Host, SSL, SSO and licensing. Distributed deployment settings are postgres Db, messaging and cluster
## Role Variables

... forthcoming

## playbook invoking the role
ansible/playbooks/supersddc/site_vra.yml
## tasks
vra_ovadeploy.yml - used for deploying an appliance
vra_poweron.yml - used for powering on the appliance. ova deploy has an option of creating the appliance without powering on
vra_delete.yml - used for deleting an appliance. Mostly used for development purposes. can be removed in the production.
vra_postgresdb_configure.yml - used for configuring the postgres db
vra_messaging_configure.yml - used for configuring the messaging of vra
vra_cluster_configure.yml - used for configuring the clusters for vra( Not being invoked currently from the front end as it is not working as expected)
vra_configure.yml(??) - used for configuring the host name, SSL, SSO and licensing properties of vra. Will be added by Vamsi. A hook has been provided in the front end. 
Currently all these tasks are invoked from the front end  through tasks/main.yml based on ohe tags specified in the base.yml.j2 of supersddc gui 
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

