erl -pa ./ebin/ -pa deps/*/ebin \
    {{ name_option }} \
    {{ boot_args }} {{ erl_vm_flags }} \
    {{ env_vars }} \
    {{ config_files }} \
    {{ mnesia_options }} \
    {{ start_services }} \
