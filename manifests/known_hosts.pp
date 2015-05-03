# == Class: ssh::known_hosts
#
# Manages /etc/ssh/ssh_known_hosts entries.
#
class ssh::known_hosts{
  case $::osfamily {
    RedHat, Debian: {
      # supported
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  $known_hosts = hiera_hash('ssh::known_hosts', undef)

  if $known_hosts != undef {
    create_resources(ssh::manage_known_hosts, $known_hosts)
  }
}
