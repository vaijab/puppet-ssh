# puppet-ssh

Puppet module to manage ssh client and server configuration.

## ssh
## ssh::client
## ssh::server

## ssh::known_hosts
Manages Linux system /etc/ssh/ssh_known_hosts entries.

### Parameters
* `ensure` - Whether this entry exists or not. Default: `present`.
* `host_aliases` - A list of host aliases. See examples. Default: `undef`.
* `key` - The key to add. This is a required parameter, otherwise puppet will fail. Default: `undef`.
* `type` - The key type, see http://docs.puppetlabs.com/references/latest/type.html#sshkey Default: `ssh-rsa`.

### Examples
```yaml
---
classes:
  - ssh::known_hosts

ssh::known_hosts:
  'foo.example.com':
    host_aliases:
      - 'foo01'
      - 'foo02'
    key: 'APUBLICKEY'
  'bar.example.com':
    host_aliases:
      - 'bar01'
      - 'bar02'
    key: 'ANOTHERPUBLICKEY'
    type: 'ssh-dss'
```

## Authors
* Vaidas Jablonskis <jablonskis@gmail.com>
