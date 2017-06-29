class { 'nubis_apache':
  mpm_module_type => 'prefork'
}

# Add modules
class { 'apache::mod::rewrite': }
class { 'apache::mod::php': }

apache::vhost { $project_name:
    port               => 80,
    default_vhost      => true,
    docroot            => "/var/www/$project_name",
    docroot_owner      => 'root',
    docroot_group      => 'root',
    block              => ['scm'],
    setenvif           => [
      'X-Forwarded-Proto https HTTPS=on',
      'Remote_Addr 127\.0\.0\.1 internal',
      'Remote_Addr ^10\. internal',
    ],
    access_log_env_var => '!internal',
    access_log_format  => '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"',
    custom_fragment    => "

    # Don't set default expiry on anything
    ExpiresActive Off

    <Directory /var/www/plugin/htdocs/>
      AllowOverride all
      Order allow,deny
      Allow from all
    </Directory>
",
    headers            => [
      # Nubis headers
      "set X-Nubis-Version ${project_version}",
      "set X-Nubis-Project ${project_name}",
      "set X-Nubis-Build   ${packer_build_name}",

      # Security Headers
      'set X-Content-Type-Options "nosniff"',
      'set X-XSS-Protection "1; mode=block"',
      'set X-Frame-Options "DENY"',
      'set Strict-Transport-Security "max-age=31536000"',
    ],
    rewrites           => [
      {
        comment      => 'HTTPS redirect',
        rewrite_cond => ['%{HTTP:X-Forwarded-Proto} =http'],
        rewrite_rule => ['. https://%{HTTP:Host}%{REQUEST_URI} [L,R=permanent]'],
      }
    ]
}

  <VirtualHost *:80>
      ServerName dev.plugindir.mozilla.org
      DocumentRoot {plugindir path}/htdocs/
      ErrorLog {plugindir path}/logs/error_log
      TransferLog {plugindir path}/logs/access_log
      <Directory {plugindir path}/htdocs/>
          AllowOverride all
          Order allow,deny
          Allow from all
      </Directory>
  </VirtualHost>
