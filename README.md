# Ansible Playbooks for deploying Identity Access Management for Research Communities (RCIAM)

A collection of Ansible playbooks and roles for deploying RCIAM to enable secure access to OpenID Connect and SAML based services. The RCIAM deployment typically comprises the following components:

* Identity Broker (auth proxy) based on one or more instances of Keycloak (see `keycloakservers.yml` playbook)
* Database backend based on PostgreSQL (see `dbservers.yml` playbook for setting up a master / hot standby PostgreSQL deployment)
* Reverse proxy based on nginx to support HTTP request load balancing among the Keycloak nodes that use the back-end Postgresql DB (see `webproxyservers.yml` playbook)

## Managed Node Requirements

On the managed nodes, you need a way to communicate, normally ssh, which by default uses sftp. If this is not available you can switch to scp in `ansible.cfg`. You will also need:

* Python 2 (version 2.6 or later) or Python 3 (version 3.5 or later)
* `sudo` (unless the default ansible `become_method` is overriden)

## Control Machine Requirements

On the control machine, you need a recent version of Ansible and some necessary Python libraries. We recommend installing Ansible via “pip”, which is the Python package manager (though other options are also available).
You can easily install all the prerequisites with the following two commands:

    pip install -r requirements.txt
    ansible-galaxy install ipr-cnrs.nftables
    ansible-galaxy install arillso.logrotate
    🍺

**Tested Ansible version:** `2.10.7`

## Configuration

* Set the hostnames/IP addresses of managed nodes in `inventories/ENV/hosts.ini`, for each target environment, e.g. `testing`, `staging`, `production`, etc.
* Modify variables in `inventories/ENV/group_vars/<HOST_GROUP>`

## Executing the Playbook

Assuming root access to the target machines, simple run the following command to execute the playbook using the specified inventory file:

```sh
ansible-playbook -v -i inventories/ENV/hosts.ini keycloakservers.yml
```

## License

Licensed under the Apache 2.0 license, for details see `LICENSE`.
