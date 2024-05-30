# Se comprueba que el paquete está instalado, si no
# lo estuviera, lo instala
install-mariadb:
  pkg.installed:
    - name: mariadb-server
# Se lleva el archivo de configuración de mariadb en files
# para usar configuración personalizada
configure_mariadb:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://wp-automation/files/my.cnf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install-mariadb
# Inicia y habilita el servicio
start_mariadb_service:
  service.running:
    - name: mariadb
    - enable: True
    - require:
      - pkg: install-mariadb
      - file: configure_mariadb

# Establece contraseña para el admin de mariadb
set_mysql_root_password:
  cmd.run:
    - name: |
        mysqladmin -u root password 'root_passwd'
    - unless: mysql -u root -p'root_passwd' -e "SHOW DATABASES;"
    - require:
      - service: start_mariadb_service

create_wp_database:
  cmd.run:
    - name: mysql -u root -e "CREATE DATABASE IF NOT EXISTS wpdb;"

create_wp_user:
  cmd.run:
    - name: mysql -u root -e "CREATE USER IF NOT EXISTS 'wpuser'@'192.168.18.152' IDENTIFIED BY 'MyStrongPassword';"
    - require:
      - cmd: create_wp_database

grant_wp_user:
  cmd.run: 
    - name: mysql -u root -e "GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'192.168.18.152';"

flush_priv:
  cmd.run:
    - name: mysql -u root -e "FLUSH PRIVILEGES;"

restart_mariadb:
  cmd.run:
    - name: systemctl restart mariadb