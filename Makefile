DOCKER_IMAGE ?= zmk-charybdis-build
DOCKER_RUN ?= docker run --rm -it -v "$(CURDIR):/workdir" -w /workdir $(DOCKER_IMAGE)

BOARD ?= nice_nano_v2

.PHONY: docker-image shell west-init build-left build-right build-reset build-all clean

docker-image:
	docker build -t $(DOCKER_IMAGE) .

shell: docker-image
	$(DOCKER_RUN) bash

west-init:
	test -d .west || west init -l config
	west update
	west zephyr-export

build-left: docker-image
	$(DOCKER_RUN) make _build-left

build-right: docker-image
	$(DOCKER_RUN) make _build-right

build-reset: docker-image
	$(DOCKER_RUN) make _build-reset

build-all: docker-image
	$(DOCKER_RUN) make _build-all

clean:
	rm -rf build

.PHONY: _build-left _build-right _build-reset _build-all

_build-left: west-init
	west build -s zmk/app -d build/charybdis_left -b $(BOARD) -- -DSHIELD=charybdis_left

_build-right: west-init
	west build -s zmk/app -d build/charybdis_right -b $(BOARD) -- -DSHIELD=charybdis_right -DSNIPPET=studio-rpc-usb-uart -DCONFIG_ZMK_STUDIO=y

_build-reset: west-init
	west build -s zmk/app -d build/settings_reset -b $(BOARD) -- -DSHIELD=settings_reset

_build-all: _build-left _build-right _build-reset
