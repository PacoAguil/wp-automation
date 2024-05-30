download_node_exporter:
  file.managed:
    - name: /root/node_exporter-1.8.1.linux-amd64.tar.gz 
    - source: https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz  
    - skip_verify: True
    - unless: ls /root | grep node_exporter

create_user:
  cmd.run:
    - name: groupadd -f node_exporter && useradd -g node_exporter --no-create-home --shell /bin/false node_exporter
    - unless: cat /etc/passwd | grep node_exporter

extract_node_exporter:
  archive.extracted:
    - name: /root/node_exporter-1.8.1.linux-amd64
    - source: /root/node_exporter-1.8.1.linux-amd64.tar.gz  
    - unless: ls /root/node_exporter-1.8.1.linux-amd64/ | grep node_exporter

move_node_exporter:
  file.managed:
    - name: /usr/bin/node_exporter  
    - source: /root/node_exporter-1.8.1.linux-amd64/node_exporter-1.8.1.linux-amd64/node_exporter  
    - user: root  
    - group: root  
    - mode: '0755'  
    - replace: True
    - unless: ls /usr/bin/node_exporter | grep node_exporter

node_exporter_service:
  file.managed:
    - name: /usr/lib/systemd/system/node_exporter.service  
    - source: salt://wp-automation/files/node_exporter.service
    - user: root  
    - group: root  
    - mode: '0755'  
    - replace: True
    - unless: ls /usr/lib/systemd/system | grep node_exporter

permissions_exporter:
  cmd.run:
    - name: chmod 664 /usr/lib/systemd/system/node_exporter.service

reload_and_start:
  cmd.run:
    - name: systemctl daemon-reload && systemctl start node_exporter && systemctl enable node_exporter