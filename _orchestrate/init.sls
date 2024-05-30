execute_ct_init:
  salt.state:
    - tgt: 'pve-tfg'
    - sls: wp-automation.states.ct_init

execute_salt_install:
  salt.state:
    - tgt: 'pve-tfg'
    - sls: wp-automation.states.salt_install
