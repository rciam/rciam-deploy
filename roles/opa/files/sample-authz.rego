# Sample authorization policy deployed by the opa Ansible role.
# Queried via: POST /v1/data/rciam/authz/allow
# Disable with: opa_sample_policy_enabled: false

package rciam.authz

default allow := false

# Allow anonymous read access to public resources
allow if {
    input.method == "GET"
    input.path == "/public"
}

# Allow administrators (defined in data.rciam.admins) to do anything
allow if {
    input.user in data.rciam.admins
}
