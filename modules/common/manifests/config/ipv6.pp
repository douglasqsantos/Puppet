# @summary
# Resource to handle the ipv6 configuration
# @param sysctl_ipv6_file
#   Path to sysctl ipv6 configuration file
define common::config::ipv6 (
  String        $sysctl_ipv6_file = '/etc/sysctl.d/99-disable-ipv6.conf'
) {
  # Disable IPV6
  file { $sysctl_ipv6_file:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/common/disable_ipv6',
  }

  # Make sure the configuration is enable
  exec { 'Disable IPV6':
    path    => ['/sbin','/usr/sbin'],
    command => "sysctl --load=${sysctl_ipv6_file}",
    require => File[$sysctl_ipv6_file]
  }
}
