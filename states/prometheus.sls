download_prometheus:
  file.managed:
    - name: /root/prometheus-2.52.0.linux-amd64.tar.gz
    - source: https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz
    - skip_verify: True
    - makedirs: True
    - unless: test -f /root/prometheus-2.52.0.linux-amd64.tar.gz

extract_prometheus:
  cmd.run:
    - name: tar -xzf /root/prometheus-2.52.0.linux-amd64.tar.gz -C /root/
    - creates: /root/prometheus-2.52.0.linux-amd64
    - require:
      - file: download_prometheus

create_prometheus_user:
  user.present:
    - name: prometheus
    - createhome: False
    - shell: /bin/false

create_prometheus_dir:
  file.directory:
    - name: /etc/prometheus
    - user: prometheus
    - group: prometheus
    - mode: 755
    - require:
      - user: prometheus

another_prometheus_dir:
  file.directory:
    - name: /var/lib/prometheus
    - user: prometheus
    - group: prometheus
    - mode: 755
    - require:
      - user: prometheus


copy_prometheus_binary:
  file.managed:
    - name: /usr/local/bin/prometheus
    - source: /root/prometheus-2.52.0.linux-amd64/prometheus
    - user: prometheus
    - group: prometheus
    - mode: 755

copy_promtool_binary:
  file.managed:
    - name: /usr/local/bin/promtool
    - source: /root/prometheus-2.52.0.linux-amd64/promtool
    - user: prometheus
    - group: prometheus
    - mode: 755

copy_consoles_directory:
  cmd.run:
    - name: 'cp -r /root/prometheus-2.52.0.linux-amd64/consoles /etc/prometheus'
    - unless: 'test -d /etc/prometheus/consoles'
    - user: root
    - require:
      - user: prometheus

copy_console_libraries_directory:
  cmd.run:
    - name: 'cp -r /root/prometheus-2.52.0.linux-amd64/console_libraries /etc/prometheus'
    - unless: 'test -d /etc/prometheus/console_libraries'
    - user: root
    - require:
      - user: prometheus

append_prometheus_config:
  file.append:
    - name: /etc/prometheus/prometheus.yml
    - text: |
        global:
          scrape_interval: 10s

        scrape_configs:
          - job_name: 'prometheus'
            scrape_interval: 5s
            static_configs:
              - targets: ['localhost:9200']
          - job_name: 'mysql'
            scrape_interval: 5s
            static_configs:
              - targets: ['192.168.18.151:9200']

          - job_name: 'wp'
            scrape_interval: 5s
            static_configs:
              - targets: ['192.168.18.152:9200']

          - job_name: 'apache'
            scrape_interval: 5s
            static_configs:
              - targets: ['192.168.18.153:9200']

set_prometheus_config_permissions:
  file.managed:
    - name: /etc/prometheus/prometheus.yml
    - user: prometheus
    - group: prometheus
    - mode: 644
    - require:
      - file: append_prometheus_config

deploy_prometheus_service:
  file.managed:
    - name: /etc/systemd/system/prometheus.service
    - source: salt://wp-automation/files/prometheus.service
    - user: root
    - group: root
    - mode: 644


reload_systemd:
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - file: deploy_prometheus_service

enable_prometheus_service:
  service.enabled:
    - name: prometheus
    - require:
      - cmd: reload_systemd

start_prometheus_service:
  service.running:
    - name: prometheus
    - enable: True
    - require:
      - file: /etc/systemd/system/prometheus.service