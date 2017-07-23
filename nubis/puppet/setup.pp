file { '/var/www/plugin/htdocs/.htaccess':
  ensure => present,
  source => 'puppet:///nubis/files/htaccess-dist'
}

file { '/var/www/plugin/htdocs/index.php':
  ensure => present,
  source => 'puppet:///nubis/files/index.php-prod-dist'
}

file { '/var/www/plugin/application/logs':
  ensure => 'directory',
}

file { '/var/www/plugin/application/cache/':
  ensure => 'directory',
}

file { '/var/www/plugin/application/cache/twig':
  ensure => 'directory',
}
