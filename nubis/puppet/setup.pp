file { "/var/www/${project_name}/htdocs/.htaccess":
  ensure => present,
  source => 'puppet:///nubis/files/htaccess-dist'
}

file { "/var/www/${project_name}/htdocs/index.php":
  ensure => present,
  source => 'puppet:///nubis/files/index.php-prod-dist'
}

file { "/var/www/${project_name}/application/logs":
  ensure => 'directory',
}

file { "/var/www/${project_name}/application/cache/":
  ensure => 'directory',
}

file { "/var/www/${project_name}/application/cache/twig":
  ensure => 'directory',
}
