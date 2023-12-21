# == Define Resource Type: drush::alias
#
# @param ensure
# @param alias_name
# @param group
# @param parent
# @param root
# @param uri
# @param db_url
# @param path_aliases
# @param ssh_options
# @param remote_host
# @param remote_user
# @param custom_options
# @param command_specific
# @param source_command_specific
# @param target_command_specific
#
define drush::alias (
  String $ensure                                           = present,
  String $alias_name                                       = $name,
  Optional[String] $group                                  = undef,
  Optional[String] $parent                                 = undef,
  Optional[String] $root                                   = undef,
  Optional[String] $uri                                    = undef,
  Optional[String] $db_url                                 = undef,
  Optional[Variant[Hash, String]] $path_aliases            = undef,
  Optional[String] $ssh_options                            = undef,
  Optional[String] $remote_host                            = undef,
  Optional[String] $remote_user                            = undef,
  Optional[String] $custom_options                         = undef,
  Optional[Variant[Hash, String]] $command_specific        = undef,
  Optional[Variant[Hash, String]] $source_command_specific = undef,
  Optional[Variant[Hash, String]] $target_command_specific = undef,
) {
  if (!defined(Class['drush'])) {
    fail('You must include class drush before declaring aliases')
  }

  $aliasfile = $group ? {
    undef   => '/etc/drush/aliases.drushrc.php',
    default => "/etc/drush/${group}.aliases.drushrc.php",
  }

  if !defined(Concat[$aliasfile]) {
    concat { $aliasfile:
      ensure => $ensure,
    }
    concat::fragment { "${aliasfile}-header":
      target  => $aliasfile,
      content => "<?php\n#MANAGED BY PUPPET!\n\n",
      order   => 0,
    }
  }

  concat::fragment { "${aliasfile}-${name}":
    target  => $aliasfile,
    content => template('drush/alias.erb'),
    order   => 1,
  }
}
