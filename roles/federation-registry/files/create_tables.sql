DROP TABLE IF EXISTS user_edu_person_entitlement,tokens,user_info, service_petition_contacts, service_petition_oidc_grant_types,service_boolean,service_petition_boolean,service_saml_attributes,service_petition_saml_attributes, service_petition_oidc_redirect_uris,service_petition_oidc_post_logout_redirect_uris, service_petition_oidc_scopes,
service_petition_details_oidc,service_petition_details_saml, service_petition_details, service_oidc_scopes,service_contacts,service_oidc_grant_types,service_oidc_redirect_uris,service_oidc_post_logout_redirect_uris,service_details_oidc,
service_details_saml,service_details,service_state,user_roles,role_actions,role_entitlements,groups,invitations,group_subs,tenant_deployer_agents,banner_alerts,deployment_tasks,service_errors,organizations,service_tags,tenants;

create table tokens (
  token VARCHAR(2048),
  id_token VARCHAR(2048),
  code VARCHAR(1054) PRIMARY KEY
);


create table tenants (
  name VARCHAR(256) PRIMARY KEY,
  client_id VARCHAR(256),
  client_secret VARCHAR(1054),
  issuer_url VARCHAR(256),
  base_url VARCHAR(256) DEFAULT NULL
);


create table user_info (
  id SERIAL PRIMARY KEY,
  sub VARCHAR(256),
  preferred_username VARCHAR(256),
  name VARCHAR(256),
  given_name VARCHAR(256),
  family_name VARCHAR(256),
  email VARCHAR(256),
  role_id bigint,
  tenant VARCHAR(256),
  FOREIGN KEY (tenant) REFERENCES tenants(name)
);


create table user_roles (
  id SERIAL PRIMARY KEY,
  role_name VARCHAR(256),
  tenant VARCHAR(256),
  FOREIGN KEY (tenant) REFERENCES tenants(name)
);


create table role_actions (
  role_id bigint,
  action VARCHAR(256),
  PRIMARY KEY (role_id,action),
  FOREIGN KEY (role_id) REFERENCES user_roles(id)
);

create table role_entitlements (
  role_id bigint,
  entitlement VARCHAR(256),
  PRIMARY KEY (role_id,entitlement),
  FOREIGN KEY (role_id) REFERENCES user_roles(id)
);


create table groups (
  id SERIAL PRIMARY KEY,
  group_name VARCHAR(256)
);


create table invitations (
  id SERIAL PRIMARY KEY,
  code VARCHAR(1054),
  email VARCHAR(256),
  group_id INTEGER,
  sub VARCHAR(256) DEFAULT NULL,
  invited_by VARCHAR(256),
  date timestamp without time zone DEFAULT NULL,
  group_manager BOOLEAN,
  tenant VARCHAR(256),
  FOREIGN KEY (tenant) REFERENCES tenants(name),
  FOREIGN KEY (group_id) REFERENCES groups(id)
);


create table group_subs (
  group_id INTEGER,
  sub VARCHAR(256),
  group_manager BOOLEAN,
  PRIMARY KEY (group_id,sub),
  FOREIGN KEY (group_id) REFERENCES groups(id)
);


create table user_edu_person_entitlement (
  user_id bigint,
  edu_person_entitlement VARCHAR(256),
  PRIMARY KEY (user_id,edu_person_entitlement),
  FOREIGN KEY (user_id) REFERENCES user_info(id)
);


create table organizations (
  organization_id SERIAL PRIMARY KEY,
  name VARCHAR(256),
  url VARCHAR(256),
  active BOOLEAN DEFAULT NULL,
  ror_id VARCHAR(256) DEFAULT NULL
);


create table service_details (
  id SERIAL PRIMARY KEY,
  external_id INTEGER DEFAULT NULL,
  tenant VARCHAR(256),
  website_url VARCHAR(256) DEFAULT NULL,
  service_name  VARCHAR(256),
  group_id INTEGER,
  service_description VARCHAR(1024),
  logo_uri VARCHAR(2048),
  policy_uri VARCHAR(2048),
  integration_environment VARCHAR(256),
  country VARCHAR(256),
  requester VARCHAR(256),
  protocol VARCHAR(256),
  aup_uri VARCHAR(256) DEFAULT NULL,
  deleted BOOLEAN DEFAULT FALSE,
  organization_id INTEGER,
  FOREIGN KEY (organization_id) REFERENCES organizations(organization_id),
  FOREIGN KEY (tenant) REFERENCES tenants(name)
);


