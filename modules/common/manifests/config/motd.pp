# @summary
#   Adds the motd file template as defaults for all the servers.
# @param motd_tpl
#   Message of the Day (Motd) template
# @param server_role
#   Define the Server Role that will be replace into the template
define common::config::motd (
  String $motd_tpl = 'common/motd.epp',
  String $server_role = 'Generic',
  $params = {
    'os_name'         => $::facts['os']['name'],
    'os_major'        => $::facts['os']['release']['major'],
    'os_minor'        => $::facts['os']['release']['minor'],
    'os_uptime'       => $::facts['system_uptime']['uptime'],
    'hw_name'         => $::facts['dmi']['product']['name'],
    'os_memory_free'  => $::facts['memory']['system']['available'],
    'os_memory_total' => $::facts['memory']['system']['total'],
    'load_avg_1m'     => $::facts['load_averages']['1m'],
    'load_avg_5m'     => $::facts['load_averages']['5m'],
    'load_avg_15m'    => $::facts['load_averages']['15m'],
    'root_free_space' => $::facts['mountpoints']['/']['available'],
    'root_total_size' => $::facts['mountpoints']['/']['size'],
    'root_perc_used'  => $::facts['mountpoints']['/']['capacity'],
    'processor_count' => $::facts['processors']['count'],
    'processor_model' => $::facts['processors']['models']['0'],
    'server_name'     => $::trusted['certname'],
    'server_role'     => $server_role
  }
) {
  file { '/etc/motd':
    ensure  => file,
    content => epp($motd_tpl, $params),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
