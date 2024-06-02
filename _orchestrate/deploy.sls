#ping_pve_tfg:
#  salt.state:
#    - tgt: 'pve_tfg'
#    - sls: wp-automation.states.ping
#
#ping_mysql:
#  salt.state:
#    - tgt: 'mysql'
#    - sls: wp-automation.states.ping
#
execute_mysql:
  salt.state:
    - tgt: 'mysql'
    - sls: wp-automation.states.mysql

execute_apache_init:
  salt.state:
    - tgt: 'apache'
    - sls: wp-automation.states.apache_init

execute_wp_init:
  salt.state:
    - tgt: 'wp'
    - sls: wp-automation.states.wp_init

execute_state_prometheus:
  salt.state:
    - tgt: 'prometheus'
    - sls: wp-automation.states.prometheus