delete_mysql_key:
  cmd.run:
    - name: salt-key -d mysql -y

delete_wp_key:
  cmd.run:
    - name: salt-key -d wp -y

delete_apache_key:
  cmd.run:
    - name: salt-key -d apache -y

delete_prometheus_key:
  cmd.run:
    - name: salt-key -d prometheus -y