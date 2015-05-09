# Rebar Templates #

Rebar provides rails generator like facility, and Rebar-Templates give Erlang developers more templates and workflow.

## How to use templates ##

To make the templates available, you need to clone the repo to your
`~/.rebar/templates` directory:
```
   $ git clone git://github.com:jacktang/rebar-templates.git
   $ ln -s /path/to/rebar-templates ~/.rebar/templates
```
## Templates

### Rebar project
```
   $ ./rebar create template=project projectid=kickstart
```

### OTP standard application
```
   $ cd kickstart
   $ rebar create template=stdapp appid=<app_name>
   $ rebar create template=gensrv srvid=<srv_name>
   $ rebar create template=genfsm fmsid=<fsn_name>
   $ rebar create template=genevent eventid=<event_name>
```

### Cowboy application and handlers
```
   $ cd kickstart
   $ rebar create template=cowboy_app appid=<app_name>
   $ rebar create template=cowboy_handler handlerid=chat handlertype=websocket
```

### Wx-widget
```
   $ rebar create template=wx_object widgetid=button_ext
```

### Test-driven skeleton? Of course! And generate test case only like below
```
  $ rebar create template=test testmod=<module_name> test=ct
  $ rebar create template=test testmod=<module_name> test=eunit
  $ rebar create template=test testmod=<module_name> test=spec
```

### Console with hot-load in developement mode

Edit `template_vars` in rebar.config and execute below command.
**NOTE: rebar should be built from [the branch](https://github.com/jacktang/rebar/tree/ext-template)**
```
  $ rebar create template=dev_console
```

Requirements: Erlang, Git


See more info on the service layout:
 * [Basic development workflow](service/DEV.md)
 * [Makefile targets](service/MAKE.md)
 * [Working with deps](service/DEPS.md)