create table service_details_oidc (
  id INTEGER PRIMARY KEY,
  client_id VARCHAR(256),
  allow_introspection BOOLEAN,
  code_challenge_method VARCHAR(256),
  device_code_validity_seconds bigint,
  access_token_validity_seconds bigint,
  refresh_token_validity_seconds bigint,
  client_secret VARCHAR(2048),
  reuse_refresh_token BOOLEAN,
  clear_access_tokens_on_refresh BOOLEAN,
  id_token_timeout_seconds bigint,
  token_endpoint_auth_method VARCHAR(256),
  token_endpoint_auth_signing_alg VARCHAR(256),
  jwks VARCHAR(2048),
  jwks_uri VARCHAR(256),
  application_type VARCHAR(256),
  FOREIGN KEY (id) REFERENCES service_details(id) ON DELETE CASCADE
);


create table service_state (
  id bigint PRIMARY KEY,
  state VARCHAR(256),
  deployment_type VARCHAR(256) DEFAULT NULL,
  outdated BOOLEAN DEFAULT FALSE,
  last_edited timestamp without time zone DEFAULT NULL,
  created_at timestamp without time zone DEFAULT NULL,
  FOREIGN KEY (id) REFERENCES service_details(id) ON DELETE CASCADE
);


create table service_errors (
  service_id bigint,
  date timestamp without time zone DEFAULT NULL,
  error_code bigint,
  error_description VARCHAR(2048),
  archived BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (service_id,date),
  FOREIGN KEY (service_id) REFERENCES service_details(id) ON DELETE CASCADE
);


create table service_details_saml (
  id bigint PRIMARY KEY,
  entity_id VARCHAR(256),
  metadata_url VARCHAR(256),
  FOREIGN KEY (id) REFERENCES service_details(id) ON DELETE CASCADE
);


create table service_contacts (
  id SERIAL PRIMARY KEY,
  owner_id bigint,
  value VARCHAR(256),
  type VARCHAR(256),
  FOREIGN KEY (owner_id) REFERENCES service_details(id) ON DELETE CASCADE
);


create table service_oidc_grant_types (
  id SERIAL PRIMARY KEY,
  owner_id bigint,
  value VARCHAR(256),
  FOREIGN KEY (owner_id) REFERENCES service_details(id) ON DELETE CASCADE
);


create table service_oidc_redirect_uris (
  id SERIAL PRIMARY KEY,
  owner_id bigint,
  value VARCHAR(256),
  FOREIGN KEY (owner_id) REFERENCES service_details(id) ON DELETE CASCADE
);

create table service_oidc_post_logout_redirect_uris (
  id SERIAL PRIMARY KEY,
  owner_id bigint,
  value VARCHAR(256),
  FOREIGN KEY (owner_id) REFERENCES service_details(id) ON DELETE CASCADE
);


create table service_oidc_scopes (
  id SERIAL PRIMARY KEY,
  owner_id bigint,
  value VARCHAR(256),
  FOREIGN KEY (owner_id) REFERENCES service_details(id) ON DELETE CASCADE
);

create table service_saml_attributes (
  owner_id bigint,
  name VARCHAR(512),
  friendly_name VARCHAR(512),
  required BOOLEAN DEFAULT TRUE,
  name_format VARCHAR(512) DEFAULT 'urn:oasis:names:tc:SAML:2.0:attrname-format:uri',
  FOREIGN KEY (owner_id) REFERENCES service_details(id) ON DELETE CASCADE
);



create table service_petition_details (
  id SERIAL PRIMARY KEY,
  service_id INTEGER DEFAULT NULL,
  tenant VARCHAR(256),
  website_url VARCHAR(256) DEFAULT NULL,
  service_description VARCHAR(1024),
  service_name  VARCHAR(256),
  logo_uri VARCHAR(2048),
  policy_uri VARCHAR(2048),
  country VARCHAR(256),
  integration_environment VARCHAR(256),
  type VARCHAR(256) DEFAULT 'create',
  status VARCHAR(256) DEFAULT 'pending',
  comment VARCHAR(2024) DEFAULT NULL,
  protocol VARCHAR(256),
  requester VARCHAR(256),
  reviewer VARCHAR(256) DEFAULT NULL,
  aup_uri VARCHAR(256) DEFAULT NULL,
  group_id INTEGER DEFAULT NULL,
  last_edited timestamp without time zone DEFAULT NULL,
  reviewed_at timestamp without time zone DEFAULT NULL,
  organization_id INTEGER,
  FOREIGN KEY (organization_id) REFERENCES organizations(organization_id),
  FOREIGN KEY (tenant) REFERENCES tenants(name),
  FOREIGN KEY (service_id) REFERENCES service_details(id) ON DELETE SET NULL
);


