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