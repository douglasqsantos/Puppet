# Non-Defined Servers
node 'default' {
  class { 'common':
    server_role    => 'Generic',
    default_locale => 'pt_BR.UTF-8',
    locales        => ['en_US.UTF-8 UTF-8', 'pt_BR.UTF-8 UTF-8'],
  }
}

# Puppet Server
node 'puppet.dqs.local' {
  class { 'common':
    server_role => 'Puppet Server',
  }
}

# Build Server
node 'agent.dqs.local' {
  class { 'common':
    server_role => 'Build Server',
    common_user => 'ec2user',
  }
}
