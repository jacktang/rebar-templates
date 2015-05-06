# Rebar Templates #

## How to use templates ##

To make the templates available, you need to clone the repo to your
`~/.rebar/templates` directory:

    git clone git://github.com:jacktang/rebar-templates.git
    ln -s /path/to/rebar-templates ~/.rebar/templates

## Templates

### Rebar project

   $ ./rebar create template=project name=kickstart

### OTP standard application

   $ cd kickstart
   $ rebar create template=stdapp appid=<app_name>
   $ rebar create template=gensrv srvid=<srv_name>

### Cowboy application and handlers

   $ cd kickstart
   $ rebar create template=cowboy_app appid=<app_name>
   $ rebar create template=cowboy_handler handlerid=chat handlertype=websocket


### Wx-widget

   $ rebar create template=wx_object widgetid=button_ext

Requirements: erlang, git


See more info on the service layout:
 * [Basic development workflow](service/DEV.md)
 * [Makefile targets](service/MAKE.md)
 * [Working with deps](service/DEPS.md)
