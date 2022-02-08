# MainsailOS-slipway
#
# An easy way to run an MainsailOS Image for developing
# on a local machine without need for Bare Metal
#
# Copyright 2022 Stephan Wendel <me@stephanwe.de>
#
# This file may distributed under GPL v3

ARG VERSION=3.15
FROM alpine:${VERSION}

# env
ENV SW_USER="slipway"
# create env
RUN apk add -U --no-cache qemu-system-arm && \
    addgroup --gid 1000 ${SW_USER} && \
    mkdir -p /home/${SW_USER} && \
    adduser -D -h /home/${SW_USER} -G ${SW_USER} ${SW_USER} && \
    addgroup ${SW_USER} qemu && \
    addgroup ${SW_USER} kvm
# copy entrypoint.sh
COPY --chown=root:root ./entrypoint.sh /bin/
# copy emulation kernels and dtb
COPY --chown=${SW_USER}:${SW_USER} ./emulation /home/${SW_USER}/emulation/
# create mount point
VOLUME /home/${SW_USER}/zipfile


# run container as unprivileged user
USER ${SW_USER}
WORKDIR /home/${SW_USER}
RUN mkdir -p /home/${SW_USER}/image

EXPOSE 7125
EXPOSE 2222
EXPOSE 8080

# entypoint
CMD [ "entrypoint.sh" ]
