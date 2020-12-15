Federation registry agent Role
===============================

Federation registry agent (`fedreg-agent`) role deploy and configure the deployers from [rciam-federation-registry-agent](https://github.com/rciam/rciam-federation-registry-agent/tree/devel).


Requirements
------------

* Ansible `2.9.11`.


Selecting the deployer you want.
----------------------------
This role supports the installation of all deployers from [rciam-federation-registry-agent](https://github.com/rciam/rciam-federation-registry-agent/tree/devel). \
It is very easy for you to decide which one to install and activate to target system, with the following variables:
* `enable_ssp` : `yes` or `no`
* `enable_mitre` : `yes` or `no`



Example Playbook
----------------

Including an example of how to use your role (for instance, with variables
passed in as parameters) is always nice for users too:

```yaml
---

# This playbook deploy the Rciam federation registry agent.


- name: Rciam federation registry agent
  hosts: agents
  roles:
    - { role: fedreg-agent,    tags: agent }
```


### How to run

An example of how to run your playbook :

```
ansible-playbook -i rciam-deploy-inv/eosc-portal-demo/federation_inventory federation-registry-agent.yml --vault-password-file=../your/vault --tags "config, service" -vv --list-hosts --list-tasks
```
or
```
ansible-playbook -i rciam-deploy-inv/egi-devel/hosts.ini federation-registry-agent.yml --vault-password-file=../your/vault
```


License
-------

Apache License, Version 2.0



