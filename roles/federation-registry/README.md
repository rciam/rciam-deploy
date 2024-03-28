### Description

This role deploys the [Federation Registry](https://github.com/rciam/rciam-federation-registry) project.

### Task Analysis
  **configure-environment** :
- Installs necessary packages
- Set's up github ssh key to clone repo (Can do it manually beforehand or Change to Https)

**postgres** : (To run this tast include the postgres tag when running the playbook)
- Runs initialization script that creates the necessary SQL tables
- Runs initialization script for tenants

**configure-ams:**
   - Creates Deployment Result Topic and Push Subscription in the Ams Messaging Service

**deploy**:
- Clones Repo
- Runs Express Backend instance with pm2 serving at http://localhost:5000
- Builds React Frontend
- Runs Ams Agent node.js agent with pm2
- Activates Push Subscription for Deployment Result Topic

### Configuring the Inventory
&NewLine;

 **main.yml:**
- Ams Configuration (federation_registry_ams):
    - Set host of the AMS instance
        - A preconfigured project and an admin user is needed. Set project name and admin_token accordingly
        - agent_key is the Authorisation Key used for the communitation of the Ams Agent and the Federation Registry Backend
    - Folder Paths:
      - Set deployment Path for each component
    - Git (federation_registry_git):
      - Set url for ssh or https
    - Setup Database:
      - Setup information for local or remote database

 **config.json:** Configure the file based on the tenant information and instance requirements

 **hosts.ini:**
- federation-registry: Federation Registry Backend and Frontend gets deployed for hosts in this group
 - ams-agent: Ams Agent Instance is deployed for hosts in this group (maximun of 1 instance)
