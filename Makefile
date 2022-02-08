# MainsailOS-slipway
#
# An easy way to run an MainsailOS Image for developing
# on a local machine without need for Bare Metal
#
# Copyright 2022 Stephan Wendel <me@stephanwe.de>
#
# This file may distributed under GPL v3

.PHONY: help run stop build

all: help

help:
	@echo "This is intended to run an Image of MainsailOS"
	@echo ""
	@echo " Usage: make [action]"
	@echo ""
	@echo "  Available actions:"
	@echo ""
	@echo "   help       Shows this Message :)"
	@echo "   run        Runs the Image with docker-compose"
	@echo "   stop       Stops the running container and cleans up"
	@echo ""

run:
	docker-compose up -d

stop:
	docker-compose down -v --rmi all --remove-orphans

build:
	@docker build -t mainsailos:slipway docker/
