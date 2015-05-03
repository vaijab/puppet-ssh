# == Defined Type: ssh::manage_known_hosts
#
# This defined type sets up /etc/ssh/ssh_known_hosts entries from a hash.
#
define ssh::manage_known_hosts(
  $ensure       = 'present',
  $host_aliases = undef,
  $key          = undef,
  $type         = 'ssh-rsa',
) {

  if $key == undef {
    fail('Please specify a key to add.')
  }

  sshkey { $title:
    ensure       => $ensure,
    host_aliases => $host_aliases,
    key          => $key,
    type         => $type,
  }
}
