DOCKER_IMAGE ?= zmk-charybdis-build
DOCKER_RUN ?= docker run --rm -it -v "$(CURDIR):/workdir" -w /workdir $(DOCKER_IMAGE)

BOARD ?= nice_nano_v2
ZMK_CONFIG ?= $(CURDIR)/config

.PHONY: docker-image shell west-init build-left build-right build-right-peripheral build-dongle build-reset build-senyatyl-left build-senyatyl-right build-senyatyl-right-peripheral build-senyatyl-right-nomouse build-senyatyl-right-col2row build-senyatyl-all build-all clean

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

build-right-peripheral: docker-image
	$(DOCKER_RUN) make _build-right-peripheral

build-dongle: docker-image
	$(DOCKER_RUN) make _build-dongle

build-reset: docker-image
	$(DOCKER_RUN) make _build-reset

build-senyatyl-left: docker-image
	$(DOCKER_RUN) make _build-senyatyl-left

build-senyatyl-right: docker-image
	$(DOCKER_RUN) make _build-senyatyl-right

build-senyatyl-right-peripheral: docker-image
	$(DOCKER_RUN) make _build-senyatyl-right-peripheral

build-senyatyl-right-nomouse: docker-image
	$(DOCKER_RUN) make _build-senyatyl-right-nomouse

build-senyatyl-right-col2row: docker-image
	$(DOCKER_RUN) make _build-senyatyl-right-col2row

build-senyatyl-all: docker-image
	$(DOCKER_RUN) make _build-senyatyl-all

build-all: docker-image
	$(DOCKER_RUN) make _build-all

clean:
	rm -rf build

.PHONY: _build-left _build-right _build-right-peripheral _build-dongle _build-reset _build-senyatyl-left _build-senyatyl-right _build-senyatyl-right-peripheral _build-senyatyl-right-nomouse _build-senyatyl-right-col2row _build-senyatyl-all _build-all

_build-left: west-init
	west build -p always -s zmk/app -d build/charybdis_left -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=charybdis_left

_build-right: west-init
	west build -p always -s zmk/app -d build/charybdis_right -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=charybdis_right -DSNIPPET=studio-rpc-usb-uart -DCONFIG_ZMK_STUDIO=y

_build-right-peripheral: west-init
	west build -p always -s zmk/app -d build/charybdis_right_peripheral -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=charybdis_right_peripheral

_build-dongle: west-init
	west build -p always -s zmk/app -d build/charybdis_dongle -b seeeduino_xiao_ble -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD="charybdis_dongle prospector_adapter"

_build-reset: west-init
	west build -p always -s zmk/app -d build/settings_reset -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=settings_reset

_build-senyatyl-left: west-init
	west build -p always -s zmk/app -d build/senyatyl_left -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=senyatyl_left

_build-senyatyl-right: west-init
	west build -p always -s zmk/app -d build/senyatyl_right -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=senyatyl_right

_build-senyatyl-right-peripheral: west-init
	west build -p always -s zmk/app -d build/senyatyl_right_peripheral -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=senyatyl_right_peripheral

_build-senyatyl-right-nomouse: west-init
	west build -p always -s zmk/app -d build/senyatyl_right_nomouse -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=senyatyl_right_nomouse

_build-senyatyl-right-col2row: west-init
	west build -p always -s zmk/app -d build/senyatyl_right_col2row -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=senyatyl_right_col2row

_build-senyatyl-all: _build-senyatyl-left _build-senyatyl-right _build-senyatyl-right-peripheral _build-senyatyl-right-nomouse _build-senyatyl-right-col2row

_build-all: _build-left _build-right _build-right-peripheral _build-dongle _build-reset
