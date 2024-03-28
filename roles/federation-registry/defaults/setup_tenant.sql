INSERT INTO tenants (name,client_id,client_secret,issuer_url,base_url)
VALUES ('tenant_name','client_id_value','client_secret_value','issuer_url','http://localhost:3000/tenant_name');

INSERT INTO user_roles (role_name,tenant)
VALUES ('End User','tenant_name');
INSERT INTO user_roles(role_name,tenant)
VALUES ('Administrator','tenant_name');

INSERT INTO role_entitlements (role_id,entitlement)
VALUES (2,'administrator_entitlement');


INSERT INTO role_actions(role_id,action)
VALUES(1 , 'get_user'),
    (1 , 'get_own_services'),
    (1 , 'get_own_service'),
    (1 , 'get_own_petitions'),
    (1 , 'get_own_petition'),
    (1 , 'add_own_petition'),
    (1 , 'update_own_petition'),
    (1 , 'delete_own_petition'),
    (1 , 'view_errors'),
    (2 , 'get_user'),
    (2 , 'get_own_services'),
    (2 , 'get_own_service'),
    (2 , 'get_service'),
    (2 , 'get_own_petitions'),
    (2 , 'get_own_petition'),
    (2 , 'get_petition'),
    (2 , 'add_own_petition'),
    (2 , 'update_own_petition'),
    (2 , 'delete_own_petition'),
    (2 , 'review_own_petition'),
    (2 , 'review_restricted'),
    (2 , 'get_petitions'),
    (2 , 'get_services'),
    (2 ', view_groups'),
    (2 , 'invite_to_group'),
    (2 , 'view_errors'),
    (2 , 'send_notifications'),
    (2 , 'error_action'),
    (2 , 'review_petition'),
    (2 , 'manage_tags'),
    (2 , 'export_services');


INSERT INTO tenant_deployer_agents (tenant,integration_environment,type,entity_type,hostname,entity_protocol,deployer_name)
VALUES
  ('tenant_name', 'production', 'keycloak', 'service', 'test_deployer','oidc',null ),
  ('tenant_name', 'demo', 'keycloak', 'service', 'test_deployer','oidc',null ),
  ('tenant_name', 'development', 'keycloak', 'service', 'test_deployer','oidc',null ),
  ('tenant_name', 'production', 'ssp', 'service', 'test_deployer','saml','1' ),
  ('tenant_name', 'production', 'ssp', 'service', 'test_deployer','saml','2' ),
  ('tenant_name', 'demo', 'ssp', 'service', 'test_deployer','saml','1' ),
  ('tenant_name', 'demo', 'ssp', 'service', 'test_deployer','saml','2'),
  ('tenant_name', 'development', 'ssp', 'service', 'test_deployer','saml',null );