create table service_boolean (
  id SERIAL PRIMARY KEY,
  service_id bigint,
  name VARCHAR(256),
  value BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (service_id) REFERENCES service_details(id) ON DELETE CASCADE
);


create table service_petition_boolean (
  id SERIAL PRIMARY KEY,
  petition_id bigint,
  name VARCHAR(256),
  value BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (petition_id) REFERENCES service_petition_details(id) ON DELETE CASCADE
);


create table service_petition_details_oidc (
  id bigint PRIMARY KEY,
  client_id VARCHAR(256),
  allow_introspection BOOLEAN,
  code_challenge_method VARCHAR(256),
  token_endpoint_auth_method VARCHAR(256),
  token_endpoint_auth_signing_alg VARCHAR(256),
  jwks VARCHAR(2048),
  jwks_uri VARCHAR(256),
  device_code_validity_seconds bigint,
  access_token_validity_seconds bigint,
  refresh_token_validity_seconds bigint,
  reuse_refresh_token BOOLEAN,
  clear_access_tokens_on_refresh BOOLEAN,
  id_token_timeout_seconds bigint,
  client_secret VARCHAR(2048),
  application_type VARCHAR(256),
  FOREIGN KEY (id) REFERENCES service_petition_details(id) ON DELETE CASCADE
);


create table service_petition_details_saml (
  id bigint PRIMARY KEY,
  entity_id VARCHAR(256),
  metadata_url VARCHAR(256),
  FOREIGN KEY (id) REFERENCES service_petition_details(id) ON DELETE CASCADE
);


create table service_petition_contacts (
  id SERIAL PRIMARY KEY,
  owner_id bigint,
  value VARCHAR(256),
  type VARCHAR(256),
  FOREIGN KEY (owner_id) REFERENCES service_petition_details(id) ON DELETE CASCADE
);


create table service_petition_oidc_grant_types (
  id SERIAL PRIMARY KEY,
  owner_id bigint,
  value VARCHAR(256),
  FOREIGN KEY (owner_id) REFERENCES service_petition_details(id) ON DELETE CASCADE
);

create table service_petition_saml_attributes (
  owner_id bigint,
  name VARCHAR(512),
  friendly_name VARCHAR(512),
  required BOOLEAN DEFAULT TRUE,
  name_format VARCHAR(512) DEFAULT 'urn:oasis:names:tc:SAML:2.0:attrname-format:uri',
  FOREIGN KEY (owner_id) REFERENCES service_petition_details(id) ON DELETE CASCADE
);

create table service_petition_oidc_redirect_uris (
  id SERIAL PRIMARY KEY,
  owner_id bigint,
  value VARCHAR(256),
  FOREIGN KEY (owner_id) REFERENCES service_petition_details(id) ON DELETE CASCADE
);

create table service_petition_oidc_post_logout_redirect_uris (
  id SERIAL PRIMARY KEY,
  owner_id bigint,
  value VARCHAR(256),
  FOREIGN KEY (owner_id) REFERENCES service_petition_details(id) ON DELETE CASCADE
);



create table service_petition_oidc_scopes (
  id SERIAL PRIMARY KEY,
  owner_id bigint,
  value VARCHAR(256),
  FOREIGN KEY (owner_id) REFERENCES service_petition_details(id) ON DELETE CASCADE
);


create table tenant_deployer_agents (
  id SERIAL PRIMARY KEY,
  tenant VARCHAR(256),
  integration_environment VARCHAR(256),
  type VARCHAR(256),
  entity_type VARCHAR(256),
  hostname VARCHAR(256),
  entity_protocol VARCHAR(256),
  deployer_name VARCHAR(256),
  FOREIGN KEY (tenant) REFERENCES tenants(name)
);


create table banner_alerts (
    id SERIAL PRIMARY KEY,
    tenant VARCHAR(256),
    alert_message VARCHAR(1054),
    type VARCHAR(256),
    active BOOLEAN DEFAULT false,
    priority INTEGER DEFAULT 0,
    FOREIGN KEY (tenant) REFERENCES tenants(name) ON DELETE CASCADE
);


create  table deployment_tasks (
  agent_id INTEGER,
  service_id INTEGER,
  deployer_name VARCHAR(256),
  error BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (agent_id,service_id),
  FOREIGN KEY (agent_id) REFERENCES tenant_deployer_agents(id),
  FOREIGN KEY (service_id) REFERENCES service_details(id)
);



create table service_tags (
  service_id INTEGER,
  tag VARCHAR(256),
  tenant VARCHAR(256),
  FOREIGN KEY (tenant) REFERENCES tenants(name) ON DELETE CASCADE,
  PRIMARY KEY (tag,service_id)
);



