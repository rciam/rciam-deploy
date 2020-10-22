# Ansible Playbooks for deploying AAI for Research and Collaboration

A collection of playbooks for setting up a proxy-based Authentication & Authorisation Infrastracture (AAI) for Research and Collaboration. 

Currently, the master playbook (`site.yml`) supports setting up the following components:
* IdP/SP proxy based on one or more instances of [SimpleSAMLphp](https://simplesamlphp.org) (see `authservers.yml` playook)
* cluster of [memcached](https://memcached.org/) servers for caching user sessions in a distributed way to enable load-balancing and fail-over (see `cacheservers.yml` playbook)
* reverse proxy based on [nginx](https://nginx.org/) to support HTTP request load balancing among multiple SimpleSAMLphp web front-ends that use the back-end matrix of memcached servers (see `webproxyservers.yml` playbook)

## Managed Node Requirements

On the managed nodes, you need a way to communicate, normally ssh, which by default uses sftp. If this is not available you can switch to scp in `ansible.cfg`. You will also need the following packages:

* `python` (version 2.4 or later)
* `python-simplejson` (only if you are running less than Python 2.5)
* `sudo` (unless the default ansible `become_method` is overriden)

## Control Machine Requirements

On the control machine, you need a recent version of Ansible and some necessary Python libraries. We recommend installing Ansible via “pip”, which is the Python package manager (though other options are also available).
You can easily install all the prerequisites with the following two commands:

    pip install -r requirements.txt
    ansible-galaxy install ipr-cnrs.nftables
    🍺


**Tested Ansible version:** `2.9.11`

## Configuration

* Set the hostnames/IP addresses of managed nodes in `inventories/ENV/inventory`, for each target environment, e.g. `testing`, `staging`, `production`, etc.
* DO change the default SimpleSAMLphp admin password in `inventories/ENV/group_vars/authservers`
* Modify variables in `inventories/ENV/group_vars/authservers` to generate the metadata of the IdP/SP proxy 

## Executing the Playbook

Assuming root access to the target machines, simple run the following command to execute the master playbook using the inventory file at the default location (see `ansible.cfg`): 

    ansible-playbook -v site.yml

# License

Licensed under the Apache 2.0 license, for details see `LICENSE`.
