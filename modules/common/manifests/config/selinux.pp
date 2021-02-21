# @summary
# Handle SELinux and Firewall
define common::config::selinux (
  String $firewalld_ensure  = 'stopped',
  String $firewalld_enable  = 'false',
  String $selinux_mode      = 'disabled',
  String $selinux_type      = 'targeted'
) {
  if ($facts['osfamily'] == 'RedHat') and ($facts['os']['release']['major'] >= '7') {
    class { 'selinux':
      mode => $selinux_mode,
      type => $selinux_type,
    }
    service { 'firewalld':
      ensure => $firewalld_ensure,
      enable => $firewalld_enable,
    }
  }
}
