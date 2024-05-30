### Se asegura de que los contenedores están encendidos,    ###
### si no lo están, los enciende                            ###
ensure_mysql_running:
  cmd.run:
    - name: |
        if [ "$(pct status 101 | awk '{print $2}')" != "running" ]; then
          pct start 101
          # Wait for the container to start
          while [ "$(pct status 101 | awk '{print $2}')" != "running" ]; do
            sleep 1
          done
        fi
    - shell: /bin/bash

ensure_wp_running:
  cmd.run:
    - name: |
        if [ "$(pct status 102 | awk '{print $2}')" != "running" ]; then
          pct start 102
          # Wait for the container to start
          while [ "$(pct status 102 | awk '{print $2}')" != "running" ]; do
            sleep 1
          done
        fi
    - shell: /bin/bash

ensure_apache_running:
  cmd.run:
    - name: |
        if [ "$(pct status 103 | awk '{print $2}')" != "running" ]; then
          pct start 103
          # Wait for the container to start
          while [ "$(pct status 103 | awk '{print $2}')" != "running" ]; do
            sleep 1
          done
        fi
    - shell: /bin/bash

ensure_prometheus_running:
  cmd.run:
    - name: |
        if [ "$(pct status 104 | awk '{print $2}')" != "running" ]; then
          pct start 104
          # Wait for the container to start
          while [ "$(pct status 104 | awk '{print $2}')" != "running" ]; do
            sleep 1
          done
        fi
    - shell: /bin/bash

### Instala el minion de salt en cada contenedor, para que esto pase  ###
### se asegura de que el paso anterior se cumpla                      ###
mysql_install_salt:
  cmd.run:
    - name: |
        pct exec 101 -- bash -c "apt update && wget -O bootstrap-salt.sh https://bootstrap.saltproject.io && sh bootstrap-salt.sh -A 192.168.18.158 stable 3007.1"
    - onlyif: pct exec 101 -- bash -c "which salt-minion || echo 'not_installed'"
    - unless: pct exec 101 -- bash -c "which salt-minion"
    - require:
      - cmd: ensure_mysql_running
    - shell: /bin/bash

wp_install_salt:
  cmd.run:
    - name: |
        pct exec 102 -- bash -c "apt update && wget -O bootstrap-salt.sh https://bootstrap.saltproject.io && sh bootstrap-salt.sh -A 192.168.18.158 stable 3007.1"
    - onlyif: pct exec 102 -- bash -c "which salt-minion || echo 'not_installed'"
    - unless: pct exec 102 -- bash -c "which salt-minion"
    - require:
      - cmd: ensure_wp_running
    - shell: /bin/bash

apache_install_salt:
  cmd.run:
    - name: |
        pct exec 103 -- bash -c "apt update && wget -O bootstrap-salt.sh https://bootstrap.saltproject.io && sh bootstrap-salt.sh -A 192.168.18.158 stable 3007.1"
    - onlyif: pct exec 103 -- bash -c "which salt-minion || echo 'not_installed'"
    - unless: pct exec 103 -- bash -c "which salt-minion"
    - require:
      - cmd: ensure_apache_running
    - shell: /bin/bash

prometheus_install_salt:
  cmd.run:
    - name: |
        pct exec 104 -- bash -c "apt update && wget -O bootstrap-salt.sh https://bootstrap.saltproject.io && sh bootstrap-salt.sh -A 192.168.18.158 stable 3007.1"
    - onlyif: pct exec 104 -- bash -c "which salt-minion || echo 'not_installed'"
    - unless: pct exec 104 -- bash -c "which salt-minion"
    - require:
      - cmd: ensure_prometheus_running
    - shell: /bin/bash

accept_keys_on_master_srv:
  cmd.run:
    - name: salt-key -Ay