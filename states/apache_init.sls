install_apache:
  pkg.installed:
    - name: apache2

apache_config:
  file.managed:
    - name: /etc/apache2/sites-available/wp.conf
    - source: salt://files/wp-apache.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install_apache

index_config:
  file.managed:
    - name: /etc/apache2/mods-available/dir.conf
    - source: salt://files/dirmod.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install_apache

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
      - pkg: install_apache
      - file: apache_site_enabled

restart_apache:
  cmd.run:
    - name: systemctl restart apache2