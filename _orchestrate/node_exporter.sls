node_exporter_srv:
  salt.state:
    - tgt: 'pve-tfg'
    - sls: wp-automation.states.node_exporter_install

node_exporter_mysql:
  salt.state:
    - tgt: 'mysql'
    - sls: wp-automation.states.node_exporter_install

node_exporter_wp:
  salt.state:
    - tgt: 'wp'
    - sls: wp-automation.states.node_exporter_install

node_exporter_apache:
  salt.state:
    - tgt: 'apache'
    - sls: wp-automation.states.node_exporter_install


node_exporter_prometheus:
  salt.state:
    - tgt: 'prometheus'
    - sls: wp-automation.states.node_exporter_install
    