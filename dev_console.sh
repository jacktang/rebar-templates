erl -pa ./ebin/ -pa deps/*/ebin \
    {{ name_option }} \
    {{ erl_vm_flags }} \
    {{ env_vars }} \
    {{ config_files }} \
    {{ mnesia_options }} \
    {{ start_services }} \
