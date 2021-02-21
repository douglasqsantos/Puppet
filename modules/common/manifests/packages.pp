# @summary
# Handle the default packages for the OS
# @param other_packages
#   Other packages that can be installed
define common::packages (
  Array[String] $other_packages = ['links']
) {
  case $::facts['os']['family'] {
    'Redhat': {

      # SSH Service
      $ssh_service = 'sshd'

      case $::facts['os']['release']['major'] {
        '7': {
          # Default packages to install
          $packages = [ 'yum-utils', 'wget','curl','bind-utils','dos2unix','tcpdump','nmap','git','sudo','ntpdate','rsync','telnet','vim-enhanced','zip','unzip','p7zip','bzip2','xz','less','dstat','pciutils','dmidecode','htop','usbutils','strace','ltrace','bc','sysstat','nc', 'mlocate', 'screen', 'openssh-server' ]
        }
        '8': {
          # Default packages to install
          $packages = [ 'yum-utils', 'wget', 'sysstat', 'htop', 'iotop', 'vim', 'mlocate', 'telnet', 'bind-utils', 'ncdu', 'dos2unix', 'screen', 'zip', 'unzip', 'tcptraceroute', 'bc' ]
        }
        default: {
          fail('Unknown operating system')
        }
      }

      # Handle Selinux and Firewall
      common::config::selinux { 'SELinux and Firewall': }

      # Epel Repository
      package { 'epel-release':
        ensure => 'installed',
      }

      # Install the default packages after Epel package
      package { $packages:
        ensure  => 'installed',
        require => Package['epel-release']
      }

    }
    'Debian': {

      # SSH Service
      $ssh_service = 'ssh'

      # Default packages to install
      $packages = ['python-apt','python-apt-common','htop','vim','vim-scripts','vim-doc','less','locate','ntpdate','sudo','git','rsync','aptitude','xz-utils','unrar','zip','unzip','rar','p7zip','bzip2','telnet','dstat','dos2unix','strace','ltrace','tcpdump','nmap','dmidecode','pciutils','procinfo','ifstat','wget','curl','dnsutils','bc','fish','netcat']

      # Install the default packages
      package { $packages:
        ensure => 'installed',
      }

    }
    default: {
      fail('Unknown operating system')
    }
  }

  # Always get the latest version of tzdata
  package { 'tzdata':
    ensure => latest,
  }

  # Make sure sshd server is running
  service { $ssh_service:
    ensure => 'running',
    enable => true
  }

}
