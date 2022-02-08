#!/bin/sh
# MainsailOS-slipway
#
# An easy way to run an MainsailOS Image for developing
# on a local machine without need for Bare Metal
#
# Copyright 2022 Stephan Wendel <me@stephanwe.de>
#
# This file may distributed under GPL v3

# shellcheck enable=require-variable-braces

# DEBUG
set -e
# set -x

# env variables
IMAGE_PATH="${HOME}/image"
# qemu setup, do not modify except you know what you are doing.
QEMU_BIN='qemu-system-arm'
QEMU_CPU='arm1176'
QEMU_RAM='256'
QEMU_KERNEL='emulation/kernel-qemu-5.4.51-buster'
QEMU_MACHINE='versatilepb'
QEMU_DTB='emulation/versatile-pb-buster-5.4.51.dtb'
QEMU_OPTIONS='-no-reboot -nographic'
QEMU_NET='-net user,ipv4=on,ipv6=on,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80,hostfwd=tcp::7125-:7125 -net nic'

# Message helpers
ok_msg() {
    printf '\e[32m%s\e[0m\n' "${*}"
}

fail_msg() {
    printf '\e[31m%s\e[0m\n' "${*}"
}

warn_msg() {
    printf '\e[33m%s\e[0m' "${*}"
}


# check for zip and unzip if exist
get_img() {
    _get_img_file=$(find "${HOME}/zipfile" -name "*.zip")
    if [ -n "${_get_img_file}" ] ;then
        ok_msg "Found Zipfile: $(basename "${_get_img_file}") ..."
        ok_msg "Unzip to ${IMAGE_PATH} ..."
        unzip "${_get_img_file}" -d "${IMAGE_PATH}"
    else
        fail_msg "No Zipfile found ... [EXITING]"
        exit 1
    fi
}

check_qemu() {
    if command -v "${QEMU_BIN}" > /dev/null 2>&1 ; then
        ok_msg "${QEMU_BIN} found ..."
    else
        fail_msg "${QEMU_BIN} not found ... [EXITING]"
        exit 127
    fi
}

set_img() {
    IMAGE=$(find "${HOME}/image" -name "*.img")
    if [ -n "${IMAGE}" ]; then
        ok_msg "Image found: ${IMAGE}"
    else
        fail_msg "No usable Image found ... [EXITING]"
        exit 1
    fi
}

# shellcheck disable=SC2086
run_img() {
    ok_msg "Starting qemu with Image: ${IMAGE}"
    qemu-system-arm -cpu "${QEMU_CPU}" -m "${QEMU_RAM}" \
    -kernel "${QEMU_KERNEL}" -M "${QEMU_MACHINE}" -dtb \
    ${QEMU_DTB} ${QEMU_OPTIONS} \
    -append 'dwc_otg.lpm_enable=0 root=/dev/vda2 panic=1 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait' \
    -drive file="${IMAGE}",if=none,index=0,media=disk,format=raw,id=disk0 ${QEMU_NET} \
    -device "virtio-blk-pci,drive=disk0,disable-modern=on,disable-legacy=off"
}

### MAIN ###
get_img
check_qemu
set_img
run_img

exit 0
