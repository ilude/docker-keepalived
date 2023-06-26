
COMPOSE_COMMAND = docker compose

# get the last octet of the default route ip and use it as the keepalived priority
export KEEPALIVED_PRIORITY := $(shell ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' |  awk -F '\\.' '{print $$NF}')
export KEEPALIVED_INTERFACE := $(shell ip route get 8.8.8.8 | awk -- '{printf $$5}')
export KEEPALIVED_VIRTUAL_IPS:=192.168.30.40
export KEEPALIVED_UNICAST_PEERS:=$(shell echo "\#PYTHON2BASH:['192.168.30.41', '192.168.30.42']")

start: 
	$(COMPOSE_COMMAND) $(FLAGS) up -d --force-recreate --remove-orphans

up: 
	-$(COMPOSE_COMMAND) $(FLAGS) up --force-recreate --abort-on-container-exit --remove-orphans
	$(MAKE) down

down: 
	$(COMPOSE_COMMAND) $(FLAGS) down

echo:
	@echo KEEPALIVED_PRIORITY: $(KEEPALIVED_PRIORITY)
	@echo KEEPALIVED_INTERFACE: $(KEEPALIVED_INTERFACE)
	@echo KEEPALIVED_VIRTUAL_IPS: $(KEEPALIVED_VIRTUAL_IPS)
	@echo KEEPALIVED_UNICAST_PEERS: $(KEEPALIVED_UNICAST_PEERS)

logs: 
	$(COMPOSE_COMMAND)  $(FLAGS) logs -f