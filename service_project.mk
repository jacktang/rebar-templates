##
## - WARNING -
##
## Do not edit this file if possible.
## project.mk is meant to be common for all services.
## It's better to change Makefile instead.
## If you really need to change this file, consider
## making the change generic and update the file in
## rebar-templates as well:
## https://github.com/EchoTeam/rebar-templates/blob/master/service_project.mk
##

.PHONY: all compile test clean target upgrade generate rel run
.PHONY: update_lock get_deps update_deps

REBAR_BIN := $(abspath ./)/rel/../rebar # "rel/../" is a workaround for rebar bug
ifeq ($(wildcard $(REBAR_BIN)),)
	REBAR_BIN := $(shell which rebar)
endif
REBAR_FREEDOM := $(REBAR_BIN) -C rebar.config
REBAR_LOCKED  := $(REBAR_BIN) -C rebar.config.lock apps=$(SERVICE_NAME)
REBAR := $(REBAR_FREEDOM)

DEFAULT_DEPS_DIR := $(abspath deps)
DEFAULT_LOG_DIR  := /var/log/$(SERVICE_NAME)
DEV_LOG_DIR      := $(abspath ./rel/$(SERVICE_NAME)/log)

ifdef ECHO_DEPS_DIR
	DEV_DEPS_DIR := $(ECHO_DEPS_DIR)
else
	DEV_DEPS_DIR := $(DEFAULT_DEPS_DIR)
endif

all: compile

compile:
	$(REBAR) compile
	
update_lock:
	rm -rf deps
	$(REBAR_FREEDOM) get-deps
	$(REBAR_FREEDOM) lock-deps apps=$(SERVICE_NAME) keep_first=lager

get_deps:
	$(REBAR_LOCKED) get-deps

update_deps: get_deps
	$(REBAR_LOCKED) update-deps

rel:
	$(MAKE) -C rel DEPS_DIR=$(DEPS_DIR) LOG_DIR="$(LOG_DIR)"

generate: compile rel
	$(eval relvsn := $(shell bin/relvsn-get.erl))
	cd rel; $(REBAR_BIN) generate -f
	cp rel/$(SERVICE_NAME)/releases/$(relvsn)/$(SERVICE_NAME).boot rel/$(SERVICE_NAME)/releases/$(relvsn)/start.boot #workaround for rebar bug
	echo $(relvsn) > rel/$(SERVICE_NAME)/relvsn

clean:
	$(REBAR) clean

test:
	$(REBAR) eunit skip_deps=meck,lager

# make target system for production
target: clean update_deps
	$(MAKE) generate DEPS_DIR="$(DEFAULT_DEPS_DIR)" LOG_DIR="$(DEFAULT_LOG_DIR)"


######################################
## All targets below are for use    ##
## in development environment only. ##
######################################

# generates upgrade upon what is in rel/$(SERVICE_NAME)
upgrade:
	@[ -f rel/$(SERVICE_NAME)/relvsn ] || (echo "Run 'make target' first" && exit 1)
	$(eval prev_vsn := $(shell cat rel/$(SERVICE_NAME)/relvsn))
	-rm -rf rel/$(SERVICE_NAME)_$(prev_vsn)
	mv rel/$(SERVICE_NAME) rel/$(SERVICE_NAME)_$(prev_vsn)
	$(MAKE) generate DEPS_DIR="$(DEV_DEPS_DIR)" LOG_DIR="$(DEV_LOG_DIR)"
	cd rel; $(REBAR_BIN) generate-upgrade previous_release=$(SERVICE_NAME)_$(prev_vsn)

# generate upgrade upon a specific git revision
upgrade_from: clean
	$(eval cur_rev := $(shell git rev-parse --abbrev-ref HEAD))
	git checkout $(rev)
	$(MAKE) target DEPS_DIR="$(DEV_DEPS_DIR)" LOG_DIR="$(DEV_LOG_DIR)"
	git checkout $(cur_rev)
	$(MAKE) upgrade DEPS_DIR="$(DEV_DEPS_DIR)" LOG_DIR="$(DEV_LOG_DIR)"

# runs the service
run: get_deps
	export REBAR_DEPS_DIR="$(DEV_DEPS_DIR)" && \
	$(MAKE) generate DEPS_DIR="$(DEV_DEPS_DIR)" LOG_DIR="$(DEV_LOG_DIR)"
	./rel/$(SERVICE_NAME)/bin/$(SERVICE_NAME) -u `whoami` -l "$(DEV_LOG_DIR)" console -s sync
