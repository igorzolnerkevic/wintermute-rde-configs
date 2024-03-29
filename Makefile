# profiles.mk provides guix version specified by rde/channels-lock.scm
# To rebuild channels-lock.scm use `make -B rde/channels-lock.scm`
include profiles.mk

# Also defined in .envrc to make proper guix version available project-wide
GUIX_PROFILE=target/profiles/guix
GUIX=./pre-inst-env ${GUIX_PROFILE}/bin/guix

SRC_DIR=./src
CONFIGS=${SRC_DIR}/abismos/configs.scm
PULL_EXTRA_OPTIONS=
# --allow-downgrades

ROOT_MOUNT_POINT=/mnt

VERSION=latest

repl:
	${GUIX} repl -L ../tests \
	-L ../files/emacs/gider/src --listen=tcp:37146s

wintermute/home/build: guix
	RDE_TARGET=wintermute-home ${GUIX} home \
	build ${CONFIGS}

wintermute/home/reconfigure: guix
	RDE_TARGET=wintermute-home ${GUIX} home \
	reconfigure ${CONFIGS}

wintermute/system/build: guix
	RDE_TARGET=wintermute-system ${GUIX} system \
	build ${CONFIGS}

wintermute/system/reconfigure: guix
	RDE_TARGET=wintermute-system ${GUIX} system \
	reconfigure ${CONFIGS}

cow-store:
	sudo herd start cow-store ${ROOT_MOUNT_POINT}

wintermute/system/init: guix
	RDE_TARGET=wintermute-system ${GUIX} system \
	init ${CONFIGS} ${ROOT_MOUNT_POINT}

target:
	mkdir -p target

live/image/build: guix
	RDE_TARGET=live-system ${GUIX} system image --image-type=iso9660 \
	${CONFIGS}

target/rde-live.iso: guix target
	RDE_TARGET=live-system ${GUIX} system image --image-size=55G \
	${CONFIGS} -r target/rde-live-tmp.iso
	mv -f target/rde-live-tmp.iso target/rde-live.iso

target/release:
	mkdir -p target/release

# TODO: Prevent is rebuilds.
release/rde-live-x86_64: target/rde-live.iso target/release
	cp -df $< target/release/rde-live-${VERSION}-x86_64.iso
	gpg -ab target/release/rde-live-${VERSION}-x86_64.iso

clean-target:
	rm -rf ./target

clean: clean-target
