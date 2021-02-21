# @summary class to handle common tasks for Debian/RedHat Base Systems
#
# This class is to handle common tasks for Debian/RedHat Base Systems
#   Tasks such as motd, common packages, access control (Groups, Users, SSH Keys) and puppet service
# Depends on:
# - puppet module install puppet-selinux --version 3.2.0
# - puppet module install saz-locales --version 2.5.1
#
# @param server_role
#   Server Role define to the server
# @param default_locale
#   Default locale used by the system
# @param locales
#   # Defining the locales used by the system
# @param common_user
#   The common user to be used to add the ssh key
# @param sysctl_ipv6_file
#   Path to the sysctl ipv6 file control
# @example
#   class { 'common':
#     server_role     => 'Docker Server',
#     default_locale  => 'pt_BR.UTF-8',
#     locales         => ['en_US.UTF-8 UTF-8', 'pt_BR.UTF-8 UTF-8'],
#     common_user     => 'douglas'
#   }
class common (
  $server_role      = 'Generic',
  $default_locale   = 'pt_BR.UTF-8',
  $locales          = ['en_US.UTF-8 UTF-8', 'pt_BR.UTF-8 UTF-8'],
  $common_user      = 'douglas',
  $sysctl_ipv6_file = '/etc/sysctl.d/99-disable-ipv6.conf'
){

  # Configuring the motd
  common::config::motd { 'Message of the Day (Motd)':
    server_role => $server_role,
  }

  # Configuring issue files
  common::config::issue { 'Issue Files':
    company_name => 'Douglas Inc.'
  }

  # Install the default packages
  common::packages { 'Default Packages': }

  # Handle groups and users
  common::config::accesscontrol { 'Handle Groups and Users':
      common_user => 'douglas',
  }

  # Disable IPV6
  common::config::ipv6 { 'Disable IPV6':
    sysctl_ipv6_file => $sysctl_ipv6_file,
  }

  # Puppet Agent must be running
  service { 'puppet':
    ensure => 'running',
    enable => true
  }

}
