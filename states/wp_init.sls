install_packages:
  pkg.installed:
    - pkgs:
      - apache2
      - php
      - libapache2-mod-php
      - php-mysql
      - curl

apache_config:
  file.managed:
    - name: /etc/apache2/sites-available/wp.conf
    - source: salt://wp-automation/files/wp-endpoint.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install_packages

index_config:
  file.managed:
    - name: /etc/apache2/mods-available/dir.conf
    - source: salt://wp-automation/files/dirmod.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install_packages

enable_modules:
  cmd.run:
    - name: >
        a2enmod ssl rewrite proxy proxy_http

apache_default_disabled:
  cmd.run:
    - name: a2dissite 000-default
    - unless: ls /etc/apache2/sites-enabled/ |grep wp.conf

apache_site_enabled:
  file.symlink:
    - name: /etc/apache2/sites-enabled/wp.conf
    - target: /etc/apache2/sites-available/wp.conf
    - require:
      - file: apache_config

apache_on:
  service.running:
    - name: apache2
    - enable: True
    - require:
      - pkg: install_packages
      - file: apache_site_enabled

restart_apache:
  cmd.run:
    - name: systemctl restart apache2

download_wp:
  cmd.run:
    - name: curl -o /root/latest.tar.gz https://wordpress.org/latest.tar.gz
    - unless: ls /root | grep latest.tar.gz

extract_wordpress:
  cmd.run:
    - name: tar -xzf /root/latest.tar.gz -C /var/www/
    - unless: ls /var/www |grep wordpress

chown_wp:
  cmd.run:
    - name: chown -R www-data:www-data /var/www/wordpress

chmodd_wp:
  cmd.run:
    - name: find /var/www/wordpress/ -type d -exec chmod 750 {} \; 

chmodf_wp:
  cmd.run:
    - name: find /var/www/wordpress/ -type f -exec chmod 640 {} \;

copy_wp_config:
  file.managed:
    - name: /var/www/wordpress/wp-config.php
    - source: salt://wp-automation/files/wp-config.php
