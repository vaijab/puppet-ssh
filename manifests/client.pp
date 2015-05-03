# == Class: ssh::client
#
# This class installs and configures openssh client package.
#
#
# === Parameters
#
# [*gssapiauth*]
#   See "man ssh_config" for GSSAPIAuthentication explanation.
#   Available values: <code>yes</code> and <code>no</code>.
#   Default: <code>no</code>.
#
# [*collect_known_hosts*]
#   Whether to collect known host public keys. Default: false.
#
# [*strict_host_key_checking*]
#   Whether to perform ssh host key check. Default: 'ask'. Valid values:
#   'no', 'yes', 'ask'.
#
# === Requires
#
# Inherits parent class
#
# === Examples
#
#
# This shows a sample usage using hiera and yaml data backend:
#
#     ---
#     classes:
#       - ssh::client
#
#     ssh::client::gssapiauth: 'yes'
#
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class ssh::client(
    $gssapiauth               = 'no',
    $collect_known_hosts      = false,
    $strict_host_key_checking = 'ask',
  ) inherits ssh {

  $conf_template = 'ssh_config.erb'

  file { '/etc/ssh/ssh_config':
    ensure  => file,
    require => Package[$ssh::package_name],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("ssh/${conf_template}"),
  }

  file { '/etc/ssh/ssh_known_hosts':
    ensure  => file,
    require => Package[$ssh::package_name],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $collect_known_hosts {
    # imports exported ssh host keys
    Sshkey <<| |>>

    # remove redundant ssh keys from ssh_known_hosts file
    resources { 'sshkey':
      purge => true,
    }
  }
}
