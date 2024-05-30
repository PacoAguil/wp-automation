execute_ct_init:
  salt.state:
    - tgt: 'pve-tfg'
    - sls: wp-automation.states.ct_init

execute_salt_install:
  salt.state:
    - tgt: 'pve-tfg'
    - sls: wp-automation.states.salt_install

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

#execute_state_minion3:
#  salt.state:
#    - tgt: 'minion3'
#    - sls: my_state_minion3