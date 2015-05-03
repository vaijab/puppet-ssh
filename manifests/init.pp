# == Class: ssh
#
# This class installs openssh package. It's an initial ssh module class.
# Use child classes for more options.
#
#
# === Parameters
#
# None
#
#
# === Requires
#
# None
#
#
# === Examples
#
#     ---
#     classes:
#       - ssh
#
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class ssh {
  case $::osfamily {
    RedHat: {
      $package_name = 'openssh'
    }
    Debian: {
      $package_name = 'openssh-client'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  package { $package_name:
    ensure => installed,
  }
}
