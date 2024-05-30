# Descarga la plantilla de los contenedores inicial
download_debian_11_template:
  cmd.run:
    - name: pveam download local debian-11-standard_11.7-1_amd64.tar.zst
    - unless: ls /var/lib/vz/template/cache/ | grep debian-11
# Inicialización de los contenedores
ct_mysql_init:
  cmd.run:
    - name: |
        pct create 101 /var/lib/vz/template/cache/debian-11-standard_11.7-1_amd64.tar.zst \
        --hostname mysql \
        --net0 name=eth0,bridge=vmbr0,firewall=1,gw=192.168.18.1,ip=192.168.18.151/24,type=veth \
        --password servertfg \
        --storage local-lvm \
        --rootfs local-lvm:2 \
        --memory 1024 \
        --swap 0 
    - unless: pct list |grep 101

set_nesting_mysql:
  cmd.run:
    - name: pct set 101 -features nesting=1
    - require:
      - cmd: ct_mysql_init

ct_wp_init:
  cmd.run:
    - name: |
        pct create 102 /var/lib/vz/template/cache/debian-11-standard_11.7-1_amd64.tar.zst \
        --hostname wp \
        --net0 name=eth0,bridge=vmbr0,firewall=1,gw=192.168.18.1,ip=192.168.18.152/24,type=veth \
        --password servertfg \
        --storage local-lvm \
        --rootfs local-lvm:10 \
        --memory 2048 \
        --swap 0 
    - unless: pct list |grep 102

set_nesting_wp:
  cmd.run:
    - name: pct set 102 -features nesting=1
    - require:
      - cmd: ct_wp_init

ct_apache_init:
  cmd.run:
    - name: |
        pct create 103 /var/lib/vz/template/cache/debian-11-standard_11.7-1_amd64.tar.zst \
        --hostname apache \
        --net0 name=eth0,bridge=vmbr0,firewall=1,gw=192.168.18.1,ip=192.168.18.153/24,type=veth \
        --password servertfg \
        --storage local-lvm \
        --rootfs local-lvm:10 \
        --memory 2048 \
        --swap 0 
    - unless: pct list |grep 103

set_nesting_apache:
  cmd.run:
    - name: pct set 103 -features nesting=1
    - require:
      - cmd: ct_apache_init

ct_prometheus_init:
  cmd.run:
    - name: |
        pct create 104 /var/lib/vz/template/cache/debian-11-standard_11.7-1_amd64.tar.zst \
        --hostname prometheus \
        --net0 name=eth0,bridge=vmbr0,firewall=1,gw=192.168.18.1,ip=192.168.18.154/24,type=veth \
        --password servertfg \
        --storage local-lvm \
        --rootfs local-lvm:10 \
        --memory 2048 \
        --swap 0 
    - unless: pct list |grep 104

set_nesting_prometheus:
  cmd.run:
    - name: pct set 104 -features nesting=1
    - require:
      - cmd: ct_prometheus_init    