# @summary
# Adds the motd file template as defaults for all the servers.
# @param issue_tpl 
#   path to the issue template
# @param company_name
#   Company names that will be add into the file
# @param issue_files
#   Array of files that will be handle
define common::config::issue (
  String $issue_tpl           = 'common/issue.epp',
  String $company_name        = 'Douglas Inc.',
  Array[String] $issue_files  = ['/etc/issue', '/etc/issue.net'],
  $params = {
    'company_name'     => $company_name
  }
) {
  file { $issue_files:
    ensure  => file,
    content => epp($issue_tpl, $params),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
