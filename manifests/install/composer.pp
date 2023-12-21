# == Define Resource Type: drush::install::composer
#
# @param version
# @param install_path
# @param install_type
#
define drush::install::composer (
  String $version,
  String $install_path,
  String $install_type,
) {
  #private()
  if $caller_module_name != $module_name {
  warning("${name} is not part of the public API of the ${module_name} \
module and should not be directly included in the manifest.")
  }

  # If version is 'master' or a single major release number,
  # transform into something composer understands.
  $real_version = $version ? {
    /\./     => $version,
    'master' => 'dev-master',
    default  => "${version}.*",
  }

  file { $install_path:
    ensure => directory,
  }

  $base_path = dirname($install_path)
  $composer_home = "${base_path}/.composer"
  $prefer = "--prefer-${install_type}"
  $cmd = "${drush::composer_path} require drush/drush:${real_version} ${prefer}"
  exec { $cmd:
    cwd         => $install_path,
    environment => ["COMPOSER_HOME=${composer_home}"],
    require     => File[$install_path],
    onlyif      => "test ! -f composer.json || test \"$(grep drush/drush composer.json | cut -d\\\" -f 4)\" != '${real_version}'",
  }
}
