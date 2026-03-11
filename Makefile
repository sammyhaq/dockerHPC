##
#
# Makefile
#
# Sammy Haq
# sammy.haq@outlook.com
# github.com/sammyhaq
#
# -- Usage:
#
# make <args>:
#
# <args>:
#
# 	build      build and start containers
# 	up         start containers only
# 	down       stop containers
# 	configure  run main ansible playbook to configure cluster
#   test       run all tests
# 	clean      remove all ocntainers and volumes
#
#   all        build, configure, and test
##

.PHONY: build up down configure test clean all

build:
	docker compose up -d --build

up:
	docker compose up -d

down:
	docker compose down

configure:
	docker exec controller ansible-playbook /etc/ansible/playbooks/site.yml

test:
	@echo "Testing /scratch dir .."
	docker exec controller touch /scratch/.test
	docker exec node01 ls /scratch/.test
	docker exec node02 ls /scratch/.test
	rm -f ./shared/scratch/.test

	@echo "Testing munge (controller) .."
	docker exec controller munge -n | docker exec -i controller unmunge

	@echo "Testing munge (nodes) .."
	docker exec controller munge -n | docker exec -i node01 unmunge
	docker exec controller munge -n | docker exec -i node02 unmunge

	@echo "Testing SLURM .."
	docker exec controller sinfo
	docker exec controller scontrol show nodes

	@echo "  .. Testing complete."

clean:
	docker compose down -v
	rm -f ./shared/scratch/.test
	rm -f ./shared/home/.munge.key

all: build configure test
