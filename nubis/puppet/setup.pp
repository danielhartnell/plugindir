# Setup symlinks to meet install requirements
# Todo:
# Add some logic to provide the prod / stage index files

file { '/var/www/plugin/htdocs/index.php':
  ensure => link,
  target => '/var/www/plugin/htdocs/index.php-prod-dist'
}

file { '/var/www/plugin/htdocs/htaccess-dist':
  ensure => link,
  target => '/var/www/plugin/htdocs/.htaccess'
}
