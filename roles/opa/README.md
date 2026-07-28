# Ansible Role: opa

Deploys [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) as a
Policy Decision Point (PDP). Because OPA compiles down to a single,
statically linked binary with zero external dependencies, this role performs
a native binary deployment managed by systemd (no containers required).

The role covers:

* Download and installation of the checksum-verified OPA static binary
  (versioned under `/opt/opa` with a stable symlink at `/usr/local/bin/opa`)
* A hardened systemd unit running OPA as a dedicated unprivileged user
* Policy mount points: local Rego/data files under `/etc/opa/policies` or
  remote bundles (HTTP or OCI registries)
* Live policy updates: file watching (`--watch`) for local policies, or
  bundle polling for remote bundles
* Secure PEP -> PDP connectivity: TLS termination, token or mutual-TLS API
  authentication, and an API authorization (`system.authz`) policy
* Decision logging to the console, i.e. journald, for auditability
* Post-deployment verification of the REST API and a sample Rego rule

The general architecture follows the
[RI-SCALE OPA recipe](https://github.com/RI-SCALE/opa-ri-scale), adapted to a
native static binary deployment.

## Requirements

* Debian 12/13 (tested on Debian 13 "trixie") with systemd
* Outbound HTTPS access to `github.com` (or an internal mirror via
  `opa_download_url`) on the managed node
* When enabling TLS, the certificate and key must already exist on the host
  (e.g. deployed by the `letsencrypt` role)

## Role variables

See `defaults/main.yml` for the full, commented list. The most relevant ones:

| Variable | Default | Description |
|----------|---------|-------------|
| `opa_version` | `1.17.1` | OPA release to install (without leading `v`) |
| `opa_listen_addr` / `opa_listen_port` | `127.0.0.1` / `8181` | REST API bind address/port |
| `opa_policy_mode` | `local` | `local` (Rego files in `opa_policy_dir`) or `bundle` (remote bundles) |
| `opa_watch_policies` | `true` | Live-reload local policies on file change |
| `opa_policy_files` | `[]` | Extra Rego/data files to deploy (items with `name` + `src`/`content`) |
| `opa_sample_policy_enabled` | `true` | Deploy the sample `rciam/authz` policy |
| `opa_services` / `opa_bundles` | `{}` | Remote bundle services and bundles (rendered into the OPA config) |
| `opa_tls_enabled` | `false` | Serve the API over HTTPS (`opa_tls_cert_file`, `opa_tls_key_file`) |
| `opa_authentication` | `off` | API authentication: `off`, `token` or `tls` |
| `opa_authorization` | `off` | API authorization: `off` or `basic` (renders a `system.authz` policy) |
| `opa_api_tokens` | `[]` | Bearer tokens accepted from PEPs (items with `name` + `token`) |
| `opa_decision_logs_console` | `true` | Log decisions (input + result) to journald |
| `opa_verify` | `true` | Run post-deployment smoke tests |

## Example playbook

```yaml
- hosts: opaservers
  roles:
    - role: opa
```

### Local policies with live reload (default)

```yaml
- hosts: opaservers
  roles:
    - role: opa
      vars:
        opa_policy_files:
          - name: myapp.rego
            src: files/policies/myapp.rego
```

Any change to a file under `/etc/opa/policies` is picked up immediately by
the running server (`--watch`), without a service restart.

### Remote bundle polling (RI-SCALE bundle)

```yaml
- hosts: opaservers
  roles:
    - role: opa
      vars:
        opa_policy_mode: bundle
        opa_sample_policy_enabled: false
        opa_default_decision: dep
        opa_services:
          gh:
            url: https://ghcr.io
            type: oci
            credentials:
              bearer:
                scheme: "Bearer"
                token: "{{ vault_ghcr_token }}"
        opa_bundles:
          dep:
            service: gh
            resource: ghcr.io/ri-scale/opa-dep:latest
            polling:
              min_delay_seconds: 60
              max_delay_seconds: 120
```

Bundles are persisted under `/var/lib/opa/bundles` so the service can start
even if the registry is temporarily unreachable.

### Exposing the PDP to remote PEPs

```yaml
- hosts: opaservers
  roles:
    - role: opa
      vars:
        opa_listen_addr: "0.0.0.0"
        opa_tls_enabled: true
        opa_tls_cert_file: /etc/letsencrypt/live/opa.example.org/fullchain.pem
        opa_tls_key_file: /etc/letsencrypt/live/opa.example.org/privkey.pem
        opa_authentication: token
        opa_authorization: basic
        opa_api_tokens:
          - name: pep-service
            token: "{{ vault_opa_pep_token }}"
```

PEPs then query the PDP with:

```bash
curl -H "Authorization: Bearer <token>" \
     https://opa.example.org:8181/v1/data/rciam/authz/allow \
     -d '{"input": {"method": "GET", "path": "/public"}}'
```

## Verification and auditing

With `opa_verify: true` (default) the role waits for the API, checks
`/health` and asserts that the sample rule at `/v1/data/rciam/authz/allow`
returns `true`/`false` for an allowed/denied input.

Manual checks on the host:

```bash
systemctl status opa
journalctl -u opa -f              # runtime + decision logs (JSON)
curl -s localhost:8181/health
curl -s localhost:8181/v1/data/rciam/authz/allow \
     -d '{"input": {"method": "GET", "path": "/public"}}'
```

Each decision log entry includes the `decision_id`, the full `input` and the
`result`, satisfying audit requirements.
