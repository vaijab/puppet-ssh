# == Class: ssh::server
#
# This class installs and configures openssh server.
#
#
# === Parameters
#
# [*enable*]
#   Whether to start the service on boot. Valid values: <code>true</code> or
#   <code>false</code>. Defaults to <code>true</code>.
#
#
# [*ensure*]
#   Whether to have the service started on the next boot. Valid values:
#   <code>running</code> or <code>stopped</code>. Default: <code>running</code>.
#
#
# [*permitrootlogin*]
#   Whether to permit root login via ssh. See 'PermitRootLogin' in
#   'man sshd_config'. Defaults to <code>without-password</code>.
#
#
# [*passwordauth*]
#   Whether to permit password authentication. Defaults to <code>no</code>.
#
#
# [*denyusers*]
#   A list of users to deny access via ssh. See <code>DenyUsers</code> in
#   man sshd_config.
#
#
# [*allowusers*]
#   A list of users to allow access via ssh. See <code>AllowUsers</code> in
#   man sshd_config.
#
#
# [*denygroups*]
#   A list of groups to deny access via ssh. See <code>DenyGroups</code> in
#   man sshd_config.
#
#
# [*allowgroups*]
#   A list of groups to allow access via ssh. See <code>AllowGroups</code> in
#   man sshd_config.
#
#
# [*usedns*]
#   Whether to use reverse DNS for new connections. Defaults to <code>no</code>.
#
#
# [*gssapiauth*]
#   Enable or disable 'GSSAPIAuthentication' on the server side. Valid values:
#   <code>yes</code> or <code>no</code>. Defaults to <code>no</code>.
#
# [*print_last_log*]
#   Whether to print last login message or not. Default: `yes`.
#
# [*sftp_group_match*]
#   Takes a list (array) of user groups to be matched for sftp-only subsystem.
#   This needs to be specified if you want any user groups to be enabled for
#   sftp-only.
#
#
# [*sftp_user_match*]
#   Takes a list (array) of users to be matched for sftp-only subsystem. This
#   needs to be specified if you want users to be match for sftp-only access.
#
#
# [*sftp_chroot_path*]
#   Users which connect to sftp subsystem they will be placed into a chroot
#   jail. This variable let's you specify the path of the jail.
#   Defaults to <code>%h</code>, which is user's home directory.
#
#
# === Requires
#
# Inherits parent class
#
#
# === Examples
#
# This shows a sample usage using hiera and yaml data backend:
#
#     ---
#     classes:
#       - ssh::server
#
#     ssh::server::permitrootlogin: 'no'
#     ssh::server::passwordauth: 'yes'
#     ssh::server::sftp_user_match:
#       - 'foo'
#       - 'bar'
#
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class ssh::server(
    $enable           = true,
    $ensure           = running,
    $permitrootlogin  = 'without-password',
    $passwordauth     = 'no',
    $usedns           = 'no',
    $gssapiauth       = 'no',
    $denyusers        = [],
    $denygroups       = [],
    $allowgroups      = [],
    $allowusers       = [],
    $print_last_log   = 'yes',
    $sftp_group_match = [],
    $sftp_user_match  = [],
    $sftp_chroot_path = '%h'
  ) inherits ssh {

  case $::osfamily {
    RedHat: {
      $service_name = 'sshd'
    }
    Debian: {
      $service_name = 'ssh'
    }
  }

  $package_name  = 'openssh-server'
  $config_name   = 'sshd_config'
  $conf_template = 'sshd_config.erb'

  package { $package_name:
    ensure => installed,
  }

  file { "/etc/ssh/${config_name}":
    ensure  => file,
    require => Package[$package_name],
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("ssh/${conf_template}"),
  }

  service { $service_name:
    ensure    => $ensure,
    enable    => $enable,
    subscribe => File["/etc/ssh/${config_name}"],
    require   => Package[$package_name],
  }

  if $ssh::server::sftp_chroot_path != '%h' {
    file { [$sftp_chroot_path,
            "${sftp_chroot_path}/home",
            "${sftp_chroot_path}/dev"]:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755'
    }
  }

  # Export node's ssh rsa public host key
  @@sshkey { "${::fqdn}_ssh_host_key":
    ensure       => present,
    host_aliases => [ $::ipaddress, $::hostname ],
    type         => 'rsa',
    key          => $::sshrsakey,
  }
}
