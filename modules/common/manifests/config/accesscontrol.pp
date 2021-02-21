# @summary
# Resource to Handle Groups
# @param groups
#   Array of groups to be added
# @param sudo_users
#   Array of users to be created and added into sudo group
# @param common_user
#   Common user to be added and receive the ssh access key
define common::config::accesscontrol (
  Array[String] $groups      = ['sudo','wheel','sysadmins'],
  Array[String] $sudo_users  = ['douglas','jose','john'],
  String $common_user        = 'ec2user'
) {

  # Handle Groups
  group { $groups:
    ensure => present,
  }

  # Handle the users
  $sudo_users.each | String $user | {
    user { $user:
      ensure     => present,
      managehome => true,
      groups     => ['sudo'],
      require    => Group['sudo'],
      shell      => '/bin/bash',
    }

    file { "/home/${user}/.bashrc":
      ensure => file,
      owner  => $user,
      group  => $user,
      source => 'puppet:///modules/common/bashrc',
    }

    file { "/home/${user}/.vimrc":
      ensure => file,
      owner  => $user,
      group  => $user,
      source => 'puppet:///modules/common/vimrc',
    }

    file { "/home/${user}/.vim":
      ensure  => directory,
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/common/vim',
      recurse => remote
    }
  }

  # Root User configuration file
  file { '/root/.bashrc':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/common/bashrc',
  }

  file { '/root/.vimrc':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/common/vimrc',
  }

  file { '/root/.vim':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/common/vim',
    recurse => remote
  }

  # Handle the users
  unless User[$common_user] {
    user { $common_user:
      ensure         => present,
      managehome     => 'true',
      groups         => [ 'sudo' ],
      require        => Group['sudo'],
      shell          => '/bin/bash',
      purge_ssh_keys => true,
    }
    file { "/home/${common_user}/.bashrc":
      ensure => file,
      owner  => $common_user,
      group  => $common_user,
      source => 'puppet:///modules/common/bashrc',
    }

    file { "/home/${common_user}/.vimrc":
      ensure => file,
      owner  => $common_user,
      group  => $common_user,
      source => 'puppet:///modules/common/vimrc',
    }

    file { "/home/${common_user}/.vim":
      ensure  => directory,
      owner   => $common_user,
      group   => $common_user,
      source  => 'puppet:///modules/common/vim',
      recurse => remote
    }
  }

  # Common User
  ssh_authorized_key { $common_user:
    ensure  => present,
    user    => $common_user,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQCzuDxd5fmfykDYFXI8DEJUxU3B/ablXaIPbEe20d8UwKvCUZo8I+pDQD3uizz+zEhSQBnh2U3Z0PDgAr9V42StmHR8VuM9aNR5lSAezcmk0/C3JJulc/0Xw6Cms9TUPYwKKg922oeKpHPyDaJcc8fGfLfwSW91mDE+eptrTkF0zB4XWffoUAf061nPEBDad1HL4js03CYm4bpEy7gm2KrQ8m8lBrQD/mCGUDocZ/RIGsrqY9EGLiz9wS9YUI5r0wYpNMW9r7/FptI0lXoaxYIGWjUKR8leujgmXq/tc7x+rNPEGC9RCarMrwe11ZPdf8qUhtnjBXS4Nru8MQJjd7P+COiY6LXOgBhIy/3PT1k8iAsokXoyc4JWQngTiEABhF9cIs8gvTfKQ/QKTwu8BdYvf2R9C4AQX7Tkw8HcY/FLDvO9hPx9uLICaBK6H9BV0ewsbDQqnyFCQBf5ZB+wBq6yAl+ExvGPfWaSmF9pUJOo5rM2rvejRNXv15vaYgWFzQE=',
    require => User[$common_user],
  }

}
