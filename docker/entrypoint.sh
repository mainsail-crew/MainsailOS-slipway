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
    if [ -n "$(find "${HOME}/img_file" -name "*.zip")" ] ;then
        img_file="$(find "${HOME}/img_file" -name "*.zip")"
        ok_msg "Found file: $(basename "${img_file}") ..."
        ok_msg "Unzip to ${IMAGE_PATH} ..."
        unzip "${img_file}" -d "${IMAGE_PATH}"

    elif [ -n "$(find "${HOME}/img_file" -name "*.xz")" ] ;then
        img_file="$(find "${HOME}/img_file" -name "*.xz")"
        ok_msg "Found File: $(basename "${img_file}") ..."
        ok_msg "Unzip to ${IMAGE_PATH} ..."
        cp "${img_file}" "${IMAGE_PATH}/"
        cd "${IMAGE_PATH}"
        xz -devT"$(nproc)" "${img_file}"

    elif [ -n "$(find "${HOME}/img_file" -name "*.img")" ] ;then
        img_file="$(find "${HOME}/img_file" -name "*.img")"
        ok_msg "Found File: $(basename "${img_file}") ..."
        ok_msg "Copy to ${IMAGE_PATH} ..."
        cp "${img_file}" "${IMAGE_PATH}/"

    else
        fail_msg "No Image file found ... [EXITING]"
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
