# @summary
# Resource to handle the default locales
# @param default_locale
#   Default locale used by the system
# @param locales
#   locales used by the system
define common::config::locale (
  String        $default_locale = 'pt_BR.UTF-8',
  Array[String] $locales        = ['en_US.UTF-8 UTF-8', 'pt_BR.UTF-8 UTF-8']
) {
  class { 'locales':
    default_locale => $default_locale,
    locales        => $locales,
  }
}
